//
//  SettingView.m
//  DoSomething
//
//  Created by Sha on 11/25/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "SettingView.h"
#import "CustomNavigationView.h"
#import "DSAppCommon.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "DSLoginViewController.h"

@interface SettingView ()
{
    CustomNavigationView *customNavigation;
    DSWebservice *objWebService;
    NSString *loginUserSessionID;
    NSString *optionLogoutDelete;
    NSString * notificationMsg;
    NSString * notificationSound;
    NSString * notificationvibration;
}

@end
@implementation SettingView
@synthesize settingScroll;

- (void)viewDidLoad {
    [super viewDidLoad];
   // settingScroll.userInteractionEnabled = NO;
    objWebService =[[DSWebservice alloc]init];
    settingScroll.scrollEnabled =NO;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString * strsessionID =[dic valueForKey:@"SessionId"];
    notificationMsg=[dic valueForKey:@"notification_message"];
    notificationSound=[dic valueForKey:@"notification_sound"];
    notificationvibration=[dic valueForKey:@"notification_vibration"];
    
    loginUserSessionID=strsessionID;
}
-(void)viewWillAppear:(BOOL)animated{
    
    //[self NotificationMethod];
    [self loadNavigationview];
    
    [self notificationMethod];
    
}


-(void)loadNavigationview
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
   
    //CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
        //self.layoutConstraintTableViewYPos.constant= 20;
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        //self.layoutConstraintTableViewYPos.constant= 20;
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    alertMainBgView.hidden = YES;
    alertBgView .hidden =YES;
  
}
-(void)notificationMethod
{
    self.messSwitchBtn.userInteractionEnabled = YES;
    self.vibrationSwitchBtn.userInteractionEnabled = YES;
    self.SoundSwitchBtn.userInteractionEnabled = YES;
    
    [self.messSwitchBtn setTag:200];
    [self.SoundSwitchBtn setTag:201];
    [self.vibrationSwitchBtn setTag:202];
    
    
    NSString * objMsg =[notificationMsg isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[notificationSound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[notificationvibration isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
         self.imageViewNewMsg.image =[UIImage imageNamed:@"switch_on"];
    }
    if([objSound isEqualToString:@"switch_on"])
    {
        self.imageViewSound.image =[UIImage imageNamed:@"switch_on"];
    }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        self.imageViewVibration.image =[UIImage imageNamed:@"switch_on"];
    }

    if([objMsg isEqualToString:@"switch_off"])
    {
        self.imageViewNewMsg.image =[UIImage imageNamed:@"switch_off"];
    }
    if([objSound isEqualToString:@"switch_off"])
    {
        self.imageViewSound.image =[UIImage imageNamed:@"switch_off"];
    }
    
    if([objVibration isEqualToString:@"switch_off"])
    {
        self.imageViewVibration.image =[UIImage imageNamed:@"switch_off"];
    }
  
    
    
    [self.vibrationSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.SoundSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.messSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    

}
-(void)newMessSwitchBtnAction:(UIButton *)sender
{
    UIButton * button = sender;
    if(button.tag == 200)
    {
        
    }
    else if (button.tag==201)
    {
        
    }
    else if (button.tag == 202)
    {
        
    }
}

#pragma mark - Logout_Delete_Action_API
-(void)logoutDeleteAction{
    
   
    [objWebService logoutDeleteUser:User_Logout_Delete_API
                          sessionId:loginUserSessionID
                                 op:optionLogoutDelete
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"logout");
                               
                                DSLoginViewController*objLogin =[[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
                                if([optionLogoutDelete isEqualToString:@"logout"])
                                {
                                     objLogin.temp = @"Signin";
                                     [COMMON removeUserDetails];
                                }
                                else
                                {
                                     objLogin.temp = @"createAnAccount";
                                }
                                [self.navigationController pushViewController:objLogin animated:NO];
                                
                                
                            }
                            failure:^(AFHTTPRequestOperation *operation, id error) {
                                NSLog(@"logout failure");

                            }];
    
    
}


-(IBAction)didClickLogoutButtonAction:(id)sender
{
    
    optionLogoutDelete = @"logout";
    alertBgView.hidden = NO;
    alertMainBgView.hidden = NO;
    alertCancelButton.hidden = NO;
    btnYes.hidden = NO;
    btnNo.hidden = NO;
    
    alertMsgLabel.text = @"ARE YOU SURE YOU WANT \nTO LOG OUT?";
    alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    alertMsgLabel.numberOfLines = 2;
    alertMsgLabel.textColor = [UIColor whiteColor];

    
    //[self logoutDeleteAction];
}
-(IBAction)didClickdeleteAccountButtonAction:(id)sender
{
    
    optionLogoutDelete = @"delete";
    alertBgView.hidden = NO;
    alertMainBgView.hidden = NO;
    alertCancelButton.hidden = NO;
    btnYes.hidden = NO;
    btnNo.hidden = NO;
    
    alertMsgLabel.text = @"ARE YOU SURE YOU WANT \nTO DELETE ACCOUNT?";
    alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    alertMsgLabel.numberOfLines = 2;
    alertMsgLabel.textColor = [UIColor whiteColor];

     
   
}
-(IBAction)didClickTearmofuseAction:(id)sender
{
    
}
-(IBAction)didClickprivacypolicyAction:(id)sender
{
    
}

- (IBAction)alertPressYes:(id)sender {
    
   alertBgView.hidden = YES;
   alertMainBgView.hidden = YES;
     [self logoutDeleteAction];
    
   }

- (IBAction)alertPressNo:(id)sender {
    
    alertBgView.hidden = YES;
    alertMainBgView.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
