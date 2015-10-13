//
//  ChatsTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/13/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "ChatsTableViewController.h"
#import "CustomNavigationView.h"

@interface ChatsTableViewController ()

@end

@implementation ChatsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
}

-(void)loadNavigation{
    
    self.navigationController.navigationBarHidden=YES;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 56);
    
   [customNavigation setbuttonBackHidden:YES];
    [self.view addSubview:customNavigation.view];
    
    
}

@end
