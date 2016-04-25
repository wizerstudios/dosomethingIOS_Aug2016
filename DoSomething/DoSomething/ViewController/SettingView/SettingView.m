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
#import <AudioToolbox/AudioToolbox.h>
#import "CustomSoundview.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface SettingView ()
{
   
    DSWebservice    *objWebService;
    NSString        *optionLogoutDelete;
    NSString        * notificationMsg;
    NSString        * notificationSound;
    NSString        * notificationMatch;
    AppDelegate     *appDelegate;
  
    CustomAlterview * objCustomAlterview;
    CustomSoundview * objCustomSoundview;
    UIWindow        *windowInfo;
    NSString        * currentLatitude, * currentLongitude;
    NSString * selectSoundStr;
    NSString * playsoundBundleStr;
    SystemSoundID *soundID;
    NSMutableDictionary *profileDict;
     BOOL _isStartTimer;
}
@property (nonatomic,strong) IBOutlet NSLayoutConstraint    * deletebuttonBottomoposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint    * scrollYposition;


@end
@implementation SettingView
@synthesize settingScroll,locationManager,messSwitch,soundSwitch,matchSwitch,onlineStatusTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [COMMON TrackerWithName:@"Settings"];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    objWebService =[[DSWebservice alloc]init];
    settingScroll.scrollEnabled =YES;
    profileDict=[[NSMutableDictionary alloc]init];
    profileDict = [COMMON getUserDetails];
   
    notificationMsg=[profileDict valueForKey:@"notification_message"];
    notificationSound=[profileDict valueForKey:@"notification_sound"];
    notificationMatch=[profileDict valueForKey:@"isMatch"];
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getUserCurrenLocation];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInvalidSessionAlert:)
                                                 name:@"InvalidSession"
                                               object:nil];
    
    [self loadNavigationview];
    
    [self CustomAlterviewload];
    [self customSoundView];
   
    self.deletebuttonBottomoposition.constant =(IS_IPHONE4)?30:0;
    self.scrollYposition.constant =0;
    
    if(IS_IPHONE6)
    {
        self.scrollYposition.constant =15;
        self.deletebuttonBottomoposition.constant =-70;
    }
    if(IS_IPHONE6_Plus)
    {
        self.deletebuttonBottomoposition.constant =-150;
        self.scrollYposition.constant =15;
    }
    
}

-(void)viewDidLayoutSubviews{
    
    if(IS_IPHONE4){
        [self.settingScroll setContentSize:CGSizeMake(320,450)];
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
    if (IS_IPHONE6)
    {
        customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame),76);
    }
    if(IS_IPHONE6_Plus){
        customNavigation.view.frame = CGRectMake(0,-20,CGRectGetWidth(self.view.frame), 83);
    }

    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:NO];
    [customNavigation.saveBtn addTarget:self action:@selector(didClickSaveBntAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
      [self notificationMethod];
    
    
    UISwipeGestureRecognizer *messBtnleftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationmsgBtnSwipLeftAction:)];
    [messBtnleftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [messSwitch addGestureRecognizer:messBtnleftRecognizer];
    
    
    UISwipeGestureRecognizer *messBtnrightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationmessBtnSwipRightAction:)];
    [messBtnrightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [messSwitch addGestureRecognizer:messBtnrightRecognizer];
    
    UISwipeGestureRecognizer *matchBtnleftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationMatchBtnSwipLeftAction:)];
    [matchBtnleftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [matchSwitch addGestureRecognizer:matchBtnleftRecognizer];
    
    
    UISwipeGestureRecognizer *matchBtnrightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationMatchBtnSwipRightAction:)];
    [matchBtnrightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [matchSwitch addGestureRecognizer:matchBtnrightRecognizer];
    
    UISwipeGestureRecognizer *soundBtnleftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationsoundBtnSwipLeftAction:)];
    [soundBtnleftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [soundSwitch addGestureRecognizer:soundBtnleftRecognizer];
    
    
    UISwipeGestureRecognizer *SoundBtnrightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationsoundBtnSwipRightAction:)];
    [SoundBtnrightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [soundSwitch addGestureRecognizer:SoundBtnrightRecognizer];
    
   
    [soundSwitch addTarget:self action:@selector(NotificationbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [messSwitch addTarget:self action:@selector(NotificationbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [matchSwitch addTarget:self action:@selector(NotificationbuttonAction:) forControlEvents:UIControlEventTouchUpInside];

  
}

-(void)NotificationmsgBtnSwipLeftAction:(id)sender
{
    
    [messSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    notificationMsg =@"No";
    
    
}
-(void)NotificationmessBtnSwipRightAction:(id)sender
{
    
    [messSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    notificationMsg =@"Yes";
    
}

-(void)NotificationMatchBtnSwipLeftAction:(id)sender
{
    
    [matchSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    notificationMatch =@"No";
    
    
}
-(void)NotificationMatchBtnSwipRightAction:(id)sender
{
    
    [matchSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    notificationMatch =@"Yes";
    
}



-(void)NotificationsoundBtnSwipLeftAction:(id)sender
{
    //objCustomSoundview.view.hidden=NO;
    //objCustomSoundview.soundmenuView.hidden=NO;
    [soundSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    notificationSound =@"No";
//    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.isNotificationSound = NO;
//    [appDelegate initAPNS];
    
}
-(void)NotificationsoundBtnSwipRightAction:(id)sender
{
    objCustomSoundview.view.hidden=NO;
    objCustomSoundview.soundmenuView.hidden=NO;
    [soundSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    notificationSound =@"Yes";
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
}

#pragma mark -notificationMethod
-(void)notificationMethod
{
    
    NSString * objMsg =[notificationMsg isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objMatch =[notificationMatch isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[notificationSound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
  
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [messSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        notificationMsg =@"Yes";
       
    }
    
    if([objMatch isEqualToString:@"switch_on"])
    {
        [matchSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        notificationMatch =@"Yes";
        
    }
    
    if([objSound isEqualToString:@"switch_on"])
    {
        [soundSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        notificationSound =@"Yes";
    }
    
    
    if([objMsg isEqualToString:@"switch_off"])
    {
        [messSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        notificationMsg =@"No";
    }
    if([objMatch isEqualToString:@"switch_off"])
    {
        [matchSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        notificationMatch =@"No";
    }
    if([objSound isEqualToString:@"switch_off"])
    {
        [soundSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        notificationSound =@"No";
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
    
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
    
    NSString *savedLatitude =  [[NSUserDefaults standardUserDefaults]valueForKey:CurrentLatitude];
    NSString *savedLongitude = [[NSUserDefaults standardUserDefaults]valueForKey:CurrentLongitude];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    NSLog(@"savedLatitude & saved Longitude = %@ & %@",savedLatitude,savedLongitude);

    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if((![currentLatitude isEqualToString:savedLatitude] || ![currentLongitude isEqualToString:savedLongitude]) && (currentLongitude !=nil || currentLatitude != nil))
             [self loadLocationUpdateAPI];
           
          dispatch_async(dispatch_get_main_queue(), ^(){
            
         });
           
    });
    
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}

-(void)NotificationbuttonAction:(UIButton *)sender
{
       
    if([sender tag] == 601){
        if ( [notificationMsg isEqualToString:@"Yes"]) {
            
            [messSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            notificationMsg =@"No";
            
        }else{
            
            [messSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            notificationMsg =@"Yes";
        }
        
        
    }
    else if([sender tag] == 604){
        if ( [notificationMatch isEqualToString:@"Yes"]) {
            
            [matchSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            notificationMatch =@"No";
            
        }else{
            
            [matchSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            notificationMatch =@"Yes";
        }
        
        
    }

    
    else if([sender tag] == 602){
        
        if ( [notificationSound isEqualToString:@"Yes"]) {
            
            [soundSwitch setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            notificationSound =@"No";
            
        }else{
            objCustomSoundview.view.hidden=NO;
            objCustomSoundview.soundmenuView.hidden=NO;
            [soundSwitch setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            notificationSound =@"Yes";
        }
        
        
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
    if(IS_IPHONE6||IS_IPHONE6_Plus)
    {
        objCustomAlterview.mainalterviewheight.constant=50;
    }
    else
    {
        objCustomAlterview.mainalterviewheight.constant=0;
    }

    [self.view addSubview:objCustomAlterview.view];
    
}
- (IBAction)alertPressYes:(id)sender {
    
    [self logoutDeleteAction];
    _isStartTimer = NO;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadonlineStausAPI:@"0"];
        [self stopTimer];
    });

    objCustomAlterview.view.hidden =YES;
    objCustomAlterview. alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
}
- (IBAction)alertPressNo:(id)sender {
    
    objCustomAlterview.alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    objCustomAlterview.view.hidden =YES;
}
#pragma customSoundview
-(void)customSoundView
{
    objCustomSoundview = [[CustomSoundview alloc] initWithNibName:@"CustomSoundview" bundle:nil];
    objCustomSoundview.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width, self.view.frame.size.height);
   // [objCustomSoundview.alertBgView setHidden:YES];
    [self.view layoutIfNeeded];
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
        objCustomSoundview.soundmenuheight.constant=180;
    }
    
    [objCustomSoundview.soundmenuView setHidden:YES];
    
    [objCustomSoundview.soundMenuCancelBtn addTarget:self action:@selector(DidclickSoundMenuCancel:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomSoundview.soundmenuOkBtn addTarget:self action:@selector(didClickSoundOk:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.settingScroll addSubview:objCustomSoundview.view];

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
     termViewController.policytypeofContent =@"Term";
    [self.navigationController pushViewController:termViewController animated:YES];
}
-(IBAction)didClickprivacypolicyAction:(id)sender
{
    
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
     termViewController.policytypeofContent =@"policy";
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
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    if(deviceToken == nil)
        deviceToken = @"";
    
    
    if([COMMON isInternetReachable]){
        
        [objWebService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                          deviceToken:deviceToken pushType:push_type
                              success:^(AFHTTPRequestOperation *operation, id responseObject){
                                  NSLog(@"responseObject = %@",responseObject);
                                  if([[responseObject valueForKey:@"status"]isEqualToString:@"success"]){
                                      [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:CurrentLatitude];
                                      [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:CurrentLongitude];
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, id error) {
                                  
                              }];
        
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }
    
    
  }

-(void)logoutDeleteAction{
    
    if([COMMON isInternetReachable]){
        
        
        DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
        
        [self.navigationController pushViewController:objSplashView animated:NO];
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        appDelegate.buttonsView.hidden=YES;
        
        appDelegate.SepratorLbl.hidden=YES;
        
        [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
        
        [objWebService logoutDeleteUser:User_Logout_Delete_API
         
                              sessionId:[COMMON getSessionID]
         
                                     op:optionLogoutDelete
         
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    NSLog(@"logoutDeleteUser %@ =" , responseObject);
                                    
                                    if([[[responseObject valueForKey:@"useraction"]valueForKey:@"status"] isEqualToString:@"success"])
                                        
                                    {
                                        
                                        if([optionLogoutDelete isEqualToString:@"delete"])
                                        {
                                    
                                        if([[profileDict valueForKey:@"type"]isEqualToString:@"2"]){
                                            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                                            [loginManager logOut];
                                            [FBSDKAccessToken setCurrentAccessToken:nil];
                                        }
                                        }
                                        [COMMON removeUserDetails];
                                        
                                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:HobbiesArray];
                                        [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:FirstloginChatview];
                                    }
                                    
                                }
         
                                failure:^(AFHTTPRequestOperation *operation, id error) {
                                    
                                    
                                }];
        
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

  }



-(void)loadUpdateNotificationAPI{
    
    
    if([COMMON isInternetReachable]){
        
        [objWebService updateNotification:ProfileUpdate_API sessionID:[COMMON getSessionID]messageStr:notificationMsg soundstr:notificationSound
                                    match:notificationMatch
                                   sound:selectSoundStr
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
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)DidclickSoundMenuCancel:(id)sender
{
    
    objCustomSoundview.view.hidden=YES;
    objCustomSoundview.soundmenuView.hidden=YES;
    playsoundBundleStr=objCustomSoundview.urlString;
    soundID =(objCustomSoundview.selectSoundID);
    if(soundID != 0 || soundID != NULL)
    {
        
        AudioServicesRemoveSystemSoundCompletion (*(soundID));
        
        AudioServicesDisposeSystemSoundID(*(soundID));
    }
 
}
-(IBAction)didClickSoundOk:(id)sender
{
       selectSoundStr=objCustomSoundview.selectSoundStr;
    NSLog(@"Soundstring=%@",selectSoundStr);
    //[self loadUpdateNotificationAPI];
    playsoundBundleStr=objCustomSoundview.urlString;
    //NSURL *soundURL = [NSURL fileURLWithPath:playsoundBundleStr];
    // NSLog(@"selectSoundID=%d",objCustomSoundview.selectSoundID);
     soundID =objCustomSoundview.selectSoundID;
    if(soundID != 0  || soundID != NULL)
    {
       
        AudioServicesRemoveSystemSoundCompletion (*(soundID));
        
        AudioServicesDisposeSystemSoundID(*(soundID));
    }
      objCustomSoundview.view.hidden=YES;
    objCustomSoundview.soundmenuView.hidden=YES;
}
-(IBAction)displaySoundmenuList:(id)sender
{
    objCustomSoundview.view.hidden=NO;
    objCustomSoundview.soundmenuView.hidden=NO;
}
-(void)startTimer{
    
    if(onlineStatusTimer == nil)
        onlineStatusTimer = [NSTimer scheduledTimerWithTimeInterval:timerSeconds target:self selector:@selector(loadonlineStausAPI) userInfo:nil repeats:YES];
    
}
-(void)stopTimer{
    
    if(onlineStatusTimer){
        [onlineStatusTimer invalidate];
        onlineStatusTimer =nil;
    }
    
}
-(void)loadonlineStausAPI
{
    if(_isStartTimer==YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadonlineStausAPI:@"1"];
            [self startTimer];
        });
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadonlineStausAPI:@"0"];
            [self stopTimer];
        });
        
    }
    
}
-(void)loadonlineStausAPI:(NSString *) status
{
    
    if(![[COMMON getSessionID] isEqualToString:@"(null)"]){
        objWebService = [[DSWebservice alloc]init];
        [objWebService getOnlinstatus:OnlineStatus sessionID:[COMMON getSessionID] status:status success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"onlinestausresponseObject= %@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            NSLog(@"onlinestausresponseObjecterror= %@",error);
        }];
    }
}


@end
