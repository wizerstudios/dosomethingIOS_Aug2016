//
//  DSTermsViewController.h
//  DoSomething
//
//  Created by OCS iOS Developer on 18/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSTermsViewController : UIViewController
@property (nonatomic,strong) IBOutlet UIWebView * termscontentweb;
@property (nonatomic,strong) NSString * policytypeofContent;
@property (nonatomic ,strong) IBOutlet NSLayoutConstraint * termtoplblYposition;
@end
