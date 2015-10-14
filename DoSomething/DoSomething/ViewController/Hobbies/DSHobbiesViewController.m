//
//  DSHobbiesViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 14/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSHobbiesViewController.h"
#import "CustomNavigationView.h"

@interface DSHobbiesViewController ()

@end

@implementation DSHobbiesViewController

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
    customNavigation.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),56);
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.buttonBack addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    //    [customNavigation setlogoutButtonHidden:YES];
    //    [customNavigation setbackButtonHidden:YES];
    
    
}
- (void)BackAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
