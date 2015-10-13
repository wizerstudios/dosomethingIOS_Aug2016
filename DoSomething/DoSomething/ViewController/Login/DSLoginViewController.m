//
//  LoginViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 09/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSLoginViewController.h"
#import "DSSplashViewController.h"
#import "DSProfileTableViewController.h"
#import "DSConfig.h"



@interface DSLoginViewController ()

@end

@implementation DSLoginViewController
@synthesize temp,labelFacebook,labelEmail,labelSignIn,buttonTermsOfUse,buttonPrivacyPolicy,buttonSignIn,buttonForgotPass,buttonCreateAnAcc,labelInstruction,labelCreateAnAcc,buttonHaveAnAcc;
- (void)viewDidLoad {
    [super viewDidLoad];   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
 if ([temp isEqualToString:@"createAnAccount"]){
      self.buttonSignInHeightConstraint.constant =50;
      NSString *string = @"Create an account using Facebook";
      NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string ];
      [attStr addAttribute:NSFontAttributeName value:PATRON_REG(12) range:[string rangeOfString:@"Create an account using"]];
      [attStr addAttribute:NSFontAttributeName value:PATRON_BOLD(12) range:[string rangeOfString:@"Facebook"]];
      labelFacebook.attributedText = attStr;
      labelEmail.text =@"Or sign up with your email";
      labelCreateAnAcc.text =@"Create Your Account";
      labelInstruction.text =@"By selecting this,you agree to our Terms of Use and our Privacy Policy";
      [buttonTermsOfUse setTitle:@"Terms of Use" forState:UIControlStateNormal];
      [buttonPrivacyPolicy setTitle:@"Privacy Policy" forState:UIControlStateNormal];
      [buttonHaveAnAcc setTitle:@"Have an account? Sign In" forState:UIControlStateNormal];
      buttonCreateAnAcc.hidden =YES;
      buttonForgotPass.hidden=YES;
     [buttonSignIn addTarget:self action:@selector(CreateAnAccount) forControlEvents:UIControlEventTouchUpInside];

}
 if ([temp isEqualToString:@"Signin"]){
       
      NSString *string = @"Log in with Facebook";
      NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string ];
     [attStr addAttribute:NSFontAttributeName value:PATRON_REG(12) range:[string rangeOfString:@"Log in with"]];
     [attStr addAttribute:NSFontAttributeName value:PATRON_BOLD(12) range:[string rangeOfString:@"Facebook"]];
     labelFacebook.attributedText = attStr;
        
     labelEmail.text =@"Or log in with your email";
     labelSignIn.text =@"Sign in";
     [buttonForgotPass setTitle:@"Forgot password?" forState:UIControlStateNormal];
     [buttonCreateAnAcc setTitle:@"Create an Account" forState:UIControlStateNormal];
     buttonPrivacyPolicy.hidden =YES;
     buttonTermsOfUse.hidden =YES;
     buttonSignIn.hidden =NO;
    }

    
    
}
- (IBAction)HaveAnAccount:(id)sender {
    DSLoginViewController * DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
    DSLoginView.temp = @"Signin";
    [self.navigationController pushViewController:DSLoginView animated:YES];

    
}
- (IBAction)CreateAnAccButton:(id)sender {
    DSLoginViewController * DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
    DSLoginView.temp = @"createAnAccount";
    [self.navigationController pushViewController:DSLoginView animated:YES];
    
    
}
-(void)CreateAnAccount
{
    DSProfileTableViewController *  DSProfileTableView  = [[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    [self.navigationController pushViewController: DSProfileTableView animated:YES];

}


- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
