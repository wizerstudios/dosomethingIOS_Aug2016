//
//  LoginViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 09/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSLoginViewController.h"

@interface DSLoginViewController ()

@end

@implementation DSLoginViewController
@synthesize temp,facebookLabel,emailLabel,buttonActionLabel,termsOfUseLabel,privacyPolicyLabel,signinLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([temp isEqualToString:@"createAnAccount"]){
        facebookLabel.text =@"Create an account using Facebook";
        emailLabel.text =@"or sign up with your email";
        buttonActionLabel.text =@"Create Your Account";
        termsOfUseLabel.text =@"Terms of Use";
        privacyPolicyLabel.text =@"Privacy Policy";
        signinLabel.text =@"Have an account? Sign In";


            }
    if ([temp isEqualToString:@"Signin"]){
        facebookLabel.text =@"Log in with Facebook";
        emailLabel.text =@"or log in with your email";
        buttonActionLabel.text =@"Sign in";
        
    }

    
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:statusBarView];    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
