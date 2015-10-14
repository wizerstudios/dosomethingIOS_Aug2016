//
//  LoginViewController.h
//  DoSomething
//
//  Created by OCSDEV2 on 09/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLoginViewController : UIViewController
@property (nonatomic, retain) NSString *temp;
@property (strong, nonatomic) IBOutlet UILabel *labelFacebook;
@property (strong, nonatomic) IBOutlet UILabel *labelEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelSignIn;
@property (strong, nonatomic) IBOutlet UIButton *buttonTermsOfUse;
@property (strong, nonatomic) IBOutlet UIButton *buttonPrivacyPolicy;
@property (strong, nonatomic) IBOutlet UIButton *buttonSignIn;
@property (strong, nonatomic) IBOutlet UIButton *buttonForgotPass;
@property (strong, nonatomic) IBOutlet UIButton *buttonCreateAnAcc;
@property (strong, nonatomic) IBOutlet UILabel *labelInstruction;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonSignInHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *labelCreateAnAcc;
@property (strong, nonatomic) IBOutlet UIButton *buttonHaveAnAcc;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTapBarImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintStatusBarHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintFBlblViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTxtFieldViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintSignInButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBackButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintFBlblHeight;


@end
