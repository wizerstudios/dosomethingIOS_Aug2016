//
//  LoginViewController.h
//  DoSomething
//
//  Created by OCSDEV2 on 09/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface DSLoginViewController : UIViewController<CLLocationManagerDelegate>
{
    NSString        *facebookStr;
}
@property (nonatomic, retain) NSString *temp;

@property (strong, nonatomic) IBOutlet UILabel *labelFacebook;

@property (strong, nonatomic) IBOutlet UILabel *labelEmail;

@property (strong, nonatomic) IBOutlet UILabel *labelSignIn;

@property (strong,nonatomic)  IBOutlet UITextField * emailTxt;

@property (strong,nonatomic)  IBOutlet UITextField * passwordTxt;

@property (strong, nonatomic) IBOutlet UIButton *buttonTermsOfUse;

@property (strong, nonatomic) IBOutlet UIButton *buttonPrivacyPolicy;

@property (strong, nonatomic) IBOutlet UIButton *buttonSignIn;

@property (strong, nonatomic) IBOutlet UIButton *buttonForgotPass;

@property (strong, nonatomic) IBOutlet UIButton *buttonCreateAnAcc;

@property (strong, nonatomic) IBOutlet UILabel *labelInstruction;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonSignInHeightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *labelCreateAnAcc;

@property (strong, nonatomic) IBOutlet UIButton *buttonHaveAnAcc;

@property (nonatomic,strong)  CLLocationManager       * locationManager;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTapBarImageHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintStatusBarHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintFBlblViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTxtFieldViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintSignInButtonHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBackButtonHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintFBlblHeight;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintCreateAnACCLabelYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintInstructionLabelYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintSignInLabelYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintEmailTextFieldlYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTextFieldCenterLabelYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintPassTextFieldlYPos;
- (IBAction)createAnAccountFB:(id)sender;
//FORGOT PASSWORD PAGE
- (IBAction)forgotPasswordButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@property (strong, nonatomic) IBOutlet UIView *forgotView;
@property (strong, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (strong, nonatomic) IBOutlet UITextView *forgotInstructionTextView;
@property (strong, nonatomic) IBOutlet UIView *forgotSecondView;
@property (strong, nonatomic) IBOutlet UITextField *forgotTextField;
@property (strong, nonatomic) IBOutlet UIButton *buttonSigInFwd;
- (IBAction)termsOfUseAction:(id)sender;

@end
