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
#import "DSTermsViewController.h"

@interface SettingView ()
{
   
    DSWebservice    *objWebService;
    NSString        *optionLogoutDelete;
    NSString        * notificationMsg;
    NSString        * notificationSound;
    NSString        * notificationvibration;
    AppDelegate     *appDelegate;
    UISwitch        * messSwitch;
    UISwitch        * soundSwitch;
    UISwitch        *vibrationSwitch;
    CustomAlterview * objCustomAlterview;
    UIWindow        *windowInfo;
    NSString        * currentLatitude, * currentLongitude;
    

}
@property (nonatomic,strong) IBOutlet NSLayoutConstraint    * deletebuttonBottomoposition;


@end
@implementation SettingView
@synthesize settingScroll,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    objWebService =[[DSWebservice alloc]init];
    settingScroll.scrollEnabled =NO;
    NSMutableDictionary *profileDict=[[NSMutableDictionary alloc]init];
    profileDict = [COMMON getUserDetails];
   
    notificationMsg=[profileDict valueForKey:@"notification_message"];
    notificationSound=[profileDict valueForKey:@"notification_sound"];
    notificationvibration=[profileDict valueForKey:@"notification_vibration"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getUserCurrenLocation];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInvalidSessionAlert:)
                                                 name:@"InvalidSession"
                                               object:nil];
    
    [self loadNavigationview];
    
    [self CustomAlterviewload];
   
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
    else{
        customNavigation.view.frame = CGRectMake(0,-20,420, 75);
    }

    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:NO];
    [customNavigation.saveBtn addTarget:self action:@selector(didClickSaveBntAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
   
    
     messSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(messLbl.frame.origin.x+messLbl.frame.size.width+24,messLbl.frame.origin.y-3,60,20)];
    [messSwitch addTarget: self action: @selector(messSwithAction:) forControlEvents:UIControlEventValueChanged];
    messSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    messSwitch.layer.cornerRadius = 16.0;
    
    soundSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(soundLbl.frame.origin.x+soundLbl.frame.size.width+24,soundLbl.frame.origin.y-3,60,20)];
    soundSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [soundSwitch addTarget: self action: @selector(soundSwithAction:) forControlEvents:UIControlEventValueChanged];
    soundSwitch.layer.cornerRadius = 16.0;
    
    vibrationSwitch =[[UISwitch alloc]initWithFrame:CGRectMake(vibrationLbl.frame.origin.x+vibrationLbl.frame.size.width+24,vibrationLbl.frame.origin.y-5,60,20)];
    vibrationSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [vibrationSwitch addTarget: self action: @selector(vibrationSwithAction:) forControlEvents:UIControlEventValueChanged];
    vibrationSwitch.layer.cornerRadius = 16.0;
    [self notificationMethod];
    [self.notificationview addSubview:messSwitch];
    [self.notificationview addSubview:soundSwitch];
    [self.notificationview addSubview:vibrationSwitch];
  
}


-(void)notificationMethod
{
    
    NSString * objMsg =[notificationMsg isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[notificationSound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[notificationvibration isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [messSwitch setOn:YES];
        [messSwitch setThumbTintColor:[UIColor greenColor]];
        [messSwitch setBackgroundColor:[UIColor clearColor]];
        [messSwitch setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
         notificationMsg = @"Yes";
        
    }
    else{
        [messSwitch setOn:NO];
        [messSwitch setTintColor:[UIColor clearColor]];
        [messSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [messSwitch setThumbTintColor:[UIColor redColor]];
        notificationMsg = @"No";

    }
    if([objSound isEqualToString:@"switch_on"])
    {
        [soundSwitch setOn:YES];
        [soundSwitch setThumbTintColor:[UIColor greenColor]];
        [soundSwitch setBackgroundColor:[UIColor clearColor]];
        [soundSwitch setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        notificationSound = @"Yes";
    }
     else{
         [soundSwitch setOn:NO];
         [soundSwitch setTintColor:[UIColor clearColor]];
         [soundSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
         [soundSwitch setThumbTintColor:[UIColor redColor]];
         notificationMsg = @"No";

     }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        [vibrationSwitch setOn:YES];
        [vibrationSwitch setThumbTintColor:[UIColor greenColor]];
        [vibrationSwitch setBackgroundColor:[UIColor clearColor]];
        [vibrationSwitch setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        notificationvibration = @"Yes";
    }

    else
    {
        [vibrationSwitch setOn:NO];
        [vibrationSwitch setTintColor:[UIColor clearColor]];
        [vibrationSwitch setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [vibrationSwitch setThumbTintColor:[UIColor redColor]];
        notificationvibration = @"No";
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

#pragma mark - UISwitch Action
- (IBAction)messSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        [sender setThumbTintColor:[UIColor greenColor]];
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        notificationMsg = @"Yes";
        
        
    }else{
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        notificationMsg = @"No";
        
    }

}
- (IBAction)soundSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        [sender setThumbTintColor:[UIColor greenColor]];
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        notificationSound = @"Yes";
        
        
    }else{
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        notificationSound = @"No";
        
    }

}

- (IBAction)vibrationSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        [sender setThumbTintColor:[UIColor greenColor]];
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        notificationvibration = @"Yes";
        
        
    }else{
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        notificationvibration = @"No";
    }
}

#pragma mark - Custom AlertView

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

#pragma mark - Button Actions

-(IBAction)didClickSaveBntAction:(id)sender
{
    [COMMON LoadIcon:self.view];
    [self loadUpdateNotificationAPI];
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
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
    
    [self.navigationController pushViewController:termViewController animated:YES];
}
-(IBAction)didClickprivacypolicyAction:(id)sender
{
    
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
    
    [self.navigationController pushViewController:termViewController animated:YES];
    
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



#pragma mark - WebService
-(void)loadLocationUpdateAPI{
    
    [objWebService locationUpdate:LocationUpdate_API
                        sessionid:[COMMON getSessionID]
                         latitude:currentLatitude
                        longitude:currentLongitude
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              NSLog(@"responseObject = %@",responseObject);
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              
                          }];
    
}

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



-(void)loadUpdateNotificationAPI{
    [objWebService updateNotification:ProfileUpdate_API sessionID:[COMMON getSessionID] vibrationStr:notificationvibration messageStr:notificationMsg soundstr:notificationSound
                              success:^(AFHTTPRequestOperation *operation, id responseObject){
                               NSLog(@"responseObject = %@",responseObject);
                                  
                                  NSMutableDictionary *mainDict = [[NSMutableDictionary alloc]init];
                                  
                                  mainDict = [responseObject valueForKey:@"updateprofile"];
                                  
                                  if([[mainDict valueForKey:@"status"]isEqualToString:@"success"]){
                                      
                                      NSMutableDictionary *userDetailsDict = [[NSMutableDictionary alloc]init];
                                      
                                      userDetailsDict = [[mainDict valueForKey:@"userDetails"]objectAtIndex:0];
                                      
                                      [COMMON setUserDetails:userDetailsDict];
                                      
                                      [COMMON removeLoading];
                                  }
                                 
                                  
                               }
                              failure:^(AFHTTPRequestOperation *operation, id error) {
                                  
                              }];
    
    
}

@end
