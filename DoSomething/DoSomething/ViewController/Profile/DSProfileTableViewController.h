//
//  ProfileTableViewController.h
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSProfileTableViewCell.h"
#import "DVSwitch.h"

@interface DSProfileTableViewController : UIViewController<UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
 IBOutlet DSProfileTableViewCell *cellProfileImg;
 IBOutlet DSProfileTableViewCell *cellButton;
 IBOutlet DSProfileTableViewCell *cellAddIcon;
 IBOutlet DSProfileTableViewCell *cellTextField;
 IBOutlet DSProfileTableViewCell *cellDatePicker;
 IBOutlet DSProfileTableViewCell *cellEmailPassword;
 IBOutlet DSProfileTableViewCell *CellSwitchOn;
 IBOutlet DSProfileTableViewCell *CellTermsOfUse;
 IBOutlet DSProfileTableViewCell *cellTextView;
}
@property (strong, nonatomic) DVSwitch *switcher;
@property (strong, nonatomic) IBOutlet UITableView *tableviewProfile;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewYPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintDatePickerViewLeadingPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewTraillingPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewBottomPos;
@property (strong, nonatomic) NSData *profileData;
@property (nonatomic, strong)  NSString *textviewText;

@end
