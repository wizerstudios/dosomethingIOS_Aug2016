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
#import "DSWebservice.h"

#define CONTENT_WIDTH           200.f
#define CONTENT_START           0.f
#define BUBBLE_IMAGE_HEIGHT     10.f
#define BUBBLE_WIDTH            250.f
#define BUBBLE_WIDTH_SPACE      70.f
#define CELL_HEIGHT             CONTENT_START+25.f
#define ME_RIGHT_WIDTH_SPACE    25.0f

@interface DSChatDetailViewController (){
    
    NSUInteger supportUser;
    
    NSMutableArray *conversationArray;
    
    DSWebservice *webService;
}

@end

@implementation DSChatDetailViewController
@synthesize ProfileName,ProfileImage;
@synthesize chatView,chatuserDetailsDict,chatButton;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    webService = [[DSWebservice alloc]init];
    
    conversationArray = [[NSMutableArray alloc]init];
    
    [self loadNavigation];
    
    [self displayUserDetailsView];
    
    [self loadConverstionAPI];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
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
    
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);//65
    
    if (IS_IPHONE6 )
        
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
    
    if(IS_IPHONE6_Plus)
        
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
    
    [customNavigation.menuBtn setHidden:YES];
    
    [customNavigation.buttonBack setHidden:NO];
    
    [customNavigation.saveBtn setHidden:YES];
    
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backAction
{
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
        
        ProfileImage.image = [UIImage imageNamed:@"profile_noimg.png"];
        
    }
    
    [ProfileImage.layer setCornerRadius:28];
    
    [ProfileImage.layer setMasksToBounds:YES];
    
    if(supportUser == 1){
        
        [ProfileImage.layer setBorderWidth:2.0f];
        
        [ProfileImage.layer setBorderColor:[[UIColor colorWithRed:229.0f/255.0f green:63.0f/255.0f blue:81.0f/255.0f alpha:1.0f] CGColor]];
        
        [chatButton setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
        
        [chatButton setContentMode:UIViewContentModeScaleAspectFit];
        
        [chatButton setUserInteractionEnabled:NO];
        
    }
    else{
        
        [chatButton setBackgroundImage:[UIImage imageNamed:@"menu_active.png"] forState:UIControlStateNormal];
        
        [chatButton setUserInteractionEnabled:NO];
    }
    
      [chatButton setContentMode:UIViewContentModeScaleToFill];
    OnlineLabel.text =@"Online";
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
    [chatView.postButton setHidden:YES];
    

}

#pragma mark - Textview


-(void)textViewDidBeginEditing:(UITextView *)textView{
 
    
    [chatView.placeHolderLabel setHidden:YES];
    
    [UIView animateWithDuration:.25f animations:^{
        
        if(IS_IPHONE4)
            
            chatView.frame=CGRectMake(0,160,320,50);
        
        else
            
            chatView.frame=CGRectMake(0,90,self.view.frame.size.width,40);
        
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@""]){
         [chatView.placeHolderLabel setHidden:NO];
         [chatView.postButton setHidden:YES];
    }
    else{
        [chatView.postButton setHidden:NO];
    }
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:.25f animations:^{
        
        if(IS_IPHONE4)
            
            chatView.frame=CGRectMake(0,412,320,65);
        
        else
            
            chatView.frame=CGRectMake(0,335,320,40);
    }];
    
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
    return dataSize.height + CELL_HEIGHT +20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ChatTableViewCell *cell = (ChatTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"chatTableViewCell" owner:self options:nil];
        cell = chatCustomcell;
    }
    [cell getMessageArray:[conversationArray objectAtIndex:indexPath.row]];
    return cell;
    
}


#pragma mark - All the other junk for the sample project

- (void)setUpForPortrait {
    
    float halfOfWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0;
    float height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    self.semiTransparentView.frame = CGRectMake(0, 0, halfOfWidth * 2.0, height+40);
    self.semiTransparentView.center = CGPointMake(halfOfWidth, height /0);
    
    self.funkyIBASButton.center = CGPointMake(halfOfWidth, (height / 2.0) +120);
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        height -= 0;
    }
}
- (void)setUpForLandscape
{
    float halfOfWidth = CGRectGetHeight([UIScreen mainScreen].bounds) / 2.0;
    float height = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.funkyIBASButton.center = CGPointMake(halfOfWidth, (height / 2.0) + 120);
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        height -= 0;
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
}

- (IBAction)pressBlock:(id)sender {
    
    _transparentView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
    _menuImageview.hidden = NO;
    
}
- (IBAction)showReallyFunkyIBActionSheet:(id)sender
{
    _menuImageview.hidden = YES;
    
    _transparentView.hidden = NO;
    
    _backgroundView.hidden = NO;
}


#pragma mark - Webservice Method

-(void)loadConverstionAPI{
    
    NSString *conversationID = [chatuserDetailsDict valueForKey:@"id"];
    
    [webService getConversation:GetConversation sessionID:[COMMON getSessionID] conversationId:conversationID
                        success:^(AFHTTPRequestOperation *operation, id responseObject){
                            
                            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc]init];
                            
                            responseDict = [[responseObject valueForKey:@"getconversation"]mutableCopy];
                            
                            if([[responseDict valueForKey:@"status"]isEqualToString:@"success"]){
                                
                                conversationArray = [[responseDict valueForKey:@"converation"]mutableCopy];
                                
                                [chatTableView reloadData];
                            }
                            
                        }
     
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            [COMMON removeLoading];
                            
                        }];
    
}

@end
