//
//  CustomAlterview.h
//  DoSomething
//
//  Created by Sha on 11/30/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlterview : UIViewController





@property(nonatomic,strong) IBOutlet UIView *alertBgView;

@property(nonatomic,strong)IBOutlet UILabel *alertMsgLabel;

@property(nonatomic,strong)IBOutlet UIButton *alertCancelButton;

@property(nonatomic,strong)IBOutlet UIButton *btnYes;

@property(nonatomic,strong)IBOutlet UIButton *btnNo;

@property(nonatomic,strong)IBOutlet UIView *alertMainBgView;


- (IBAction)alertPressCancel:(id)sender;
- (IBAction)alertPressYes:(id)sender;
- (IBAction)alertPressNo:(id)sender;

@end
