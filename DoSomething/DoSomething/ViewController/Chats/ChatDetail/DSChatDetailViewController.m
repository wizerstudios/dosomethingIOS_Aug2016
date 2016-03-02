//
//  DSChatDetailViewController.m
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/27/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSChatDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "AppDelegate.h"
#import "DSWebservice.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"

#define CONTENT_WIDTH           200.f
#define CONTENT_START           0.f
#define BUBBLE_IMAGE_HEIGHT     10.f
#define BUBBLE_WIDTH            250.f
#define BUBBLE_WIDTH_SPACE      70.f
#define CELL_HEIGHT             CONTENT_START+15.f
#define ME_RIGHT_WIDTH_SPACE    25.0f


@interface DSChatDetailViewController (){
    
    NSUInteger supportUser;
    
    NSMutableArray *conversationArray;
    
    DSWebservice *webService;
    
    CGSize dataSize;
    CGSize windowSize;
    NSMutableArray *chatArray;
    ChatDetailCustomcell *ChatDetailcell;
    int height;
    NSMutableArray * recevierDetails;
}

@end

@implementation DSChatDetailViewController
@synthesize chatView,ProfileName,ProfileImage;
@synthesize chatuserDetailsDict,chatButton;
@synthesize messageTimer;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"conversionID=%@",_conversionID);
    
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[chatScrollview class]];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    webService = [[DSWebservice alloc]init];
    
    conversationArray = [[NSMutableArray alloc]init];
    recevierDetails =[[NSMutableArray alloc]init];
    [self displayUserDetailsView];
    
    [self loadConverstionAPI];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard:)];
    
    [chatTableView addGestureRecognizer:tapGestureRecognizer];
}
- (void)viewWillAppear:(BOOL)animated
{
     [self loadNavigation];
    [super viewWillAppear:animated];
    
     messageTimer = [NSTimer scheduledTimerWithTimeInterval:timerSeconds target:self selector:@selector(loadConverstionAPI) userInfo:nil repeats:YES];
    
    [chatView.postButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
     [chatScrollview setScrollEnabled:NO];
    
}

-(void)viewwillDisappear:(BOOL)animated{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [messageTimer invalidate];
         messageTimer =nil;
    });
  
     [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
  
    dispatch_async(dispatch_get_main_queue(), ^{
        [messageTimer invalidate];
        messageTimer =nil;
    });
      [super viewDidDisappear:animated];
    
}


- (void)viewWillLayoutSubviews {
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        [self setUpForPortrait];
    } else {
        [self setUpForLandscape];
    }
    
    if (self.standardIBAS.visible) {
        [self.standardIBAS rotateToCurrentOrientation];
    }
    if (self.customIBAS.visible) {
        [self.customIBAS rotateToCurrentOrientation];
    }
    if (self.funkyIBAS.visible) {
        [self.funkyIBAS rotateToCurrentOrientation];
    }
}
#pragma mark - Navigation

-(void)loadNavigation{
    
    CustomNavigationView *customNavigation;
    
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
     self.topviewYposition.constant = customNavigation.view.frame.size.height;//65
    
    if (IS_IPHONE6 )
    {
    
         customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 76);
         self.chatviewbottom.constant =420;
         self.chattableheight.constant =10;
         self.blockBtnYOrigin.constant = 435;
        self.topviewYposition.constant = customNavigation.view.frame.origin.y+customNavigation.view.frame.size.height+28;
         self.menuImageyOrigin.constant = 93;
        
    }
    
    if(IS_IPHONE6_Plus)
    {
        
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        self.chatviewbottom.constant =488;
        self.chattableheight.constant =10;
        self.blockBtnYOrigin.constant = 505;
        self.topviewYposition.constant = customNavigation.view.frame.size.height+5;
        self.menuImageyOrigin.constant = 95;
    }
    
   
    
    [customNavigation.menuBtn setHidden:YES];
    
    [customNavigation.buttonBack setHidden:NO];
    
    [customNavigation.saveBtn setHidden:YES];
    
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void) removeKeyboard: (UITapGestureRecognizer *)recognizer
{
    [chatTableView setContentInset:UIEdgeInsetsMake(0,0, 0, 0)];
    
    [[IQKeyboardManager sharedManager]resignFirstResponder];
}
- (void)backAction
{
    [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"backAction"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)displayUserDetailsView{
    
    ProfileName.text= [chatuserDetailsDict valueForKey:@"Name"];
    
    NSString *profileStr = [NSString stringWithFormat:@"%@",[chatuserDetailsDict valueForKey:@"image1"]];
    
    supportUser = [[chatuserDetailsDict valueForKey:@"supportuser"]integerValue];
        
    NSLog(@"profileStr = %@",profileStr);
    
    if([profileStr length]>0){
        
        downloadImageFromUrl(profileStr, ProfileImage);
        
        ProfileImage.image = [UIImage imageNamed:profileStr];
        
    }else{
        
        ProfileImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"profile_noimg.png"]];
        
    }
    
    [ProfileImage.layer setCornerRadius:28];
    
    [ProfileImage.layer setMasksToBounds:YES];
    
    if(supportUser == 1){
        
        [ProfileImage.layer setBorderWidth:2.0f];
        
        [ProfileImage.layer setBorderColor:[[UIColor colorWithRed:229.0f/255.0f green:63.0f/255.0f blue:81.0f/255.0f alpha:1.0f] CGColor]];
        
        [chatButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_icon"]] forState:UIControlStateNormal];
        
        [chatButton setContentMode:UIViewContentModeScaleAspectFit];
        
        [chatButton setUserInteractionEnabled:NO];
        
    }
    else{
        
        [chatButton setBackgroundImage:[UIImage imageNamed:@"menu_active"] forState:UIControlStateNormal];
        
        [chatButton setUserInteractionEnabled:YES];
    }
    
      [chatButton setContentMode:UIViewContentModeScaleToFill];
    NSString * selectuserstatus=( self.status == nil)?@"online":@"online";
    OnlineLabel.text =selectuserstatus;
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    

}


#pragma mark - Textview


-(void)textViewDidBeginEditing:(UITextView *)textView{
 
   [messageTimer invalidate];
    messageTimer = nil;
    
    [chatScrollview setScrollEnabled:NO];
    if (chatTableView.contentSize.height < chatTableView.frame.size.height)
    {
        [chatTableView setContentInset:UIEdgeInsetsMake(200,0, 0, 0)];

    }
    else{
        [chatTableView setContentInset:UIEdgeInsetsMake(200,0, 0, 0)];
    }

    [chatView.placeHolderLabel setHidden:YES];
    
   
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@""])
         [chatView.placeHolderLabel setHidden:NO];
    
    [chatTableView setContentInset:UIEdgeInsetsMake(0,0, 0, 0)];
    
    [self.view endEditing:YES];
    
    [chatScrollview setContentOffset:CGPointMake(0,0)];
    
     messageTimer = [NSTimer scheduledTimerWithTimeInterval:timerSeconds target:self selector:@selector(loadConverstionAPI) userInfo:nil repeats:YES];
    
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [conversationArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text      = [[conversationArray objectAtIndex:[indexPath row]] valueForKey:@"Message"];
    CGSize dataSize = [COMMON dataSize:text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)];
    return dataSize.height + CELL_HEIGHT+10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
     ChatDetailcell = (ChatDetailCustomcell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (ChatDetailcell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ChatDetailCustomcell" owner:self options:nil];
        ChatDetailcell = chatCustomcell;
    }
    
    
    [ChatDetailcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [ChatDetailcell getMessageArray:[conversationArray objectAtIndex:indexPath.row]];
    return ChatDetailcell;
    
}



#pragma mark - All the other junk for the sample project

- (void)setUpForPortrait {
    
    float halfOfWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0;
    float height1 = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    self.semiTransparentView.frame = CGRectMake(0, 0, halfOfWidth * 2.0, height1+40);
    self.semiTransparentView.center = CGPointMake(halfOfWidth, height1 /0);
    
    self.funkyIBASButton.center = CGPointMake(halfOfWidth, (height1 / 2.0) +120);
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        height1 -= 0;
    }
}
- (void)setUpForLandscape
{
    float halfOfWidth = CGRectGetHeight([UIScreen mainScreen].bounds) / 2.0;
    float height1 = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.funkyIBASButton.center = CGPointMake(halfOfWidth, (height1 / 2.0) + 120);
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        height1 -= 0;
    }
}

- (void)addBorderToButton:(UIButton *)button
{
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        button.frame = CGRectMake(CGRectGetMinX(button.frame), CGRectGetMinY(button.frame), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame) + 0);
        return;
    }
    
    button.layer.cornerRadius = 0.0f;
    button.layer.borderWidth = 0.0f;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
}

#pragma mark - Button Actions

- (IBAction)pressCancel:(id)sender {
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
    _menuImageview.hidden = NO;
    
}

- (IBAction)pressDelete:(id)sender {
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
    _menuImageview.hidden = NO;
    
    [self loadDeleteUserChatHistory];
    
}

- (IBAction)pressBlock:(id)sender {
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
    _menuImageview.hidden = NO;
    [self loadblockUser];
    
}
- (IBAction)showReallyFunkyIBActionSheet:(id)sender
{
    _menuImageview.hidden = YES;
    
    _transparentView.hidden = NO;
    
    _backgroundView.hidden = NO;
    
    [self.view endEditing:YES];
   

}

-(void)sendAction:(id)sender{
    
    NSString *conversationID;
    NSString *str=chatView.textView.text;
    
    NSString *receiverId = [chatuserDetailsDict valueForKey:@"UserId"];
    if(_conversionID==nil)
    {
        conversationID = [chatuserDetailsDict valueForKey:@"id"];
    }
    else
    {
        conversationID=_conversionID;
    }
   
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
        CGPoint position = [chatView convertPoint:CGPointZero toView: chatTableView ];
    NSIndexPath *indexPath = [chatTableView indexPathForRowAtPoint: position];
    
   ChatDetailcell = (ChatDetailCustomcell*)[chatTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",str);
    if(conversationArray.count > 1)
    {
        [ChatDetailcell getMessageArray:[conversationArray objectAtIndex:indexPath.row]];
    }
    if([str length] > 0){
        
       // [self.view endEditing:YES];
       
      NSMutableDictionary*AddDIcconversion =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",str],@"Message",@"SENDER",@"type",[COMMON getCurrentDateTime],@"senttime", nil];
        [conversationArray addObject:AddDIcconversion];
        
        [chatTableView reloadData];
        
        if (chatTableView.contentSize.height < chatTableView.frame.size.height)
            [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:conversationArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        else
           [chatTableView scrollRectToVisible:CGRectMake(0, chatTableView.contentSize.height - chatTableView.bounds.size.height, chatTableView.bounds.size.width,chatTableView.bounds.size.height) animated:NO];
      
        [self loadSendMessageAPI:receiverId conversationId:conversationID];
       
        
        
        
    }
    chatView.textView.text=@"";
    //[[IQKeyboardManager sharedManager]resignFirstResponder];
}


#pragma mark - Webservice Method

-(void)loadConverstionAPI{
    
    NSString *conversationID;
    
    if(_conversionID==nil)
          conversationID = [chatuserDetailsDict valueForKey:@"id"];
    
    else
        conversationID=_conversionID;
    
    
    [webService getConversation:GetConversation sessionID:[COMMON getSessionID] conversationId:conversationID dateTime:[COMMON getCurrentDateTime]
                        success:^(AFHTTPRequestOperation *operation, id responseObject){
                            
                            NSLog(@"Conversation resp = %@",responseObject);
                            
                            
                            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc]init];
                            
                            responseDict = [[responseObject valueForKey:@"getconversation"]mutableCopy];
                            
                            if([[responseDict valueForKey:@"status"]isEqualToString:@"success"]){
                                
                                
                                if([conversationArray count])
                                   [conversationArray removeAllObjects];
                                
                                conversationArray = [[responseDict valueForKey:@"converation"]mutableCopy];
                                 recevierDetails=[[responseDict valueForKey:@"receiver"] mutableCopy];
                                NSString * objonline = [[recevierDetails valueForKey:@"online_status"] componentsJoinedByString:@""];
                                NSString *onlinestatus=([objonline isEqualToString: @"0"])?@"offline":@"online";
                                OnlineLabel.text =onlinestatus;
                                
                                [chatTableView reloadData];
                                if (chatTableView.contentSize.height > chatTableView.frame.size.height)
                                    [chatTableView scrollRectToVisible:CGRectMake(0, chatTableView.contentSize.height - chatTableView.bounds.size.height, chatTableView.bounds.size.width,chatTableView.bounds.size.height) animated:YES];
                                else{
                                   [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:conversationArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                }
                                
                                
                            }
                            else{
                                [messageTimer invalidate];
                            }
                            
                        }
     
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            [COMMON removeLoading];
                            
                        }];
    
}

-(void)loadSendMessageAPI:(NSString *)_receiverId conversationId:(NSString *)_conversationId{
    
                    [webService sendMessage:SendMessage_API sessionid:[COMMON getSessionID] message_send_user_id:_receiverId message:chatView.textView.text conversation_id:_conversationId success:^(AFHTTPRequestOperation *operation, id responseObject){
                        
                        NSLog(@"Conversation resp = %@",responseObject);
                        NSMutableDictionary *msgResponseDict = [[NSMutableDictionary alloc]init];
                        
                        msgResponseDict = [responseObject valueForKey:@"sendmessage"];
                        
                        if([[msgResponseDict valueForKey:@"status"]isEqualToString:@"success"]){
                            
                            [self loadConverstionAPI];
                            
                        }
                       [COMMON removeLoading];
                        
                    }
     
                    failure:^(AFHTTPRequestOperation *operation, id error) {
                        [COMMON removeLoading];
                        
                    }];

    
}

#pragma deleteuserchatdetails, Blockuser
-(void)loadDeleteUserChatHistory
{
     NSString *conversationID = [chatuserDetailsDict valueForKey:@"id"];
    
    [webService deleteUserChatHist:DeleteConversation sessionid:[COMMON getSessionID] chat_user_id:conversationID success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
       
    }];
}
-(void)loadblockUser
{
     NSString *conversationID = [chatuserDetailsDict valueForKey:@"id"];
    
    [webService blockUser:BlockUser_API sessionid:[COMMON getSessionID] block_user_id:conversationID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@",responseObject);
        [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"backAction"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}
@end
