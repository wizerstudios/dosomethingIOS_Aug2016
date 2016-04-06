//
//  DSTermsViewController.m
//  DoSomething
//
//  Created by OCS iOS Developer on 18/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "DSTermsViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "DSWebservice.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+FontAwesome.h"


@interface DSTermsViewController ()<UIWebViewDelegate>

@end

@implementation DSTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContent];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
        self.termtoplblYposition.constant =80;
        
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
         self.termtoplblYposition.constant =100;
        
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
-(void)loadContent
{
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *homeIndexUrl;
    if([self.policytypeofContent isEqualToString:@"Term"])
    {
         homeIndexUrl = [mainBundle URLForResource:@"TermsofService" withExtension:@"docx"];
    }
    else
    {
        homeIndexUrl = [mainBundle URLForResource:@"PrivacyPolicy" withExtension:@"docx"];
    }
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:homeIndexUrl];
    
    [self.termscontentweb loadRequest:urlReq];
    
   
    }
-(void)viewDidAppear:(BOOL)animated
{
     [COMMON TrackerWithName:@"Terms of Use & Private Policy"];
}
#pragma mark - back Action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [COMMON removeLoading];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
