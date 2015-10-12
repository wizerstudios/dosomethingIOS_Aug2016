//
//  LoginViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 09/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSLoginViewController.h"
#import "DSSplashViewController.h"
#define PATRON_BOLD(Value)      [UIFont fontWithName:@"Patron-Bold" size:Value]
#define PATRON_REG(Value)       [UIFont fontWithName:@"Patron-Regular" size:Value]


@interface DSLoginViewController ()

@end

@implementation DSLoginViewController
@synthesize temp,facebookLabel,emailLabel,buttonActionLabel,termsOfUseButton,privacyPolicyButton,signInButton,forgotButton,createAnAccButton,instructionLabel,createAnAccLabel;
- (void)viewDidLoad {
    [super viewDidLoad];   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    if ([temp isEqualToString:@"createAnAccount"]){
        self.signInButtonHeight.constant =-30;
        NSString *string = @"Create an account using Facebook";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string ];
        [attStr addAttribute:NSFontAttributeName value:PATRON_REG(12) range:[string rangeOfString:@"Create an account using"]];
        
        [attStr addAttribute:NSFontAttributeName value:PATRON_BOLD(12) range:[string rangeOfString:@"Facebook"]];
        facebookLabel.attributedText = attStr;
        
        emailLabel.text =@"or sign up with your email";
        createAnAccLabel.text =@"Create Your Account";
        instructionLabel.text =@"By selecting this,you agree to our Terms of Use and our Privacy Policy";
        createAnAccButton.hidden =YES;
        forgotButton.hidden=YES;


            }
    if ([temp isEqualToString:@"Signin"]){

        
            NSString *string = @"Log in with Facebook";
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string ];
            [attStr addAttribute:NSFontAttributeName value:PATRON_REG(12) range:[string rangeOfString:@"Log in with"]];
        
            [attStr addAttribute:NSFontAttributeName value:PATRON_BOLD(12) range:[string rangeOfString:@"Facebook"]];
            facebookLabel.attributedText = attStr;
        
        emailLabel.text =@"or log in with your email";
        buttonActionLabel.text =@"Sign in";
        privacyPolicyButton.hidden =YES;
        termsOfUseButton.hidden =YES;
        signInButton.hidden =YES;
        
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


- (IBAction)Back:(id)sender {
    DSSplashViewController * DSSplashView  = [[DSSplashViewController alloc]initWithNibName:@"DSSplashViewController" bundle:nil];
    [self.navigationController pushViewController:DSSplashView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
