//
//  DSProfileTableViewCell.h
//  DoSomething
//
//  Created by Sha on 10/13/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textFieldPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleText;
@property (weak, nonatomic) IBOutlet UILabel *labelDPTitleText;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDPPlaceHolder;
@property (weak, nonatomic) IBOutlet UIButton *buttonPushHobbies;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintViewHeight;

@end
