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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CustomAlterview.h"


@interface DSLoginViewController ()<CLLocationManagerDelegate>
{
    DSWebservice            * objWebService;
    bool                      isSignin;
    NSString                * objSigninType;
   
    NSString                * currentLatitude, * currentLongitude;
    NSString                * deviceUdid;
    
    NSMutableDictionary *fbUserDetailsDict;
    NSString *firstName,*lastName,*email,*dob,*gender,*profileID,*profileImage,*password;
    UIImage *fbProfileImage;
    
    
    UIImage *profileImage1;
    UIImage *profileImage2;
    UIImage *profileImage3;
    
    CustomAlterview *objCustomAlterview;

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
     [self CustomAlterview];

    
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
#pragma mark - CustomalterviewMethod

-(void)CustomAlterview
{
    objCustomAlterview = [[CustomAlterview alloc] initWithNibName:@"CustomAlterview" bundle:nil];
    objCustomAlterview.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, CGRectGetWidth(self.view.frame),self.view.frame.size.height);
    [objCustomAlterview.alertBgView setHidden:NO];
    [objCustomAlterview.alertMainBgView setHidden:NO];
    [objCustomAlterview.view setHidden:YES];
    [objCustomAlterview.btnYes setHidden:YES];
    [objCustomAlterview.btnNo setHidden:YES];
    [objCustomAlterview.alertCancelButton setHidden:NO];
    [objCustomAlterview.alertCancelButton addTarget:self action:@selector(alertPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    objCustomAlterview.alertMsgLabel.numberOfLines = 2;
    [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];

    [self.view addSubview:objCustomAlterview.view];
    
}

- (IBAction)alertPressCancel:(id)sender
{
    objCustomAlterview. alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    objCustomAlterview.view .hidden  = YES;
 
}

-(void)showAltermessage:(NSString*)msg
{
    objCustomAlterview.view.hidden =NO;
    objCustomAlterview.alertBgView.hidden = NO;
    objCustomAlterview.alertMainBgView.hidden = NO;
    objCustomAlterview.alertMsgLabel.text = msg;
}

#pragma mark- hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Create and Sign Button Action
-(void)CreateAnAccount
{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    objSigninType=@"1";
    if([NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
       
        
        [self showAltermessage:FILL_DETAILS];
        
        return;
    }
    if([NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        
        [self showAltermessage:EMAIL_REQUIRED];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        
        [self showAltermessage:PASSWORD_REQUIRED];
        
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        if(![NSString validateEmail:self.emailTxt.text]){
            
            [self showAltermessage:INVALID_EMAIL];
            
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
        
        [self checkUserEmail];
    }
   
}
-(void)SignButtonAction
{
    [self.view endEditing:YES];
    //isSignin =YES;
    
    objSigninType=@"1";
    if([NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        
        [self showAltermessage:FILL_DETAILS];

        return;
    }
    if([NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        
        [self showAltermessage:EMAIL_REQUIRED];
       
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && [NSString isEmpty:self.passwordTxt.text]){
        
        
        [self showAltermessage:PASSWORD_REQUIRED];
        return;
    }
    if(![NSString isEmpty:self.emailTxt.text] && ![NSString isEmpty:self.passwordTxt.text]){
        if(![NSString validateEmail:self.emailTxt.text]){
          
            [self showAltermessage:INVALID_EMAIL];
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
        //[self checkUserEmail]
    }
}
#pragma mark - checkuserEmailAPI
- (void)checkUserEmail{
    [COMMON LoadIcon:self.view];
    [objWebService checkUser:CheckUser_API
                       email:email
                        type:objSigninType
                    password:password
                  first_name:firstName
                   last_name:lastName
                         dob:dob
                      gender:gender
                profileImage:profileImage
                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                         NSLog(@"checkuser = %@",responseObject);
                         NSLog(@"checkuser = %@",[[responseObject objectForKey:@"checkuser"]objectForKey:@"status"]);
                         if(([[[responseObject objectForKey:@"checkuser"]objectForKey:@"RegisterType"]  isEqual: @"1"])){
                             if([[[responseObject objectForKey:@"checkuser"]objectForKey:@"status"]  isEqual: @"error"]){
                                 [self showAltermessage:[[responseObject objectForKey:@"checkuser"]objectForKey:@"Message"]];
                                 [COMMON removeLoading];
                             }
                             else {
                                 [self gotoProfileView:email :password:YES];//[self gotoProfileView];
                                 [COMMON removeLoading];
                             }
                         }
                         else {
                             if(([[[responseObject objectForKey:@"checkuser"]objectForKey:@"RegisterType"]  isEqual: @"2"])){
                                 if([[[responseObject objectForKey:@"checkuser"]objectForKey:@"status"]  isEqual: @"success"]){
                                     NSLog(@"checkuser = %@",responseObject);
                                     [self gotoProfileView:profileID];
                                     
                                 }
                                 else{
                                     NSLog(@"checkuser = %@",responseObject);
                                     [self loadloginAPI];
                                 }
                                 
                             }
//                             else{
//                             if([[[responseObject objectForKey:@"checkuser"]objectForKey:@"status"]  isEqual: @"error"]){
//                                // [self loadCreateAPI];
//                                 [self loadRegister];
//                                 NSLog(@"checkuser = %@",responseObject);
//                                 
//                             }
//                             else{
//                                 [self gotoProfileView:profileID];//[self gotoProfileView];
//                                 [COMMON removeLoading];
//                             }
//                             }
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, id error) {
                          NSLog(@"Error = %@",error);

                         [self showAltermessage:@"ERROR"];
                         [COMMON removeLoading];
                         

                     }];
}
#pragma mark - loginByFacebook
-(void)loginByFacebook
{
    objSigninType=@"2";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;
    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {

         } else if (result.isCancelled) {
         } else {
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
                  // before used CreateAPI;
                     [self checkUserEmail];
                 }
                 
                 else{
                    [COMMON LoadIcon:self.view];
                    // [self loadloginAPI];
                     [self checkUserEmail];
                 }

             }];
         }
     }];
}

#pragma mark - gotoProfileView

-(void)gotoProfileView:(NSString *)strEmailId :(NSString *)strPassword :(BOOL)selectMail{
    DSProfileTableViewController *profileVC  = [[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    profileVC.emailAddressToRegister  = strEmailId;
    profileVC.emailPasswordToRegister = strPassword;
    profileVC.selectEmail             = selectMail;
    [self.navigationController pushViewController:profileVC animated:YES];
}
   //----Profile View With FacebookProfileID
-(void)gotoProfileView:(NSString*)FBProfileID{
    DSProfileTableViewController *profileVC  = [[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
    profileVC.userDetailsDict = [fbUserDetailsDict mutableCopy];
    profileVC.FBprofileID=FBProfileID;
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
        
        NSLog(@"responseObjectLogin = %@",responseObject);
        
        NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
        
        loginDict = [responseObject valueForKey:@"signin"];
        
        if([[loginDict valueForKey:@"status"]isEqualToString:@"success"]){
            
            [COMMON setUserDetails:[[loginDict valueForKey:@"userDetails"]objectAtIndex:0]];
             NSLog(@"userdetails = %@",[COMMON getUserDetails]);
            [self gotoHomeView];
            [COMMON removeLoading];
            
        }
        else{
            NSLog(@"responseObject = %@",responseObject);
            [self showAltermessage:[loginDict valueForKey:@"Message"]];
            [COMMON removeLoading];
            
        }
        
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error){
        
         NSLog(@"ERROR = %@",error);
       
        [COMMON removeLoading];
        UIAlertView *errorAlter =[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlter show];
    }];
}

#pragma mark - loadCreateAPI
-(void)loadCreateAPI
{
    NSURL *profileImageFBUrl = [NSURL URLWithString:profileImage];
    NSData *profileImageData = [[NSData alloc] initWithContentsOfURL:profileImageFBUrl];
    profileImage1 = [UIImage imageWithData:profileImageData];
    
   [objWebService postRegister:Register_API
                          type:objSigninType
                    first_name:firstName
                     last_name:lastName
                         email:email
                      password:self.passwordTxt.text
                     profileId:profileID
                           dob:dob
                 profileImage1:profileImage1
                 profileImage2:profileImage2
                 profileImage3:profileImage3
              IntersertHobbies:nil
                         About:@""
                        gender:gender
                      latitude:currentLatitude
                     longitude:currentLongitude
                        device:@"iPhone"
                      deviceid:deviceUdid
                fbprofileImage:@"" 
          notification_message:@"Yes"
          notification_sound  :@"Yes"
        notification_vibration:@"Yes"    
                       success:^(AFHTTPRequestOperation *operation, id responseObject){
                           [COMMON removeLoading];
                    }
                   failure:^(AFHTTPRequestOperation *operation, id error) {
                       [COMMON removeLoading];
                       UIAlertView *errorAlter =[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [errorAlter show];
                   }];
    
}
#pragma mark - loadRegisterNotification
-(void)loadRegister{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadRegisterView:)
                                                 name:@"fbregisterform"
                                               object:nil];
    [self loadCreateAPI];
    
    
}
-(void)loadRegisterView:(NSNotification *)notification{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self gotoHomeView];
    
}

-(void)alterMsg:(NSString*)msgStr
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:msgStr
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - ButtonActions
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createAnAccountFB:(id)sender {
    [self loginByFacebook];
}
@end
