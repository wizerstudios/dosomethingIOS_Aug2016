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

@interface DSProfileTableViewController : UIViewController<UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIActionSheetDelegate>
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
    IBOutlet DSProfileTableViewCell *cellLogout;
    IBOutlet DSProfileTableViewCell *cellDelete;
    
    UIImagePickerController  *imagepickerController;
    NSString *strType,*strProfileID,*strProfileImage,*strGender,*FirstName,*LastName,*strDOB,*strEmail,*strPassword;
    
    IBOutlet UIScrollView *profileImageScroll;
    
    IBOutlet UIPageControl *profileImagePageControl;
    
    UIImageView            *profilePic;
    UIView                 *pgDtView;
    UIImageView            *pageImageView;
    UIImageView            *blkdot;
    NSMutableArray         *ImageArray;
    NSString               *pull;
    
    float xslider;
    NSInteger jslider;
    
    BOOL isTapping;
    NSString *scrolldragging;
    NSMutableArray *infoArray;
    UIImageView *page1,*page2,*page3;
    
}
@property (strong, nonatomic) DVSwitch *switcher;
@property (strong, nonatomic) IBOutlet UITableView *tableviewProfile;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewYPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintDatePickerViewLeadingPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewTraillingPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewBottomPos;

@property (nonatomic, retain) NSMutableArray *placeHolderArray;
@property (strong, nonatomic) NSData *profileData;
@property (nonatomic, strong) NSString *textviewText;
@property (nonatomic,strong)  NSString * FBprofileID;

@property (nonatomic,strong) NSMutableDictionary *userDetailsDict;
@property (nonatomic, retain) NSString *emailAddressToRegister;
@property (nonatomic, retain) NSString *emailPasswordToRegister;

@property (assign) BOOL selectEmail;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIView *topViewCell;

@property (strong, nonatomic) IBOutlet UIScrollView *scrView;
- (IBAction)pageChanged:(id)sender;



@end
