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
   
    //IBOutlet UIView *profileGenderView;
    
    //IBOutlet UILabel *profileGenderLabel;
    
    IBOutlet UILabel *profileGenderValueLabel;
    
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
    NSInteger CurrentImage;
    
}
@property (strong, nonatomic) DVSwitch *switcher;
@property (strong, nonatomic) IBOutlet UITableView *tableviewProfile;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintDatePickerViewLeadingPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewTraillingPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTableViewBottomPos;

@property (nonatomic, retain) NSMutableArray *placeHolderArray;
@property (strong, nonatomic) NSData *profileData,*profileData1,*profileData2,*profileData3;
@property (nonatomic, strong) NSString *textviewText;
@property (nonatomic,strong)  NSString * FBprofileID;

@property (nonatomic,strong) NSMutableDictionary *userDetailsDict;
@property (nonatomic, retain) NSString *emailAddressToRegister;
@property (nonatomic, retain) NSString *emailPasswordToRegister;

@property (assign) BOOL selectEmail;

//@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

//@property (strong, nonatomic) IBOutlet UIScrollView *scrView;
- (IBAction)pageChanged:(id)sender;





@property(nonatomic,strong) IBOutlet UIScrollView * profileMainScrollview;

@property(nonatomic,strong) IBOutlet UIView       *profileImageAddview;

@property(nonatomic,strong) IBOutlet UIView       *nameView;

@property(nonatomic,strong) IBOutlet UIView       *genderalview;

@property(nonatomic,strong) IBOutlet UIView       *datepickerview;

@property(nonatomic,strong) IBOutlet UIView       *aboutview;

@property(nonatomic,strong) IBOutlet UIView       *addinteresthobbiesview;

@property(nonatomic,strong) IBOutlet UIView       *accountview;

@property(nonatomic,strong) IBOutlet UIView       *notificationview;

@property(nonatomic,strong) IBOutlet UIView       *termandprivacyview;

@property(nonatomic,strong) IBOutlet UIView       *profileGenderview;

@property(nonatomic,strong) IBOutlet UILabel     *notificationLbl;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *profileMainviewbottomPosition;

@property (weak, nonatomic) IBOutlet UITextView *textViewAboutYou;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property(nonatomic,strong)IBOutlet UITextField *firstnameTxt;

@property(nonatomic,strong) IBOutlet UITextField *lastNameTxt;

@property (weak, nonatomic) IBOutlet UITextField *DOBTxt;

@property (weak, nonatomic) IBOutlet UISwitch *messSwitchBtn;

@property (weak, nonatomic) IBOutlet UISwitch *SoundSwitchBtn;

@property (weak, nonatomic) IBOutlet UISwitch *vibrationSwitchBtn;

@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (weak, nonatomic) IBOutlet UILabel *labelAboutYou;

@property (weak, nonatomic) IBOutlet UILabel *labelMale;

@property (weak, nonatomic) IBOutlet UILabel *labelFemale;

@property (weak, nonatomic) IBOutlet UIButton *termsOfUse;

@property (weak, nonatomic) IBOutlet UIButton *privacyPolicy;

@property(nonatomic,strong) IBOutlet UILabel *profilegenderLbl;

@property (weak, nonatomic) IBOutlet UIButton *buttonPushHobbies;

@property (weak, nonatomic) IBOutlet UIImageView *plusIconImageView;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageview;

@property (strong, nonatomic) IBOutlet UIScrollView *scrView;
@property (strong, nonatomic) IBOutlet UIButton *cameraActionButton;

@property (strong, nonatomic) IBOutlet UIView *topViewCell;


@end
