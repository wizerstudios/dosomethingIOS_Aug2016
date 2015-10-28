//
//  AppDelegate.h
//  DoSomething
//
//  Created by Keyar on 09/10/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHomeViewController.h"
#import "HomeViewController.h"
#import "DSChatsTableViewController.h"
#import "DSLocationViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DSHomeViewController *splashViewController;
    UIWindow *window;
    UITabBarController *tabBarController;

}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (strong, nonatomic) HomeViewController *homePage;
@property (strong, nonatomic) DSLocationViewController *locationPage;
@property (strong, nonatomic) DSChatsTableViewController *chatPage;


@property(nonatomic,retain)UIView *buttonsView;
@property(nonatomic,retain)UIButton *locationButton;
@property(nonatomic,retain)UIButton *menuButton;
@property(nonatomic,retain)UIButton *chatsButton;
@property(nonatomic,retain)NSMutableArray *buttons_array;
@end

