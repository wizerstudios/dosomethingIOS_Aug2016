//
//  DSHobbiesViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 14/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSHobbiesViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"

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
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    if (IS_IPHONE4 ||IS_IPHONE5)
    {
        customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    }
    else    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        
        
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
