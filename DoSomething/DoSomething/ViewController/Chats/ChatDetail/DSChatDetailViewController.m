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
#import "UIImageView+AFNetworking.h"

#define CONTENT_WIDTH           200.f
#define CONTENT_START           0.f
#define BUBBLE_IMAGE_HEIGHT     10.f
#define BUBBLE_WIDTH            250.f
#define BUBBLE_WIDTH_SPACE      70.f
#define CELL_HEIGHT             CONTENT_START+15.f
#define ME_RIGHT_WIDTH_SPACE    25.0f

#define Red_Color   [UIColor colorWithRed:227.0f/255.0f green:64.0f/255.0f blue:81.0f/255.0f alpha:1.0f]

@interface DSChatDetailViewController (){
    
    AppDelegate *appDelegate;
    
    NSUInteger supportUser;
    
    NSMutableArray *conversationArray;
    
    DSWebservice *webService;
    
    CGSize dataSize;
    CGSize windowSize;
    NSMutableArray *chatArray;
    ChatDetailCustomcell *ChatDetailcell;
    int height;
    NSMutableArray * recevierDetails;
    BOOL  iskeyboardapear;
    UIButton * blueCirecleBtn;
    NSMutableDictionary *msgResponseDict;
    UIView * CommWalkView;
}

@end

@implementation DSChatDetailViewController
@synthesize chatView,ProfileName,ProfileImage;
@synthesize chatuserDetailsDict,chatButton;
@synthesize messageTimer;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [COMMON TrackerWithName:@"Chat Detail"];
    self.WalkAlterview.hidden =YES;
   
    NSString * Firstlogin=[[NSUserDefaults standardUserDefaults]valueForKey:FirstloginChatview];
    
    if([Firstlogin isEqualToString:@"Yes"])
    {
        [self GerenalWalkAlterview];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:FirstloginChatview];
    }

    NSLog(@"conversionID=%@",_conversionID);
    
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[chatScrollview class]];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    
    webService = [[DSWebservice alloc]init];
    //iskeyboardapear=NO;
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
    
    [_matchUnMatchButton setHidden:YES];
    
    [_unMatchBtn setTitle:@"Unmatch" forState:UIControlStateNormal];
    [_unMatchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _unMatchBtn.titleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:15];
   
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
    
         customNavigation.view.frame = CGRectMake(0,-20,375, 76);
         self.chatviewbottom.constant =420;
         self.chattableheight.constant =10;
         self.blockBtnYOrigin.constant = 435;
         self.topviewYposition.constant = customNavigation.view.frame.origin.y+customNavigation.view.frame.size.height+28;
         self.menuImageyOrigin.constant = 93;
    }
    else if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        self.chatviewbottom.constant =488;
        self.chattableheight.constant =10;
        self.blockBtnYOrigin.constant = 505;
        self.topviewYposition.constant = customNavigation.view.frame.size.height+5;
        self.menuImageyOrigin.constant = 95;
    }
    else if(IS_IPHONE4){
        self.chatviewbottom.constant =256;
         self.blockBtnYOrigin.constant = 250;
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
    iskeyboardapear=NO;
    
}
- (void)backAction
{
    [COMMON DSRemoveLoading];
    [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"backAction"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DSChatDetailBackAction"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)displayUserDetailsView{
    
    ProfileName.text= [chatuserDetailsDict valueForKey:@"Name"];
    
    NSString *profileStr = [NSString stringWithFormat:@"%@",[chatuserDetailsDict valueForKey:@"image1"]];
    
    supportUser = [[chatuserDetailsDict valueForKey:@"supportuser"]integerValue];
        
    
    
    if([profileStr length]>0){
        
        [ProfileImage setImageWithURL:[NSURL URLWithString:profileStr]];
        
//        downloadImageFromUrl(profileStr, ProfileImage);
        
//        ProfileImage.image = [UIImage imageNamed:profileStr];
        
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
    NSString * selectuserstatus=(self.status == nil)?@"online":@"online";
    OnlineLabel.text = selectuserstatus;
    
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
    messageTimer = [NSTimer scheduledTimerWithTimeInterval:timerSeconds target:self selector:@selector(loadConverstionAPI) userInfo:nil repeats:YES];
    iskeyboardapear=YES;
   
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@""])
         [chatView.placeHolderLabel setHidden:NO];
    
    [chatTableView setContentInset:UIEdgeInsetsMake(0,0, 0, 0)];
    
    [self.view endEditing:YES];
    
    [chatScrollview setContentOffset:CGPointMake(0,0)];
    
     messageTimer = [NSTimer scheduledTimerWithTimeInterval:timerSeconds target:self selector:@selector(loadConverstionAPI) userInfo:nil repeats:YES];
    iskeyboardapear=NO;
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
    
//    NSString *text      = [[conversationArray objectAtIndex:[indexPath row]] valueForKey:@"Message"];
//    CGSize dataSize1 = [COMMON dataSize:text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)];
//    return dataSize1.height + CELL_HEIGHT+10;

    
    NSString *text      = [[conversationArray objectAtIndex:[indexPath row]] valueForKey:@"Message"];
    NSString *cellIdentifier = @"Cell";
    ChatDetailcell = (ChatDetailCustomcell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];[[NSBundle mainBundle] loadNibNamed:@"ChatDetailCustomcell" owner:self options:nil];
    ChatDetailcell = chatCustomcell;
    CGSize dataSize1 = [COMMON getControlHeight:text withFontName:@"HelveticaNeue" ofSize:15.0 withSize:CGSizeMake(chatTableView.frame.size.width,chatTableView.frame.size.height)];
    return dataSize1.height + CELL_HEIGHT+50;

    
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
    [ChatDetailcell setBackgroundColor:[UIColor purpleColor]];
    //[chatTableView setSeparatorColor:[UIColor blackColor]];
   // [chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
    [COMMON DSLoadIcon:self.view];
    [self loadCancelRequestWebService];
   // [self performSelector:@selector(loadDeleteAPI) withObject:nil afterDelay:0.2];
    
    
}
-(void)loadDeleteAPI{
    [COMMON DSRemoveLoading];
    [self loadDeleteUserChatHistory];
}

- (IBAction)pressBlock:(id)sender {
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
    _menuImageview.hidden = NO;
    //[self loadblockUser];
    [self loadCancelRequestWebService];
    
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
    
    if ([COMMON isInternetReachable]) {
        
        NSString *conversationID;
        
        if(_conversionID==nil)
            conversationID = [chatuserDetailsDict valueForKey:@"id"];
        
        else
            conversationID=_conversionID;
        
        
        [webService getConversation:GetConversation sessionID:[COMMON getSessionID] conversationId:conversationID dateTime:[COMMON getCurrentDateTime]
                            success:^(AFHTTPRequestOperation *operation, id responseObject){
                                
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
                                    
                                    if (chatTableView.contentSize.height < chatTableView.frame.size.height)
                                    {
                                        if(iskeyboardapear==NO)
                                        {
                                            [chatTableView scrollRectToVisible:CGRectMake(0, chatTableView.contentSize.height - chatTableView.bounds.size.height, chatTableView.bounds.size.width,chatTableView.bounds.size.height) animated:YES];
                                        }
                                        else
                                        {
                                            [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:conversationArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                        }
                                    }
                                    
                                    else{
                                        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:conversationArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                    }
                                    
                                    
                                }
                                else{
                                    [messageTimer invalidate];
                                }
                                
                            }
         
                            failure:^(AFHTTPRequestOperation *operation, id error) {
                                [COMMON DSRemoveLoading];
                                
                            }];

    }
}

-(void)loadSendMessageAPI:(NSString *)_receiverId conversationId:(NSString *)_conversationId{
    
    if ([COMMON isInternetReachable]) {
        
        [webService sendMessage:SendMessage_API sessionid:[COMMON getSessionID] message_send_user_id:_receiverId message:chatView.textView.text conversation_id:_conversationId success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            msgResponseDict = [[NSMutableDictionary alloc]init];
            
            msgResponseDict = [responseObject valueForKey:@"sendmessage"];
            
            if([[msgResponseDict valueForKey:@"status"]isEqualToString:@"success"]){
                
                [self loadConverstionAPI];
                //[[IQKeyboardManager sharedManager] becomeFirstResponder];
                
            }
            [COMMON DSRemoveLoading];
            
        }
         
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            [COMMON DSRemoveLoading];
                            
                        }];
    }
}

#pragma deleteuserchatdetails, Blockuser
-(void)loadDeleteUserChatHistory
{
    if ([COMMON isInternetReachable]) {
        NSString *conversationID = [chatuserDetailsDict valueForKey:@"id"];
        
        [webService deleteUserChatHist:DeleteConversation sessionid:[COMMON getSessionID] chat_user_id:conversationID success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             //[self.navigationController popViewControllerAnimated:YES];
             
         } failure:^(AFHTTPRequestOperation *operation, id error) {
             
         }];
    }
}

-(void)loadblockUser
{
    if ([COMMON isInternetReachable]) {

        NSString *conversationID = [chatuserDetailsDict valueForKey:@"id"];
        
        [webService blockUser:BlockUser_API sessionid:[COMMON getSessionID] block_user_id:conversationID success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"backAction"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            
        }];
    }
}

#pragma mark - loadCancelRequestWebService
-(void)loadCancelRequestWebService
{
     NSString *selectedUserId = [chatuserDetailsDict valueForKey:@"UserId"];
    if([COMMON isInternetReachable]){
        [webService cancelRequest:CancelRequest_API
                        sessionid:[COMMON getSessionID]
             request_send_user_id:selectedUserId
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             // NSLog(@"SEND REQ%@",responseObject);
                              [COMMON DSRemoveLoading];
                              [self gotolocationview];
                              
                          } failure:^(AFHTTPRequestOperation *operation, id error) {
                              [COMMON DSRemoveLoading];
                              //NSLog(@"SEND REQ ERR%@",error);
                          }];
    }
    else{
        [COMMON DSRemoveLoading];
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }
}

-(void)gotolocationview
{
    [appDelegate.locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_active.png"] forState:UIControlStateNormal];
    DSLocationViewController * locationview =[[DSLocationViewController alloc]initWithNibName:@"DSLocationViewController" bundle:nil];
    [self.navigationController pushViewController:locationview animated:NO];
    
}



-(IBAction)DidClickGeneralAlterviewBtn:(id)sender
{
    self.WalkAlterview.hidden=YES;
    self.window.hidden =YES;
     [self flashOff:blueCirecleBtn];
}
-(void)GerenalWalkAlterview
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    UIView * altermsgView;
    
    if(IS_IPHONE6_Plus || IS_IPHONE6)
    {
         CommWalkView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.topview.frame.origin.y+self.topview.frame.size.height+50,self.window.frame.size.width,120)];
        
         blueCirecleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+80,self.window.frame.size.height-100,40,40)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+60,self.view.center.y+20,240,60)];
    }
    else{
        
        blueCirecleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+80,self.view.frame.size.height-80,40,40)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+40,self.view.center.y,240,60)];
    }

    [blueCirecleBtn setImage:[UIImage imageNamed:@"BlueCirecleimg"] forState: UIControlStateNormal];
  
    [self flashOn:blueCirecleBtn];
    
    [self.window addSubview:blueCirecleBtn];
    
    UIImageView * blueTxtImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,240,60)];
    blueTxtImg.userInteractionEnabled=YES;
    blueTxtImg.image=[UIImage imageNamed:@"BlueBgText"];
    [altermsgView addSubview:blueTxtImg];
    UILabel * AlterMsg=[[UILabel alloc]initWithFrame:CGRectMake(0,0,240,60)];
    AlterMsg.text =@"Do send them a message and \n Let’s Do Something";
    AlterMsg.textColor=[UIColor whiteColor];
    AlterMsg.textAlignment= NSTextAlignmentCenter;
    AlterMsg.numberOfLines=2;
    [AlterMsg setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [altermsgView addSubview:AlterMsg];
    
    [self.window addSubview:altermsgView];
    
    //UIButton * ClosewindowBtn =[[UIButton alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [blueCirecleBtn addTarget:self action:@selector(DidClickGeneralAlterviewBtn:) forControlEvents:UIControlEventTouchUpInside];
   
   // [self.window addSubview:ClosewindowBtn];
    self.window.hidden=NO;
    [self.window makeKeyAndVisible];
   
    self.window.backgroundColor =[UIColor colorWithRed:(53.0/255.0f) green:(53.0/255.0f) blue:(53.0/255.0f) alpha:0.5];
}

- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .05;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}



@end
