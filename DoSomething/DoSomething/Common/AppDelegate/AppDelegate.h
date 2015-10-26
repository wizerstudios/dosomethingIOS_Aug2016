//
//  AppDelegate.h
//  DoSomething
//
//  Created by Keyar on 09/10/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DSHomeViewController *splashViewController;

}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;
@end

