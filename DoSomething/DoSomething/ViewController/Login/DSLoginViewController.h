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
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *buttonActionLabel;
@property (strong, nonatomic) IBOutlet UIButton *termsOfUseButton;
@property (strong, nonatomic) IBOutlet UIButton *privacyPolicyButton;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotButton;
@property (strong, nonatomic) IBOutlet UIButton *createAnAccButton;
@property (strong, nonatomic) IBOutlet UILabel *instructionLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *signInButtonHeight;
@property (strong, nonatomic) IBOutlet UILabel *createAnAccLabel;

@end
