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
#import "NSString+validations.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface DSLoginViewController ()<CLLocationManagerDelegate>
{
    DSWebservice            * objWebService;
    bool                      isSignin;
    NSString                * objSigninType;
   
    NSString                * currentLatitude, * currentLongitude;
    NSString                * deviceUdid;
    
    NSMutableDictionary *fbUserDetailsDict;
    NSString *firstName,*lastName,*email,*dob,*gender,*profileID,*profileImage,*password;
}
@end

@implementation DSLoginViewController
@synthesize temp,labelFacebook,labelEmail,labelSignIn,buttonTermsOfUse,buttonPrivacyPolicy,buttonSignIn,buttonForgotPass,buttonCreateAnAcc,labelInstruction,labelCreateAnAcc,buttonHaveAnAcc,locationManager;




- (void)viewDidLoad {
    [super viewDidLoad];
    fbUserDetailsDict = [[NSMutableDictionary alloc]init];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    objWebService = [[DSWebservice alloc]init];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self preferredStatusBarStyle];
    
    _emailTxt.autocorrectionType =UITextAutocorrectionTypeNo;
    _passwordTxt.autocorrectionType =UITextAutocorrectionTypeNo;
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
     labelFacebook.attributedText = attStr;
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginByFacebook)];
     [labelFacebook addGestureRecognizer:tap];
     labelFacebook.userInteractionEnabled = YES;
     labelFacebook.tag = 10;
     
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
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginByFacebook)];
     [labelFacebook addGestureRecognizer:tap];
     labelFacebook.userInteractionEnabled = YES;
     labelFacebook.tag = 11;
     

        
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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
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
    [self getUserCurrenLocation];

}
#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
        
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
#pragma mark - CreateButtonAction
-(void)CreateAnAccount
{
    objSigninType=@"1";
    if([NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
       // [DSAppCommon showSimpleAlertWithMessage:FILL_DETAILS];
        [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:FILL_DETAILS preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];

        return;
    }
    if([NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        //[DSAppCommon showSimpleAlertWithMessage:EMAIL_REQUIRED];
        [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:EMAIL_REQUIRED preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        //[DSAppCommon showSimpleAlertWithMessage:PASSWORD_REQUIRED];
        [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:PASSWORD_REQUIRED preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        if(![NSString validateEmail:self.emailTxt.text]){
            //[DSAppCommon showSimpleAlertWithMessage:INVALID_EMAIL];
            [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:INVALID_EMAIL preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
            return;
        }
        email = self.emailTxt.text;
        password=self.passwordTxt.text;
        firstName = @"";
        lastName = @"";
        profileImage = @"";
        profileID = @"";
        gender = @"";
        dob = @"";
        
        [COMMON LoadIcon:self.view];
        //[self loadCreateAPI];
        [self checkUserEmail];
    }
   
}
#pragma mark - SignButtonAction
-(void)SignButtonAction
{
    //isSignin =YES;
    
    objSigninType=@"1";
    if([NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        //[DSAppCommon showSimpleAlertWithMessage:FILL_DETAILS];
         [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:FILL_DETAILS preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        return;
    }
    if([NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        //[DSAppCommon showSimpleAlertWithMessage:EMAIL_REQUIRED];
        [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:EMAIL_REQUIRED preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        //[DSAppCommon showSimpleAlertWithMessage:PASSWORD_REQUIRED];
        [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:PASSWORD_REQUIRED preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        if(![NSString validateEmail:self.emailTxt.text]){
           // [DSAppCommon showSimpleAlertWithMessage:INVALID_EMAIL];
            [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:INVALID_EMAIL preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
            return;
        }
        email = self.emailTxt.text;
        firstName = @"";
        lastName = @"";
        profileImage = @"";
        profileID = @"";
        gender = @"";
        dob = @"";
        
        [COMMON LoadIcon:self.view];
        [self loadloginAPI];
        
        
    }
    
}

#pragma mark - check user Email
- (void)checkUserEmail{
    [objWebService checkUser:CheckUser_API
                       email:email
                        type:objSigninType
                     password: password
                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                         NSLog(@"checkuser = %@",responseObject);
                         NSLog(@"checkuser = %@",[[responseObject objectForKey:@"checkuser"]objectForKey:@"status"]);
                         
                         if([[[responseObject objectForKey:@"checkuser"]objectForKey:@"status"]  isEqual: @"error"]){
                             //[DSAppCommon showSimpleAlertWithMessage:[[responseObject objectForKey:@"checkuser"]objectForKey:@"Message"]];
                             [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:[[responseObject objectForKey:@"checkuser"]objectForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
                             [COMMON removeLoading];
                         }
                         else {
                             [self gotoProfileView:email:password:YES];
                              //[self gotoProfileView];
                             [COMMON removeLoading];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, id error) {
                         
                     }];
    
}


#pragma mark - loginByFacebook
-(void)loginByFacebook
{
    
    objSigninType=@"2";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             NSLog(@"error = %@",error);
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,email,gender,birthday,first_name,last_name"}];
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 // handle response
                 NSDictionary *userData = (NSDictionary *)result;
                 fbUserDetailsDict = [userData mutableCopy];
                 
                 firstName = [userData valueForKey:@"first_name"];
                 lastName = [userData valueForKey:@"last_name"];
                 email = [userData valueForKey:@"email"];
                 profileID = [userData valueForKey:@"id"];
                 gender = [userData valueForKey:@"gender"];
                 profileImage = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
                 dob = @""; //[userData valueForKey:@"birthday"]
                 [fbUserDetailsDict setObject:profileImage forKey:@"profileImage"];
                 NSLog(@"fbUserDetailsDictt = %@",fbUserDetailsDict);
                 
                 [COMMON LoadIcon:self.view];
                 
                 if(labelFacebook.tag == 10)
                 {
                   [self loadCreateAPI];
                    // [self checkUserEmail];
                 }
                 
                 else
                    [self loadloginAPI];

             }];
         }
     }];
}

#pragma mark - gotoProfileView
-(void)gotoProfileView:(NSString *)strEmailId :(NSString *)strPassword :(BOOL)selectEmail{
    DSProfileTableViewController *profileVC  = [[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    profileVC.userDetailsDict = [fbUserDetailsDict mutableCopy];
    profileVC.emailAddressToRegister = strEmailId;
    profileVC.emailPasswordToRegister = strPassword;
    profileVC.selectEmail             =selectEmail;
    [self.navigationController pushViewController:profileVC animated:YES];
}
//-------temp code
#pragma mark - gotoProfileView
-(void)gotoProfileView:(BOOL)selectFB{
    DSProfileTableViewController *profileVC  = [[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    profileVC.userDetailsDict = [fbUserDetailsDict mutableCopy];
    profileVC.selectEmail=selectFB;
    [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - gotoHomeView
-(void)gotoHomeView{
    
    HomeViewController * objHomeview = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:objHomeview animated:NO];
    
}
#pragma mark - loadloginAPI
-(void)loadloginAPI
{
    [objWebService getLogin:Login_API
                       type:objSigninType
                      email:email
                   password:self.passwordTxt.text
                  profileId:profileID
                        dob:dob
               profileImage:profileImage
                     gender:gender
                   latitude:currentLatitude
                  longitude:currentLongitude
                     device:@"iPhone"
                   deviceid:deviceUdid
                    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
        
        loginDict = [responseObject valueForKey:@"signin"];
        
        if([[loginDict valueForKey:@"status"]isEqualToString:@"success"]){
            
            [COMMON setUserDetails:[[loginDict valueForKey:@"userDetails"]objectAtIndex:0]];
             NSLog(@"userdetails = %@",[COMMON getUserDetails]);
            [self gotoHomeView];
            
        }
        else{
            NSLog(@"responseObject = %@",responseObject);
            //[DSAppCommon showSimpleAlertWithMessage:[loginDict valueForKey:@"Message"]];
            [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:[loginDict valueForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        }
        [COMMON removeLoading];
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error){
        [COMMON removeLoading];
    }];
}

#pragma mark - loadCreateAPI
-(void)loadCreateAPI
{
   [objWebService postRegister:Register_API
                          type:objSigninType
                    first_name:firstName
                     last_name:lastName
                         email:email
                      password:self.passwordTxt.text
                     profileId:profileID
                           dob:dob
                  profileImage:profileImage
                        gender:gender
                      latitude:currentLatitude
                     longitude:currentLongitude
                        device:@"iPhone"
                      deviceid:deviceUdid
    
                       success:^(AFHTTPRequestOperation *operation, id responseObject){
                        NSLog(@"responseObject = %@",responseObject);
                           
                           NSMutableDictionary *registerDict = [[NSMutableDictionary alloc]init];
                           
                           registerDict = [responseObject valueForKey:@"register"];
                           
                           if([[registerDict valueForKey:@"status"]isEqualToString:@"success"]){
                               
                              [COMMON setUserDetails:[[registerDict valueForKey:@"userDetails"]objectAtIndex:0]];
                               NSLog(@"userdetails = %@",[COMMON getUserDetails]);
                              [self gotoHomeView];
                               
                           }
                           else{
                               NSLog(@"responseObject = %@",responseObject);
                               NSString *errMsg = [NSString stringWithFormat:@"%@",[registerDict valueForKey:@"Message"]];
                               errMsg = [errMsg stringByReplacingOccurrencesOfString:@"{" withString:@""];
                                errMsg = [errMsg stringByReplacingOccurrencesOfString:@"}" withString:@""];
                               //[DSAppCommon showSimpleAlertWithMessage:errMsg];
                               [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:errMsg preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
                           }
                           [COMMON removeLoading];
                    }
                   failure:^(AFHTTPRequestOperation *operation, id error) {
                       [COMMON removeLoading];
                       
                   }];
    
}

-(void)alterMsg:(NSString*)msgStr
{
//    UIAlertView * objalterMsg =[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [objalterMsg show];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:msgStr
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - BackAction
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
