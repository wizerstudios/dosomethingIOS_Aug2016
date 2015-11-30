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
#import "DSHomeViewController.h"
#import "AppDelegate.h"

@interface SettingView ()
{
   
    DSWebservice *objWebService;
    NSString *loginUserSessionID;
    NSString *optionLogoutDelete;
    NSString * notificationMsg;
    NSString * notificationSound;
    NSString * notificationvibration;
    AppDelegate *appDelegate;
    UISwitch * messSwith;
    UISwitch * soundSwitch;
    UISwitch *vibrationSwitch;
}

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * deletebuttonBottomoposition;

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
    NSLog(@"usersessionID:%@",strsessionID);
    notificationMsg=[dic valueForKey:@"notification_message"];
    notificationSound=[dic valueForKey:@"notification_sound"];
    notificationvibration=[dic valueForKey:@"notification_vibration"];
    
    loginUserSessionID=strsessionID;
}
-(void)viewWillAppear:(BOOL)animated{
    
   
    [self loadNavigationview];
    
    [self notificationMethod];
    
   
    self.deletebuttonBottomoposition.constant =45;
    
    if(IS_IPHONE6)
    {
        self.deletebuttonBottomoposition.constant =-55;
    }
    if(IS_IPHONE6_Plus)
    {
        self.deletebuttonBottomoposition.constant =-130;
    }
    
}


-(void)loadNavigationview
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
   
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE4 ||IS_IPHONE5)
    {
        customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    }
    else    {
        customNavigation.view.frame = CGRectMake(0,-20,420, 75);
    }

    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:NO];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    alertMainBgView.hidden = YES;
    alertBgView .hidden =YES;
    
     messSwith =[[UISwitch alloc]initWithFrame:CGRectMake(messLbl.frame.origin.x+messLbl.frame.size.width+24,messLbl.frame.origin.y-3,20,0)];
    [messSwith addTarget: self action: @selector(messSwithAction:) forControlEvents:UIControlEventValueChanged];
   messSwith.transform = CGAffineTransformMakeScale(0.50, 0.50);
     messSwith.layer.cornerRadius = 16.0;
    [messSwith setOnTintColor:[UIColor greenColor]];
    
    soundSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(soundLbl.frame.origin.x+soundLbl.frame.size.width+24,soundLbl.frame.origin.y-3,20,0)];
    soundSwitch.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [soundSwitch addTarget: self action: @selector(soundSwithAction:) forControlEvents:UIControlEventValueChanged];
    
   vibrationSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(vibrationLbl.frame.origin.x+vibrationLbl.frame.size.width+24,vibrationLbl.frame.origin.y-5,20,0)];
     vibrationSwitch.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [vibrationSwitch addTarget: self action: @selector(vibrationSwithAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.notificationview addSubview:messSwith];
    [self.notificationview addSubview:soundSwitch];
    [self.notificationview addSubview:vibrationSwitch];
  
}
-(void)notificationMethod
{
//    self.messSwitchBtn.userInteractionEnabled = YES;
//    self.vibrationSwitchBtn.userInteractionEnabled = YES;
//    self.SoundSwitchBtn.userInteractionEnabled = YES;
//    
//    [self.messSwitchBtn setTag:200];
//    [self.SoundSwitchBtn setTag:201];
//    [self.vibrationSwitchBtn setTag:202];
    
    
    NSString * objMsg =[notificationMsg isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[notificationSound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[notificationvibration isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [messSwith setThumbTintColor:[UIColor greenColor]];
        
        [messSwith setBackgroundColor:[UIColor whiteColor]];
        [messSwith setOnTintColor:[UIColor lightGrayColor]];
        }
    if([objSound isEqualToString:@"switch_on"])
    {
        [soundSwitch setThumbTintColor:[UIColor greenColor]];
        
        [soundSwitch setBackgroundColor:[UIColor whiteColor]];
        [soundSwitch setOnTintColor:[UIColor lightGrayColor]];
    }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        [vibrationSwitch setThumbTintColor:[UIColor greenColor]];
        
        [vibrationSwitch setBackgroundColor:[UIColor whiteColor]];
        [vibrationSwitch setOnTintColor:[UIColor lightGrayColor]];
    }

    if([objMsg isEqualToString:@"switch_off"])
    {
        [messSwith setTintColor:[UIColor grayColor]];
        [messSwith setBackgroundColor:[UIColor lightGrayColor]];
        [messSwith setThumbTintColor:[UIColor redColor]];
    }
    if([objSound isEqualToString:@"switch_off"])
    {
        [soundSwitch setTintColor:[UIColor grayColor]];
        [soundSwitch setBackgroundColor:[UIColor lightGrayColor]];
        [soundSwitch setThumbTintColor:[UIColor redColor]];
    }
    
    if([objVibration isEqualToString:@"switch_off"])
    {
        [vibrationSwitch setTintColor:[UIColor grayColor]];
        [vibrationSwitch setBackgroundColor:[UIColor lightGrayColor]];
        [vibrationSwitch setThumbTintColor:[UIColor redColor]];
    }
  
    
    
    //[self.vibrationSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.SoundSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   // [self.messSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    

}
- (IBAction)messSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        NSLog(@"If body ");
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor lightGrayColor]];
        
        
    }else{
        NSLog(@"Else body ");
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setThumbTintColor:[UIColor redColor]];
        
       // [sender setBackgroundColor:[UIColor colorWithRed:138/256.0 green:9/256.0 blue:18/256.0 alpha:1]];
    }
}

- (IBAction)soundSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        NSLog(@"If body ");
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor lightGrayColor]];
        
        
    }else{
        NSLog(@"Else body ");
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setThumbTintColor:[UIColor redColor]];
        
        // [sender setBackgroundColor:[UIColor colorWithRed:138/256.0 green:9/256.0 blue:18/256.0 alpha:1]];
    }
}

- (IBAction)vibrationSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        NSLog(@"If body ");
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor lightGrayColor]];
        
        
    }else{
        NSLog(@"Else body ");
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setThumbTintColor:[UIColor redColor]];
        
        // [sender setBackgroundColor:[UIColor colorWithRed:138/256.0 green:9/256.0 blue:18/256.0 alpha:1]];
    }
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
                                if([[[responseObject valueForKey:@"useraction"]valueForKey:@"status"] isEqualToString:@"success"])
                                {
                                DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
                                [self.navigationController pushViewController:objSplashView animated:NO];
                                
                                    [COMMON removeUserDetails];
                                    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                    appDelegate.buttonsView.hidden=YES;
                                    [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                    
                                });
                                }
                                
                                else
                                {
                                      NSLog(@"delete failure");
                                }
                               
                                
                                
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
    [alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];

     
   
}
-(IBAction)didClickTearmofuseAction:(id)sender
{
    
}
-(IBAction)didClickprivacypolicyAction:(id)sender
{
    
}

- (IBAction)alertPressYes:(id)sender {
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        alertBgView.alpha = 0;
//        
//        alertMainBgView.alpha = 0;
//        
//    } completion:^(BOOL b){
    
        alertBgView.hidden = YES;
        alertMainBgView.hidden = YES;
         [self logoutDeleteAction];
        
   // }];
    
   }

- (IBAction)alertPressNo:(id)sender {
    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        alertBgView.alpha = 0;
//        
//        alertMainBgView.alpha = 0;
//      
//    } completion:^(BOOL b){
    
        alertBgView.hidden = YES;
        
        alertMainBgView.hidden = YES;
      
   // }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
