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
@property (strong, nonatomic) IBOutlet UILabel *termsOfUseLabel;
@property (strong, nonatomic) IBOutlet UILabel *privacyPolicyLabel;
@property (strong, nonatomic) IBOutlet UILabel *signinLabel;

@end
