//
//  ProfileTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSProfileTableViewController.h"
#import "CustomNavigationView.h"

@interface DSProfileTableViewController ()

@end

@implementation DSProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNavigation{
    
    self.navigationController.navigationBarHidden=YES;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 56);
     [customNavigation.buttonBack addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
//    [customNavigation setlogoutButtonHidden:YES];
//    [customNavigation setbackButtonHidden:YES];
    [self.view addSubview:customNavigation.view];    
    
    
}
- (void)BackAction {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
