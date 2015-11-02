//
//  LoginViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 09/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//
#import "DSLoginViewController.h"
#import "DSHomeViewController.h"
#import "DSProfileTableViewController.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "CustomNavigationView.h"
#import "HomeViewController.h"
#import "DSWebservice.h"
#import "OpenUDID.h"
#import <MapKit/MapKit.h>

@interface DSLoginViewController ()<CLLocationManagerDelegate>
{
    DSWebservice * objWebService;
    bool isSignin;
    NSString*objSigninType;
    CLLocationManager       *locationManager;
    NSString *currentLatitude,*currentLongitude;
    NSString *deviceUdid;
}

@end

@implementation DSLoginViewController
@synthesize temp,labelFacebook,labelEmail,labelSignIn,buttonTermsOfUse,buttonPrivacyPolicy,buttonSignIn,buttonForgotPass,buttonCreateAnAcc,labelInstruction,labelCreateAnAcc,buttonHaveAnAcc;

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItem"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItemNormal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItemName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     self.navigationController.navigationBarHidden=YES;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    deviceUdid = [OpenUDID value];
}


- (void)viewDidLoad {
    [super viewDidLoad];   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (IS_IPHONE6 ||IS_IPHONE6_Plus){
     self.layoutConstraintTapBarImageHeight.constant =51;
        self.layoutConstraintStatusBarHeight.constant =25;
        self.layoutConstraintFBlblViewHeight.constant=50;
        self.layoutConstraintTxtFieldViewHeight.constant =142;
        self.layoutConstraintCreateAnACCLabelYPos.constant =22;
        self.layoutConstraintInstructionLabelYPos.constant =12;
        self.layoutConstraintSignInLabelYPos.constant = 19;
        self.layoutConstraintEmailTextFieldlYPos.constant =19;
        self.layoutConstraintPassTextFieldlYPos.constant =3;
        self.layoutConstraintTextFieldCenterLabelYPos.constant =60;
    }
 if ([temp isEqualToString:@"createAnAccount"]){
      self.buttonSignInHeightConstraint.constant =56;
     if (IS_IPHONE6 ||IS_IPHONE6_Plus){
       self.layoutConstraintSignInButtonHeight.constant =65;
         self.layoutConstraintBackButtonHeight.constant =50;

     }
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
     if (IS_IPHONE6 ||IS_IPHONE6_Plus){
     self.layoutConstraintSignInButtonHeight.constant =47;
         self.layoutConstraintBackButtonHeight.constant =49;


     }
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
     [buttonSignIn addTarget:self action:@selector(SignButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }

}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
        locationManager                 = [[CLLocationManager alloc] init];
        locationManager.delegate        = self;
        locationManager.distanceFilter  = kCLLocationAccuracyKilometer;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType    = CLActivityTypeAutomotiveNavigation;
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    
    CLLocation *newLocation = [locations lastObject];
    
    currentLatitude         = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.latitude]];
    
    currentLongitude        = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.longitude]];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:@"currentLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:@"currentLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
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

-(void)SignButtonAction
{
    //isSignin =YES;
    
    objSigninType=@"1";
    if([self.emailTxt.text isEqualToString:@""])
    {
        [self alterMsg:@"Enter valied EmailID"];
    }
    else if ([self.passwordTxt.text isEqualToString:@""])
    {
        [self alterMsg:@"Enter valied EmailID"];
    }
    else
    {
        [self loadloginAPI];

    }
    
}

-(void)loadloginAPI
{
    
    objWebService = [[DSWebservice alloc]init];
    [objWebService getLogin:Login_API
                    type:objSigninType
                   email:self.emailTxt.text
                password:self.passwordTxt.text
               profileId:@""
                     dob:@""
            profileImage:@""
                  gender:@""
                latitude:currentLatitude
               longitude:currentLongitude
                  device:@"iPhone"
                deviceid:deviceUdid
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"GETLOGIN--->>>%@",responseObject);
         
                 HomeViewController * objHomeview = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                 [self.navigationController pushViewController:objHomeview animated:NO];
         
     }
                 failure:^(AFHTTPRequestOperation *operation, id error)
     {
     }];
}

-(void)alterMsg:(NSString*)msgStr
{
    UIAlertView * objalterMsg =[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objalterMsg show];
    
}
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
