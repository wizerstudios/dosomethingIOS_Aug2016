//
//  AppDelegate.m
//  DoSomething
//
//  Created by Keyar on 09/10/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "DSConfig.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize locationButton,menuButton,chatsButton,buttonsView,buttons_array;
@synthesize homePage,chatPage,window, locationPage;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends",@"email",@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                      }];
        
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    splashViewController = [[DSHomeViewController alloc] initWithNibName:@"DSHomeViewController" bundle:nil];
    self.window.rootViewController = splashViewController;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:splashViewController];
    [self.window setRootViewController:self.navigationController];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self TabBarViews];
    
    return YES;
}

-(void)TabBarViews
{
    int wVal=self.window.bounds.size.width;
    int hVal=self.window.bounds.size.height;
    buttonsView=[[UIView alloc]init];
    [buttonsView setBackgroundColor:[UIColor whiteColor]];
//    [buttonsView setBackgroundColor:[UIColor colorWithRed:(float)239.0/255 green:(float)239.0/255 blue:(float)239.0/255 alpha:1.0f]];
    
    if (IS_IPHONE4) {
        buttonsView.frame=CGRectMake(0,hVal-hVal/10,wVal,hVal/10);
        buttonsView.hidden=YES;
        
    }
    else if (IS_IPHONE5)
    {
        buttonsView.frame=CGRectMake(0,hVal-hVal/11,wVal,hVal/11);
        buttonsView.hidden=YES;
        
    }
    else if (IS_IPHONE6)
    {
        buttonsView.frame=CGRectMake(0,hVal-hVal/13,wVal,hVal/13);
        buttonsView.hidden=YES;
        
    }
    else if (IS_IPHONE6_Plus)
    {
        buttonsView.frame=CGRectMake(0,hVal-hVal/15,wVal,hVal/15);
        buttonsView.hidden=YES;
    }
    locationButton=[[UIButton alloc]init];
    menuButton=[[UIButton alloc]init];
    chatsButton=[[UIButton alloc]init];
    
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    UIImage *locationActive = [UIImage imageNamed:@"loaction_active.png"];
    [locationButton setBackgroundImage:locationActive forState:UIControlStateSelected];
    
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    UIImage *menuActive = [UIImage imageNamed:@"menu_btn.png"];
    [menuButton setBackgroundImage:menuActive forState:UIControlStateSelected];
    
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    UIImage *chatActive = [UIImage imageNamed:@"chats_active.png"];
    [chatsButton setBackgroundImage:chatActive forState:UIControlStateSelected];
    
    
    [locationButton addTarget:self action:@selector(locationView) forControlEvents:UIControlEventTouchUpInside];
    
    [menuButton addTarget:self action:@selector(menuView) forControlEvents:UIControlEventTouchUpInside];
    
    [chatsButton addTarget:self action:@selector(chatView) forControlEvents:UIControlEventTouchUpInside];
    
    locationButton.frame=CGRectMake(30,3,50,50);
    menuButton.frame=CGRectMake(140,3,45,45);
    chatsButton.frame=CGRectMake(240,3,50,50);
    
    if(IS_IPHONE6)
    {
        locationButton.frame=CGRectMake(50,3,50,50);
        menuButton.frame=CGRectMake(170,3,45,45);
        chatsButton.frame=CGRectMake(280,3,50,50);
    }
    else if   (IS_IPHONE6_Plus)
    {
        locationButton.frame=CGRectMake(60,3,50,50);
        menuButton.frame=CGRectMake(190,3,45,45);
        chatsButton.frame=CGRectMake(320,3,50,50);
    }
    [self.window.rootViewController.view addSubview:buttonsView];
    
    [buttonsView addSubview:locationButton];
    [buttonsView addSubview:menuButton];
    [buttonsView addSubview:chatsButton];
    
    buttons_array=[[NSMutableArray alloc]init];
    [buttons_array addObject:locationButton];
    [buttons_array addObject:menuButton];
    [buttons_array addObject:chatsButton];
}

-(void)locationView
{
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_active.png"] forState:UIControlStateNormal];
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    
    locationPage =[[DSLocationViewController alloc]initWithNibName:@"DSLocationViewController" bundle:nil];
    [self.navigationController pushViewController:locationPage animated:NO];
}
-(void)menuView{
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    
    homePage =[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:homePage animated:NO];
}
-(void)chatView
{
    [chatsButton setBackgroundImage:[UIImage imageNamed:@"chats_active.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
    
    chatPage =[[DSChatsTableViewController alloc]initWithNibName:@"DSChatsTableViewController" bundle:nil];
    [self.navigationController pushViewController:chatPage animated:NO];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];

}

#pragma mark -FBIntegration


// FB Logic
// In the login workflow, the Facebook native application, or Safari will transition back to
// this applicaiton via a url following the scheme fb[app id]://; the call to handleOpenURL
// below captures the token, in the case of success, on behalf of the FBSession object
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


@end
