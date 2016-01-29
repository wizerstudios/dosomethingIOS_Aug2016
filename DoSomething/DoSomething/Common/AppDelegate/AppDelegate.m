//
//  AppDelegate.m
//  DoSomething
//
//  Created by Keyar on 09/10/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "DSConfig.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DSHomeViewController.h"
#import "DSAppCommon.h"
#import "HomeViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "DSChatDetailViewController.h"
#import "DSWebservice.h"

@interface AppDelegate (){
    
    DSWebservice *webservice;
    
}



@end

@implementation AppDelegate

@synthesize locationButton,menuButton,chatsButton,buttonsView,buttons_array,profileButton,settingButton,SepratorLbl;
@synthesize homePage,chatPage,window, locationPage,profilePage,objSettingView;
@synthesize badgeCountLabel;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
      NSLog(@"### Running FB SDK Version: %@", [FBSDKSettings sdkVersion]);
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentLongitude];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentLatitude];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       // self.isNotificationSound = YES;
        [self initAPNS];
            });
    
    if ([COMMON isUserLoggedIn]) {
        
        userHomeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        self.window.rootViewController = userHomeView;
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:userHomeView];
    }
    else {
        splashViewController = [[DSHomeViewController alloc] initWithNibName:@"DSHomeViewController" bundle:nil];
        self.window.rootViewController = splashViewController;
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:splashViewController];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.navigationController];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [COMMON getUserCurrenLocation];
    [self TabBarViews];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [Fabric with:@[[Crashlytics class]]];
    });
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:HobbiesArray];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"backAction"];
  
    
    return YES;
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

-(void)TabBarViews
{
  
    buttonsView=[[UIView alloc]init];
    SepratorLbl     =[[UILabel alloc]init];
    badgeCountLabel = [[UILabel alloc]init];
    
    [buttonsView setBackgroundColor:[UIColor whiteColor]];
    [SepratorLbl setBackgroundColor:[UIColor grayColor]];

    buttonsView.frame=CGRectMake(self.window.frame.origin.x,self.window.frame.size.height-50,self.window.frame.size.width,50);
     SepratorLbl.frame =CGRectMake(buttonsView.frame.origin.x,buttonsView.frame.origin.y-2,buttonsView.frame.size.width,3);
     buttonsView.hidden=YES;
    SepratorLbl.hidden=YES;
    locationButton  =[[UIButton alloc]init];
    menuButton      =[[UIButton alloc]init];
    chatsButton     =[[UIButton alloc]init];
    profileButton   =[[UIButton alloc]init];
    settingButton   =[[UIButton alloc]init];
   
    
    
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
     UIImage *locationActive = [UIImage imageNamed:@"loaction_active.png"];
    [locationButton setBackgroundImage:locationActive forState:UIControlStateSelected];
    
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    UIImage *menuActive = [UIImage imageNamed:@"menu_btn.png"];
    [menuButton setBackgroundImage:menuActive forState:UIControlStateSelected];
    
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    UIImage *chatActive = [UIImage imageNamed:@"chats_active.png"];
    [chatsButton setBackgroundImage:chatActive forState:UIControlStateSelected];
    
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    UIImage *profileActive = [UIImage imageNamed:@"profile_active.png"];
    [chatsButton setBackgroundImage:profileActive forState:UIControlStateSelected];
    
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
    UIImage *settingActive = [UIImage imageNamed:@"setting_active.png"];
    [chatsButton setBackgroundImage:settingActive forState:UIControlStateSelected];
    
    
    [locationButton addTarget:self action:@selector(locationView) forControlEvents:UIControlEventTouchUpInside];
    
    [menuButton addTarget:self action:@selector(menuView) forControlEvents:UIControlEventTouchUpInside];
    
    [chatsButton addTarget:self action:@selector(chatView) forControlEvents:UIControlEventTouchUpInside];
    
    [profileButton addTarget:self action:@selector(profileView) forControlEvents:UIControlEventTouchUpInside];
    
    [settingButton addTarget:self action:@selector(settingView) forControlEvents:UIControlEventTouchUpInside];
    
    profileButton.frame=CGRectMake(20,3,40,40);
    locationButton.frame=CGRectMake(profileButton.frame.origin.x+profileButton.frame.size.width+20,3,40,40);
    menuButton.frame=CGRectMake(buttonsView.center.x-15,3,45,45);
    chatsButton.frame=CGRectMake(menuButton.frame.origin.x+menuButton.frame.size.width+17,3,40,40);
    settingButton.frame =CGRectMake(chatsButton.frame.origin.x+chatsButton.frame.size.width+17,3,40,40);
    
    [badgeCountLabel setFrame:CGRectMake(menuButton.frame.origin.x+menuButton.frame.size.width+45,5,20,20)];
    badgeCountLabel.layer.cornerRadius = 10.0;
    [badgeCountLabel.layer setMasksToBounds:YES];
    [badgeCountLabel setTextColor:[UIColor whiteColor]];
    [badgeCountLabel setTextAlignment:NSTextAlignmentCenter];
    [badgeCountLabel setFont:PATRON_REG(12)];
    [badgeCountLabel setBackgroundColor:[UIColor redColor]];
    
   
       if(IS_IPHONE6)
    {
        profileButton.frame=CGRectMake(buttonsView.frame.origin.x+20,3,45,45);
        menuButton.frame=CGRectMake(self.window.frame.size.width/2-18,3,45,45);
        chatsButton.frame=CGRectMake(menuButton.frame.origin.x+menuButton.frame.size.width+25,3,45,45);
        locationButton.frame=CGRectMake(profileButton.frame.origin.x+profileButton.frame.size.width+25,profileButton.frame.origin.y,45,45);
        settingButton.frame =CGRectMake(chatsButton.frame.origin.x+chatsButton.frame.size.width+25,chatsButton.frame.origin.y,45,45);
    }
    else if   (IS_IPHONE6_Plus)
    {
        profileButton.frame=CGRectMake(buttonsView.frame.origin.x+20,3,45,45);
        menuButton.frame=CGRectMake(self.window.frame.size.width/2-18,3,45,45);
        chatsButton.frame=CGRectMake(menuButton.frame.origin.x+menuButton.frame.size.width+30,3,45,45);
        locationButton.frame=CGRectMake(profileButton.frame.origin.x+profileButton.frame.size.width+30,profileButton.frame.origin.y,45,45);
        settingButton.frame =CGRectMake(chatsButton.frame.origin.x+chatsButton.frame.size.width+30,chatsButton.frame.origin.y,45,45);
        [badgeCountLabel setFrame:CGRectMake(menuButton.frame.origin.x+menuButton.frame.size.width+55,5,20,20)];
    }

    [self.window.rootViewController.view addSubview:buttonsView];
    [self.window.rootViewController.view addSubview:SepratorLbl];
   
    [buttonsView addSubview:locationButton];
    [buttonsView addSubview:menuButton];
    [buttonsView addSubview:chatsButton];
    [buttonsView addSubview:profileButton];
    [buttonsView addSubview:settingButton];
    [buttonsView addSubview:badgeCountLabel];
    
    buttons_array=[[NSMutableArray alloc]init];
    [buttons_array addObject:locationButton];
    [buttons_array addObject:menuButton];
    [buttons_array addObject:chatsButton];
    [buttons_array addObject:profileButton];
    [buttons_array addObject:chatsButton];
    
    [badgeCountLabel setHidden:YES];
}

-(void)locationView
{
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_active.png"] forState:UIControlStateNormal];
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    locationPage =[[DSLocationViewController alloc]initWithNibName:@"DSLocationViewController" bundle:nil];
    [self.navigationController pushViewController:locationPage animated:NO];
}
-(void)menuView{
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    homePage =[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:homePage animated:NO];
}
-(void)chatView
{
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats_active.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    chatPage =[[DSChatsTableViewController alloc]initWithNibName:@"DSChatsTableViewController" bundle:nil];
    [self.navigationController pushViewController:chatPage animated:NO];
}
-(void)profileView
{
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile_active.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    profilePage =[[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    [self.navigationController pushViewController:profilePage animated:NO];
        
    
}

-(void)settingView
{
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting_active.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    objSettingView =[[SettingView alloc]initWithNibName:@"SettingView" bundle:nil];
    [self.navigationController pushViewController:objSettingView animated:NO];

}

- (void)initAPNS{
    if(IS_GREATER_IOS8)
    {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {

                 [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil]];
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            
        } else {
            
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];

        }
    }
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    [[NSUserDefaults standardUserDefaults]setValue:token forKey:DeviceToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
    

}

#pragma mark Push Notification Services

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"UserInfo = %@",userInfo);
    
    NSString *badgecountStr = [NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"]valueForKey:@"msgcnt"]];
    [[NSUserDefaults standardUserDefaults]setObject:badgecountStr forKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if(![badgecountStr isEqualToString:@"0"]){
        [badgeCountLabel setText:badgecountStr];
        [badgeCountLabel setHidden:NO];
    }
    
    if (application.applicationState == UIApplicationStateInactive) {
        [self handleRemoteNotification:application userInfo:userInfo];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void) handleRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo {
    
    NSLog(@"userInfo=%@",userInfo);
    
     NSString *badgecountStr = [NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"]valueForKey:@"msgcnt"]];
    [[NSUserDefaults standardUserDefaults]setObject:badgecountStr forKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if(![badgecountStr isEqualToString:@"0"]){
        [badgeCountLabel setText:badgecountStr];
        [badgeCountLabel setHidden:NO];
    }
    
    NSString *conversationid =[[userInfo valueForKey:@"aps"]valueForKey:@"conversationid"];

    [self loadnotificationmsg: conversationid];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
}
-(void)loadnotificationmsg:(NSString*)conversationID
{
    NSLog(@"session id=%@",[COMMON getSessionID]);
    
    if(![[COMMON getSessionID]isEqualToString:@"(null)"]){
        [self loadConverstaionAPI:conversationID];
    }
    
   
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

   [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

-(void)loadConverstaionAPI:(NSString *)_conversationID{
    
    
    webservice = [[DSWebservice alloc]init];
    
    [webservice getConversation:GetConversation sessionID:[COMMON getSessionID] conversationId:_conversationID dateTime:[COMMON getCurrentDateTime]
                        success:^(AFHTTPRequestOperation *operation, id responseObject){
                            
                            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc]init];
                            
                            responseDict = [[responseObject valueForKey:@"getconversation"]mutableCopy];
                            
                            if([[responseDict valueForKey:@"status"]isEqualToString:@"success"]){
                                
                                NSMutableDictionary *receiverDict = [[NSMutableDictionary alloc]init];
                                receiverDict = [[responseDict valueForKey:@"receiver"]objectAtIndex:0];
                                DSChatDetailViewController *ChatDetail =[[DSChatDetailViewController alloc]initWithNibName:nil bundle:nil];
                                ChatDetail.conversionID = _conversationID;
                                ChatDetail.chatuserDetailsDict = [receiverDict mutableCopy];
                                [self.navigationController pushViewController:ChatDetail animated:YES];
                                
                            }
                        }
     
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            [COMMON removeLoading];
                            
                        }];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if(application.applicationState == UIApplicationStateInactive) {
        
        NSLog(@"Inactive");
        
         //Show the view with the content of the push
        
        [self handleRemoteNotification:application userInfo:userInfo];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"Background");
        
        //Refresh the local model
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else {
        
        NSLog(@"Active");
        
        //Show an in-app banner
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
    
    
    NSString *badgecountStr = [NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"]valueForKey:@"msgcnt"]];
    [[NSUserDefaults standardUserDefaults]setObject:badgecountStr forKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if(![badgecountStr isEqualToString:@"0"]){
        [badgeCountLabel setText:badgecountStr];
        [badgeCountLabel setHidden:NO];
    }
    
    
}


@end
