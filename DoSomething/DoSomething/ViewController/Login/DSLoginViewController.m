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
}
@end

@implementation DSLoginViewController
@synthesize temp,labelFacebook,labelEmail,labelSignIn,buttonTermsOfUse,buttonPrivacyPolicy,buttonSignIn,buttonForgotPass,buttonCreateAnAcc,labelInstruction,labelCreateAnAcc,buttonHaveAnAcc,locationManager;




- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    objWebService = [[DSWebservice alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
        [DSAppCommon showSimpleAlertWithMessage:FILL_DETAILS];
        return;
    }
    if([NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        [DSAppCommon showSimpleAlertWithMessage:EMAIL_REQUIRED];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        [DSAppCommon showSimpleAlertWithMessage:PASSWORD_REQUIRED];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        if(![NSString validateEmail:self.emailTxt.text]){
            [DSAppCommon showSimpleAlertWithMessage:INVALID_EMAIL];
            return;
        }
        [self loadCreateAPI];
    }
   
}
#pragma mark - SignButtonAction
-(void)SignButtonAction
{
    //isSignin =YES;
    
    objSigninType=@"1";
    if([NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        [DSAppCommon showSimpleAlertWithMessage:FILL_DETAILS];
        return;
    }
    if([NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        [DSAppCommon showSimpleAlertWithMessage:EMAIL_REQUIRED];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        [DSAppCommon showSimpleAlertWithMessage:PASSWORD_REQUIRED];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        if(![NSString validateEmail:self.emailTxt.text]){
            [DSAppCommon showSimpleAlertWithMessage:INVALID_EMAIL];
            return;
        }
        [self loadloginAPI];
    }
    
}
#pragma mark - loginByFacebook
-(void)loginByFacebook
{
    objSigninType=@"2";
  //  [self alterMsg:@"FaceBook"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions:@[@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
                 NSLog(@"userData = %@",userData);
                 NSLog(@"id = %@",userData[@"id"]);
                 NSString *location = userData[@"location"][@"name"];
                 NSLog(@"location = %@",location);
                 NSString *birthday = userData[@"birthday"];
                 NSLog(@"birthday = %@",birthday);
                 
                 NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]]];
                 NSLog(@"pictureURL = %@",pictureURL);

             }];
         }
     }];
}

//temporary code  (have to check and impletement the username and lastname etc)
#pragma mark Facebook Delegate
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 NSLog(@"accesstoken %@",[NSString stringWithFormat:@"%@",session.accessTokenData]);
                 NSLog(@"user id %@",user.objectID);
                 NSLog(@"Email %@",[user objectForKey:@"email"]);
                 NSLog(@"User Name %@",user.name);
                 NSLog(@"User Name %@",user.first_name);
                 NSLog(@"User Name %@",user.last_name);
                 NSLog(@"user info = %@",user);
                 NSLog(@"birthday = %@",user.birthday);
                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];
                 NSLog(@"string = %@",userImageURL);

//                 NSMutableDictionary *subdic=[[NSMutableDictionary alloc]init];
//                 [subdic setValue:user.objectID  forKey:@"UserId"];
//                 [subdic setValue:[user objectForKey:@"email"] forKey:@"email"];
//                 [subdic setValue:user.first_name forKey:@"first_name"];
//                 [subdic setValue:user.last_name forKey:@"last_name"];
//                 [subdic setValue:user.birthday forKey:@"dob"];
                // [COMMON saveFBDetails:subdic];
                // [self loadloginAPI];
                 
             }
         }];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
    }
    
    // Handle errors
    if (error){
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

#pragma mark - gotoProfileView
-(void)gotoProfileView{
    DSProfileTableViewController *  DSProfileTableView  = [[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    [self.navigationController pushViewController: DSProfileTableView animated:YES];
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
        NSLog(@"Status--->>>%@",[[responseObject objectForKey:@"signin"]objectForKey:@"status"]);
        
        if (responseObject != NULL) {
            [self gotoHomeView];
        }
        else {
            [DSAppCommon showSimpleAlertWithMessage:[[responseObject objectForKey:@"signin"]objectForKey:@"Message"]];
        }
        
//        if ([responseObject objectForKey:@"signin"] != NULL) {
//            [self gotoHomeView];
//        }
//        else if([responseObject objectForKey:@"signin"]!= NULL){
//            [DSAppCommon showSimpleAlertWithMessage:[[responseObject objectForKey:@"signin"]objectForKey:@"Message"]];
//        }
        
    }
                    failure:^(AFHTTPRequestOperation *operation, id error){
                    }];
}

#pragma mark - loadCreateAPI
-(void)loadCreateAPI
{
   [objWebService postRegister:Register_API
                          type:objSigninType
                    first_name:@""
                     last_name:@""
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
        NSLog(@"Register->%@",responseObject);
        [self gotoProfileView];
    }
                       failure:^(AFHTTPRequestOperation *operation, id error) {
                           
                       }];
    
}

-(void)alterMsg:(NSString*)msgStr
{
    UIAlertView * objalterMsg =[[UIAlertView alloc]initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objalterMsg show];
    
}
#pragma mark - BackAction
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
