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
#import "CustomAlterview.h"
#import "DSTermsOfUseView.h"
#import "DSTermsViewController.h"


@interface SettingView ()
{
   
    DSWebservice    *objWebService;
    NSString        *optionLogoutDelete;
    NSString        * notificationMsg;
    NSString        * notificationSound;
    NSString        * notificationvibration;
    AppDelegate     *appDelegate;
    UISwitch        * messSwith;
    UISwitch        * soundSwitch;
    UISwitch        *vibrationSwitch;
    CustomAlterview * objCustomAlterview;
    UIWindow        *windowInfo;
    NSString        * currentLatitude, * currentLongitude;
    

}

@property (nonatomic,strong) IBOutlet NSLayoutConstraint    * deletebuttonBottomoposition;
@property(nonatomic,retain) DSTermsOfUseView                *termsOfUseView;

@end
@implementation SettingView
@synthesize settingScroll,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
   // settingScroll.userInteractionEnabled = NO;
    objWebService =[[DSWebservice alloc]init];
    settingScroll.scrollEnabled =NO;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
   
    notificationMsg=[dic valueForKey:@"notification_message"];
    notificationSound=[dic valueForKey:@"notification_sound"];
    notificationvibration=[dic valueForKey:@"notification_vibration"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getUserCurrenLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInvalidSessionAlert:)
                                                 name:@"InvalidSession"
                                               object:nil];
    
    [self loadNavigationview];
    
    [self CustomAlterviewload];
    
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
   
    
     messSwith =[[UISwitch alloc]initWithFrame:CGRectMake(messLbl.frame.origin.x+messLbl.frame.size.width+24,messLbl.frame.origin.y-3,20,0)];
    [messSwith addTarget: self action: @selector(messSwithAction:) forControlEvents:UIControlEventValueChanged];
    messSwith.transform = CGAffineTransformMakeScale(0.50, 0.50);
    messSwith.layer.cornerRadius = 16.0;
    
    soundSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(soundLbl.frame.origin.x+soundLbl.frame.size.width+24,soundLbl.frame.origin.y-3,20,0)];
    soundSwitch.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [soundSwitch addTarget: self action: @selector(soundSwithAction:) forControlEvents:UIControlEventValueChanged];
    soundSwitch.layer.cornerRadius = 16.0;
    
    vibrationSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(vibrationLbl.frame.origin.x+vibrationLbl.frame.size.width+24,vibrationLbl.frame.origin.y-5,20,0)];
     vibrationSwitch.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [vibrationSwitch addTarget: self action: @selector(vibrationSwithAction:) forControlEvents:UIControlEventValueChanged];
     vibrationSwitch.layer.cornerRadius = 16.0;
    [self.notificationview addSubview:messSwith];
    [self.notificationview addSubview:soundSwitch];
    [self.notificationview addSubview:vibrationSwitch];
  
}

-(void)CustomAlterviewload
{
    
    objCustomAlterview = [[CustomAlterview alloc] initWithNibName:@"CustomAlterview" bundle:nil];
    objCustomAlterview.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, CGRectGetWidth(self.view.frame), self.view.frame.size.height);
    [objCustomAlterview.alertBgView setHidden:YES];
    [objCustomAlterview.alertMainBgView setHidden:YES];

    [objCustomAlterview.btnNo addTarget:self action:@selector(alertPressNo:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.btnYes addTarget:self action:@selector(alertPressYes:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:objCustomAlterview.view];
   
}

-(void)notificationMethod
{
    
    
    NSString * objMsg =[notificationMsg isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[notificationSound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[notificationvibration isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [messSwith setThumbTintColor:[UIColor greenColor]];
        
        [messSwith setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [messSwith setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        }
    if([objSound isEqualToString:@"switch_on"])
    {
        [soundSwitch setThumbTintColor:[UIColor greenColor]];
        
        [soundSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [soundSwitch setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        [vibrationSwitch setThumbTintColor:[UIColor greenColor]];
        
        [vibrationSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [vibrationSwitch setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    }

    if([objMsg isEqualToString:@"switch_off"])
    {
        [messSwith setTintColor:[UIColor whiteColor]];
        [messSwith setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [messSwith setThumbTintColor:[UIColor redColor]];
    }
    if([objSound isEqualToString:@"switch_off"])
    {
        [soundSwitch setTintColor:[UIColor whiteColor]];
        [soundSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [soundSwitch setThumbTintColor:[UIColor redColor]];
    }
    
    if([objVibration isEqualToString:@"switch_off"])
    {
        [vibrationSwitch setTintColor:[UIColor whiteColor]];
        [vibrationSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [vibrationSwitch setThumbTintColor:[UIColor redColor]];
    }
  
}
- (IBAction)messSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        NSLog(@"If body ");
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        
        
    }else{
        NSLog(@"Else body ");
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        
    }
}

- (IBAction)soundSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        NSLog(@"If body ");
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        
        
    }else{
        NSLog(@"Else body ");
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        

    }
}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
        locationManager.distanceFilter  = kCLLocationAccuracyKilometer;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType    = CLActivityTypeAutomotiveNavigation;
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    CLLocation *newLocation = [locations lastObject];
    
    currentLatitude         = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.latitude]];
    
    currentLongitude        = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.longitude]];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:@"currentLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:@"currentLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
          [self loadLocationUpdateAPI];
          dispatch_async(dispatch_get_main_queue(), ^(){
            
         });
           
    });
    
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}

-(void)loadLocationUpdateAPI{
    
    [objWebService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              NSLog(@"responseObject = %@",responseObject);
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              
                          }];
    
    
}


- (IBAction)vibrationSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        NSLog(@"If body ");
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        
        
    }else{
        NSLog(@"Else body ");
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
    
    }
}


#pragma mark - Logout_Delete_Action_API
-(void)logoutDeleteAction{
   
    [objWebService logoutDeleteUser:User_Logout_Delete_API
     
                          sessionId:[COMMON getSessionID]
     
                                 op:optionLogoutDelete
     
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                NSLog(@"logoutDeleteUser %@ =" , responseObject);
                                
                                if([[[responseObject valueForKey:@"useraction"]valueForKey:@"status"] isEqualToString:@"success"])
                                    
                                {
                                    
                                    [COMMON removeUserDetails];
                                    
                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:HobbiesArray];
                                    
                                    DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
                                    
                                    [self.navigationController pushViewController:objSplashView animated:NO];
                                    
                                    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                    
                                    appDelegate.buttonsView.hidden=YES;
                                    
                                    appDelegate.SepratorLbl.hidden=YES;
                                    
                                    [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
                                    
                                }
                                                                
                            }
     
                            failure:^(AFHTTPRequestOperation *operation, id error) {
                                
                                
                            }];
}
-(IBAction)didClickLogoutButtonAction:(id)sender
{
    
    optionLogoutDelete = @"logout";
    [objCustomAlterview.view setHidden:NO];
    objCustomAlterview.alertBgView.hidden = NO;
    objCustomAlterview.alertMainBgView.hidden = NO;
    objCustomAlterview.alertCancelButton.hidden = NO;
    objCustomAlterview.btnYes.hidden = NO;
    objCustomAlterview.btnNo.hidden = NO;
    
    objCustomAlterview.alertMsgLabel.text = @"ARE YOU SURE YOU WANT \nTO LOG OUT?";
    objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    objCustomAlterview.alertMsgLabel.numberOfLines = 2;
    objCustomAlterview.alertMsgLabel.textColor = [UIColor whiteColor];

    //[self logoutDeleteAction];
}
-(IBAction)didClickdeleteAccountButtonAction:(id)sender
{
    
    optionLogoutDelete = @"delete";
    [objCustomAlterview.view setHidden:NO];
    objCustomAlterview.alertBgView.hidden = NO;
    objCustomAlterview.alertMainBgView.hidden = NO;
    objCustomAlterview.alertCancelButton.hidden = NO;
    objCustomAlterview.btnYes.hidden = NO;
    objCustomAlterview.btnNo.hidden = NO;
    
    objCustomAlterview.alertMsgLabel.text = @"ARE YOU SURE YOU WANT \nTO DELETE ACCOUNT?";
    objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    objCustomAlterview.alertMsgLabel.numberOfLines = 2;
    [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];
   
     
   
}
-(IBAction)didClickTearmofuseAction:(id)sender
{
   // [self loadTermsOfUseView];
    
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
    
    [self.navigationController pushViewController:termViewController animated:YES];
}
-(IBAction)didClickprivacypolicyAction:(id)sender
{
    // [self loadTermsOfUseView];
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
    
    [self.navigationController pushViewController:termViewController animated:YES];

}


- (IBAction)alertPressYes:(id)sender {
    
    [self logoutDeleteAction];
    objCustomAlterview.view.hidden =YES;
    objCustomAlterview. alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;

}

- (IBAction)alertPressNo:(id)sender {
    
    objCustomAlterview.alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    objCustomAlterview.view.hidden =YES;
      

}

#pragma mark TermsOfUse

-(void)loadTermsOfUseView
{
    windowInfo = [[[UIApplication sharedApplication] delegate] window];
    
    DSTermsOfUseView *termsOfUseView = [[DSTermsOfUseView alloc] init];
    
    [windowInfo addSubview:termsOfUseView];
    
    [termsOfUseView.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   
    [self setTermsOfUseView:termsOfUseView];
    
    NSDictionary *dictView = @{@"_terms":termsOfUseView};
    
    [windowInfo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_terms]|"
                                
                                                                       options:0
                                
                                                                       metrics:nil views:dictView]];
    
    [windowInfo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_terms]|"
                                
                                                                       options:0
                                
                                                                       metrics:nil views:dictView]];

    
    
}

-(IBAction)closeButtonAction:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.termsOfUseView removeFromSuperview];
        
    });
}



-(void)loadInvalidSessionAlert:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [COMMON removeUserDetails];
    DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
    [self.navigationController pushViewController:objSplashView animated:NO];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=YES;
    appDelegate.SepratorLbl.hidden=YES;
    [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
}


@end
