
//  ProfileTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//
#define pageWidth           380
#import "DSProfileTableViewController.h"
#import "DSInterestAndHobbiesViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "HomeViewController.h"
#import "DSAppCommon.h"
#import "DSWebservice.h"
#import "OpenUDID.h"
#import <MapKit/MapKit.h>
#import "NSString+validations.h"

#import "NSString+validations.h"
#import "UIImageView+AFNetworking.h"

#import "CustomAlterview.h"

@interface DSProfileTableViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    DSWebservice            * objWebService;
    CLLocationManager       *locationManager;
    NSString                *currentLatitude,*currentLongitude;
    NSMutableArray          *imageNormalArray,*hobbiesNameArray,*hobbiesCategoryIDArray;
    NSArray                 *titleArray;
    NSMutableArray          *interstAndHobbiesArray;
    UIDatePicker            *datePicker;
    UITextField             *currentTextfield;
    UILabel                 *maleLabel;
    UILabel                 *femaleLabel;
    
    float commonWidth, commonHeight;
    float yAxis;
    float imageSize;
    float space;
    
    UIImage *profileImage;
    NSString *strProfileImage2;
    NSString *strProfileImage3;
    
    DSProfileTableViewCell *cell;
    
    NSString * deviceUdid;
    NSString * selectGender;
    NSString * strFirstName;
    NSString * strLastName,*strAbout;
    
    NSString * isNotification_message;
    NSString * isNotification_sound;
    NSString * isNotification_vibration;
    NSMutableArray *BGimageArray;
    NSMutableArray *FGimageArray;
    UIButton *pageControllBtn;
    UIImageView *foregroundView;
     UIView * mainview;
    UIImageView * objImag;
    NSInteger Currentindex;
    NSString *strInterestHobbies;
    
    BOOL isSetProfileimage;
    
    NSString *loginUserSessionID;
    NSString *optionLogoutDelete;
    NSString *dateChange;
    
    /* Profile Image */
    UIImageView *userProfileImage;
    UIImageView *cameraImage;
    
    NSMutableArray *profileDataArray;
    
    UIImage *profileImage1;
    UIImage *profileImage2;
    UIImage *profileImage3;
    NSMutableDictionary *profileDict;
    NSMutableArray *profileImageArray;

    CGSize dataSize;
    BOOL isLogin;
    CustomAlterview *objCustomAlterview;
    

}

@end

@implementation DSProfileTableViewController
@synthesize  profileData1, profileData2,profileData3,textviewText, placeHolderArray,FBprofileID;
@synthesize userDetailsDict,emailAddressToRegister,emailPasswordToRegister,selectEmail,topViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    objWebService = [[DSWebservice alloc]init];
    [self initializeArray];
    [self getUserCurrenLocation];
    deviceUdid = [OpenUDID value];
    
    profileDict=[[NSMutableDictionary alloc]init];
    profileDict =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString * strsessionID =[profileDict valueForKey:@"SessionId"];
    loginUserSessionID = strsessionID;
    if(profileDict == NULL)
    {
        [self initializeArray];
    
    }
    else{
        
        [self initializeArrayProfile];
        
    //self.tableViewHeightConstraint.constant=568;
    }
        NSLog(@"DICT%@",profileDict);
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItemCategoryID"];
    isNotification_message = @"Yes";
    isNotification_vibration = @"Yes";
    isNotification_sound = @"Yes";
    
    
    if(profileDict != NULL){
        if([[profileDict valueForKey:@"image1"] isEqual:@""]&&[[profileDict valueForKey:@"image2"] isEqual:@""] && [[profileDict valueForKey:@"image3"] isEqual:@""]){
            profileDataArray = [NSMutableArray new];
            
            
            for(int i = 0; i < 3; i++)
            {
                NSData *data = [NSData new];
                [profileDataArray addObject:data];
            }
        }
        
        
        else{
            NSString *ImageURL1 , *ImageURL2, *ImageURL3 ;
            NSData *imageData1, *imageData2, *imageData3;
            if([[profileDict valueForKey:@"image1"] isEqual:@""]){
                imageData1 = [profileDict valueForKey:@"image1"];
            }
            else{
                ImageURL1 = [profileDict valueForKey:@"image1"];
                imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL1]];
            }
            if([[profileDict valueForKey:@"image2"] isEqual:@""]){
                imageData2 = [profileDict valueForKey:@"image2"];
            }
            else{
                ImageURL2 = [profileDict valueForKey:@"image2"];
                imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL2]];
            }

            if([[profileDict valueForKey:@"image3"] isEqual:@""]){
                imageData3 = [profileDict valueForKey:@"image3"];
            }
            else{
                ImageURL3 = [profileDict valueForKey:@"image3"];
                imageData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL3]];
            }
            
            profileDataArray = [[NSMutableArray alloc]initWithObjects:imageData1,imageData2,imageData3, nil];
        }

    }
    else{
        if(userDetailsDict.count > 0){
            
            NSString  *ImageURL1 ,*ImageURL2 ,*ImageURL3 ;
            NSData *imageData1, *imageData2, *imageData3;
            if([[userDetailsDict valueForKey:@"profileImage"] isEqual:@""]){
                imageData1 = [userDetailsDict valueForKey:@"profileImage"];
            }
            else{
                ImageURL1 = [userDetailsDict valueForKey:@"profileImage"];
                imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL1]];
            }
            ImageURL2 = @"";
            imageData2 = [ImageURL2 dataUsingEncoding:NSUTF8StringEncoding];
            ImageURL3 = @"";
            imageData3 = [ImageURL3 dataUsingEncoding:NSUTF8StringEncoding];
                        
            profileDataArray = [[NSMutableArray alloc]initWithObjects:imageData1,imageData2,imageData3, nil];

        }
        else{
           profileDataArray = [NSMutableArray new];

    
            for(int i = 0; i < 3; i++)
            {
                NSData *data = [NSData new];
                [profileDataArray addObject:data];
            }
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
        self.layoutConstraintTableViewYPos.constant= 20;
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        self.layoutConstraintTableViewYPos.constant= 20;
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [customNavigation.saveBtn setHidden:NO];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    imageNormalArray =[[NSMutableArray alloc]init];
    
    if([profileDict valueForKey:@"hobbieslist"]!=NULL)
    {
        if(isLogin == YES){
            interstAndHobbiesArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"]mutableCopy];
            
            imageNormalArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
            
            hobbiesNameArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"]mutableCopy];
            
            hobbiesCategoryIDArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemCategoryID"]mutableCopy];
            
            
            strInterestHobbies = [hobbiesCategoryIDArray componentsJoinedByString:@","];
        }
        else{
        interstAndHobbiesArray = [[profileDict valueForKey:@"hobbieslist"]mutableCopy];
        hobbiesNameArray       =[[interstAndHobbiesArray valueForKey:@"name"]mutableCopy];
        imageNormalArray     = [[interstAndHobbiesArray valueForKey:@"image"]mutableCopy];
        isLogin = YES;
    }
    }
    
    else
    {
    interstAndHobbiesArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"]mutableCopy];
    
    imageNormalArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
    
    hobbiesNameArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"]mutableCopy];
    
    hobbiesCategoryIDArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemCategoryID"]mutableCopy];

    
    strInterestHobbies = [hobbiesCategoryIDArray componentsJoinedByString:@","];
    }
    
    NSLog(@"joinedString:%@",strInterestHobbies);
    
    [_tableviewProfile reloadData];
    
    infoArray=[[NSMutableArray alloc]initWithObjects:@"profile_noimg",@"profile_noimg",@"profile_noimg", nil];
    [self CustomAlterview];

}

#pragma mark - scroll

-(void)profileScroll{
    
    self.scrView.pagingEnabled=YES;
    self.scrView.delegate=self;
    
    int spacing = 20;
    for(int i = 0; i < 3; i++)
    {
    
            NSData *profileData = [profileDataArray objectAtIndex:i];
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
            [userProfileImage setTag:i+100];
            if([profileData length] == 0)
                [userProfileImage setImage:[UIImage imageNamed:@"profile_noimg"]];
        
        
            
            else{
                [userProfileImage setImage:[UIImage imageWithData:profileData]];
                [cell.cameraButton setHidden:YES];
            }
            
            userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height / 2;
            userProfileImage.layer.masksToBounds = YES;
            [userProfileImage setUserInteractionEnabled:YES];
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCamera:)];
            [singleTap setNumberOfTapsRequired:1];
            [userProfileImage addGestureRecognizer:singleTap];
            [self.scrView addSubview:userProfileImage];
            
            cameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(userProfileImage.frame.size.width / 2 - 15, self.scrView.frame.size.height - 55, 30, 30)];
            [cameraImage setTag:i+200];
            [cameraImage setImage:[UIImage imageNamed:@"profile_camera_icon"]];
        [topViewCell setHidden:YES];
            cameraImage.userInteractionEnabled = YES;
            
            [cameraImage setUserInteractionEnabled:YES];
            [userProfileImage addSubview:cameraImage];

        
    }
    
    self.scrView.contentSize=CGSizeMake(self.scrView.frame.size.width*3, self.scrView.frame.size.height);
    
    if(CurrentImage == 0)
        [self.scrView setContentOffset:CGPointMake(0, 0)animated:NO];
    else if(CurrentImage == 1)
        [self.scrView setContentOffset:CGPointMake(1.5*self.profileImageView.frame.size.width - 15, 0)animated:NO];
    else if(CurrentImage == 2)
        [self.scrView setContentOffset:CGPointMake((3*self.profileImageView.frame.size.width - 15), 0)animated:NO];
    
    
    xslider=0;
    pgDtView=[[UIView alloc]init];
    pgDtView.backgroundColor=[UIColor clearColor];
    pageImageView =[[UIImageView alloc]init];
    profileImagePageControl.numberOfPages=infoArray.count;
    
    for(int i=0;i<profileImagePageControl.numberOfPages;i++)
    {
        blkdot=[[UIImageView alloc]init];
        [blkdot setFrame:CGRectMake(i*17, 0, 7, 7 )];
        [blkdot setImage:[UIImage imageNamed:@"dot_normal"]];
        [pgDtView addSubview:blkdot];
        [pageImageView setFrame:CGRectMake(0, 0, 7, 7)];
        [pageImageView setImage:[UIImage imageNamed:@"dot_active_gray"]];
        [pgDtView addSubview:pageImageView];
        [topViewCell addSubview:pgDtView];
        [pgDtView setFrame:CGRectMake(15, -5, profileImagePageControl.numberOfPages*17, 10)];
        
    }

}

- (IBAction)pageChanged:(id)sender {
    NSLog(@"current page = %ld",(long)profileImagePageControl.currentPage);
    
    CGFloat x = profileImagePageControl.currentPage * self.scrView.frame.size.width;
    [self.scrView setContentOffset:CGPointMake(x, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CurrentImage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (scrollView==self.scrView) {    }
    pull=@"";
    jslider = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.scrView setNeedsDisplay];
    profileImagePageControl.currentPage=jslider;
    [pageImageView setFrame:CGRectMake(jslider*17, 0, 7, 7)];
    
    isTapping=NO;
    scrolldragging=@"YES";
}

- (NSString *) getEmail {
    
    if (emailAddressToRegister == NULL) {
        emailAddressToRegister = @"";
    }
    NSString *emailAddress = emailAddressToRegister;
    NSLog(@"email = %@",emailAddress);
    return emailAddress;
}
- (NSString *) getPassword {
    
    if (emailPasswordToRegister == NULL) {
        emailPasswordToRegister = @"";
    }
    NSString *emailPassword = emailPasswordToRegister;
    NSLog(@"email = %@",emailPassword);
    return emailPassword;
}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
        locationManager                 = [[CLLocationManager alloc] init];
        locationManager.delegate        = self;
        locationManager.distanceFilter  = kCLLocationAccuracyKilometer;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType    = CLActivityTypeAutomotiveNavigation;
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    CLLocation *newLocation = [locations lastObject];
    
    currentLatitude         = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.latitude]];
    
    currentLongitude        = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.longitude]];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:@"currentLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:@"currentLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}


-(void)loadDatePicker:(NSInteger)_tag{
    currentTextfield=(UITextField *)[self.view viewWithTag:_tag];
    datePicker   = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 320, 150)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(DateSelectionAction:) forControlEvents:UIControlEventValueChanged];
    datePicker.tag =_tag;
    [currentTextfield setInputView:datePicker];
    currentTextfield.tintColor=[UIColor clearColor];
}


- (void)DateSelectionAction:(UIDatePicker *)sender
{
    currentTextfield=(UITextField *)[self.view viewWithTag:[sender tag]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString =  [dateFormat stringFromDate:sender.date];
    currentTextfield.text = dateString;

    
}

#pragma mark - textfiled delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strSearchLetters;
    if (string.length !=0)
    {
        if(textField.text.length > 1)
        {
            strSearchLetters =[textField.text stringByAppendingString:string];
            if(textField.tag ==11)
            {
                FirstName =strSearchLetters;
            }
            else if (textField.tag == 12)
            {
                LastName =strSearchLetters;
            }

        }
        
    }

        return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField.tag == 11) {
       
    }
    else if (textField.tag ==12)
    {
        
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSInteger tag = [textField tag];
    if(textField.tag >= 1000){
        [self loadDatePicker:tag];
    }
        return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    id textFieldSuper = textField;
    textField.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
    
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        
        textFieldSuper = [textFieldSuper superview];
        
    }
    NSIndexPath *indexPath ;
    
    //DSProfileTableViewCell *cell;
    
    indexPath = [self.tableviewProfile indexPathForCell:(DSProfileTableViewCell *)textFieldSuper];
    
    cell = (DSProfileTableViewCell *) [self.tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    NSLog(@"row = %ld section = %ld",(long)indexPath.row,(long)indexPath.section);
    
   NSString *selOptionVal;
//    if (indexPath.row ==1 ||indexPath.row ==5) {
//        //selOptionVal = cell.textFieldPlaceHolder.text;
//        
//        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
//            [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
//            
//        }
//    }
    
    
    if (indexPath.row ==4 ) {
       // selOptionVal = cell.textFieldDPPlaceHolder.text;
       
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        selOptionVal = [formatter stringFromDate:date];
       
        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
            //[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
            currentTextfield.text =selOptionVal;
        }
        
        
    }
    
    else if (indexPath.row ==7 ) {
        if ((selOptionVal = cell.emailTextField.text)) {
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
                emailAddressToRegister=cell.emailTextField.text;
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
                
            }
            
        }
        selOptionVal = cell.passwordTextField.text;
        emailPasswordToRegister=cell.passwordTextField.text;
        
        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
            [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingTextPass"];
        }
        
    }
    
    NSLog(@"personalArray =%@", placeHolderArray);
    
    [cell.textFieldPlaceHolder   resignFirstResponder];
    
    [textField resignFirstResponder];
    
}



-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToHobbiesView {
    
    DSInterestAndHobbiesViewController * DSHobbiesView  = [[DSInterestAndHobbiesViewController alloc]initWithNibName:@"DSInterestAndHobbiesViewController" bundle:nil];
    DSHobbiesView.profileDetailsArray = placeHolderArray;
    [self.navigationController pushViewController:DSHobbiesView animated:YES];

}

-(void)initializeArray{
    
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];
    
   // NSMutableDictionary *detailsDict = [[NSMutableDictionary alloc]init];
   // detailsDict = [[COMMON getUserDetails]mutableCopy];

    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder",@"",@"TypingText", nil],
                                    
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"first_name"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"last_name"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"gender"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"DD/MM/YYYY",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Write something about yourself here.",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"email"],@"placeHolder",@"Password",@"placeHolderPass",@"",@"TypingText",@"",@"TypingTextPass", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"switch_on",@"placeHolder",@"",@"NewMessageImage",@"",@"SoundImage",@"",@"VibrationImage",nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"TermsOfUse",@"placeHolder",@"",@"TypingText", nil], nil]atIndex:0];
    
    titleArray = [[NSArray alloc]initWithObjects:@"Image",@"First Name",@"Last Name",@"male",@"Date of Birth",@"About You",@"Hobbies",@"Email&Password",@"switch_on",@"TermsOfUse",nil];
    
    NSLog(@"PlaceHolder %@",placeHolderArray);
    //[self.tableviewProfile reloadData];
   
}
-(void)initializeArrayProfile{
    
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];
    
    // NSMutableDictionary *detailsDict = [[NSMutableDictionary alloc]init];
    // detailsDict = [[COMMON getUserDetails]mutableCopy];
    
    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder",@"",@"TypingText", nil],
                                    
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"first_name"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"last_name"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"gender"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"date_of_birth"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Write something about yourself here.",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"email"],@"placeHolder",@"Password",@"placeHolderPass",@"",@"TypingText",@"",@"TypingTextPass", nil], nil]atIndex:0];
    
    titleArray = [[NSArray alloc]initWithObjects:@"Image",@"First Name",@"Last Name",@"male",@"Date of Birth",@"About You",@"Hobbies",@"Email&Password",@"switch_on",@"TermsOfUse",nil];
    
    NSLog(@"PlaceHolder %@",placeHolderArray);
    //[self.tableviewProfile reloadData];
    
}

#pragma mark - CustomalterviewMethod

-(void)CustomAlterview
{
    objCustomAlterview = [[CustomAlterview alloc] initWithNibName:@"CustomAlterview" bundle:nil];
    objCustomAlterview.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, CGRectGetWidth(self.view.frame),self.view.frame.size.height);
    [objCustomAlterview.alertBgView setHidden:YES];
    [objCustomAlterview.alertMainBgView setHidden:YES];
    [objCustomAlterview.view setHidden:YES];
    [objCustomAlterview.btnYes setHidden:YES];
    [objCustomAlterview.btnNo setHidden:YES];
    [objCustomAlterview.alertCancelButton setHidden:NO];
    [objCustomAlterview.alertCancelButton addTarget:self action:@selector(alertPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:objCustomAlterview.view];
}

- (IBAction)alertPressCancel:(id)sender {
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        objCustomAlterview.alertBgView.alpha = 0;
//        
//        objCustomAlterview.alertMainBgView.alpha = 0;
//        
//    } completion:^(BOOL b){
    
        
        objCustomAlterview. alertBgView.hidden = YES;
        
        objCustomAlterview.alertMainBgView.hidden = YES;
        objCustomAlterview.view .hidden  = YES;
    //}];
}

-(void)showAltermessage:(NSString*)msg
{
    objCustomAlterview.view.hidden =NO;
    //objCustomAlterview.view.alpha=0.0;
    objCustomAlterview.alertBgView.hidden = NO;
    objCustomAlterview.alertMainBgView.hidden = NO;
    objCustomAlterview.alertCancelButton.hidden = NO;
    objCustomAlterview.btnYes.hidden = YES;
    objCustomAlterview.btnNo.hidden = YES;
    
    objCustomAlterview.alertMsgLabel.text = msg;
    objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    objCustomAlterview.alertMsgLabel.numberOfLines = 2;
    [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];
    
}



#pragma mark - TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [placeHolderArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
         return [placeHolderArray[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (IS_IPHONE4 ||IS_IPHONE5)
    {
           if (indexPath.row == 0 ){
               return 200;
            }
        if(indexPath.row ==1)
        {
            return 80;
        }
        if(indexPath.row ==2)
        {
            return 0;
        }
        if(indexPath.row ==3)
        {
            return 40;
        }
            if(indexPath.row == 5)
             {
                 dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(tableView.frame.size.width-20,tableView.frame.size.height)];
                 
                 return dataSize.height+10;
                 
             }
            if (indexPath.row == 4) {
            return 55;
            }
            if ( indexPath.row ==6)
            {
            if([imageNormalArray count] < 1)
                return 70;
            else if([imageNormalArray count] <= 5)
                return commonHeight + 46;
            else if([imageNormalArray count] <= 10)
                return (commonHeight*2)+46;
            else if([imageNormalArray count] <= 15)
                return (commonHeight * 3)+48;
            else if([imageNormalArray count] <= 20)
                return (commonHeight * 4)+52;
            }

       
            if ( indexPath.row == 7) {
            
                return 120;
            }
            if (indexPath.row ==8) {
                return 150;
            }

        
            if (indexPath.row == 9) {
                return 80;
            }


    return 40;
    }
            if (indexPath.row == 0 )
            {
                return 258;
             }
    
  
            if (indexPath.row == 4)
            {
                return 70;
            }
           if(indexPath.row == 5)
           {
               dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(tableView.frame.size.width-20,tableView.frame.size.height)];
               
               return dataSize.height;
             }
            if ( indexPath.row ==6)
            {
            if([imageNormalArray count] < 1)
                return 80;
            else if([imageNormalArray count] <= 5)
                return commonHeight + 46;
            else if([imageNormalArray count] <= 10)
                return (commonHeight*2)+46;
            else if([imageNormalArray count] <= 15)
                return (commonHeight * 3)+57;
            else if([imageNormalArray count] <= 20)
                return (commonHeight * 4)+70;
            }
    
            if(indexPath.row ==8)
            {
                return 150;
            }
    
            if ( indexPath.row == 7) {
                return 160;
            }
    
            if (indexPath.row == 9) {
                return 98;
            }
        return 50;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    cell = (DSProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *titleText;
    NSString *placeHolderText,*placeHolderTextPass;
   NSString *typingText,*typingTextPass;
   
    

//        typingText       = [[[placeHolderArray valueForKey:@"TypingText" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        typingTextPass   = [[[placeHolderArray valueForKey:@"TypingTextPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//    
//
//        placeHolderText     =  [[[placeHolderArray valueForKey:@"placeHolder" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        placeHolderTextPass =  [[[placeHolderArray valueForKey:@"placeHolderPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    
   


    
       // titleText       =  [titleArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellProfileImg;
        }
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintProfileImageHeight.constant =159;
            cell.layoutConstraintProfileImageWidth.constant =161;
        }
        [self profileScroll];
    

        
        if(!profileData1)
            [profileImagePageControl setHidden:YES];
        else
            [profileImagePageControl setHidden:NO];
        
        [cell.cameraButton setTag:101];
        [cell.cameraButton addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        
        userProfileImage.layer.masksToBounds = YES;
        
    }

    
    if (indexPath.row == 1 )
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellTextField;
            
        }
        
        
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintViewHeight.constant =49;

        }
//        cell.labelTitleText.text = titleText;
//        if(typingText == (id)[NSNull null] || [typingText isEqualToString:@""])//|| [typingText  isEqual: @"NULL"])
//        {
//            if(placeHolderText ==(id) [NSNull null])
//                cell.textFieldPlaceHolder.placeholder = titleText;
//            else
                if(profileDict !=NULL){
                    [cell.textFieldPlaceHolder setEnabled:NO];
                   // cell.textFieldPlaceHolder.text = placeHolderText;
                    cell.firstnameTxt.text =[profileDict valueForKey:@"first_name"];
                    cell.lastNameTxt.text  =[profileDict valueForKey:@"last_name"];
                }
           else
               cell.firstnameTxt.text = FirstName;
              cell.lastNameTxt.text   =LastName;
//        }
//
//        else
//           cell.textFieldPlaceHolder.text = typingText;
    }
    
    if(indexPath.row ==2)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellTextField;
           
            
        }
         cellTextField.hidden =YES;
//        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
//        {
//            cell.layoutConstraintViewHeight.constant =49;
//            
//        }
//        cell.labelTitleText.text = titleText;
//        if(typingText == (id)[NSNull null] || [typingText isEqualToString:@""])//|| [typingText  isEqual: @"NULL"])
//        {
//            if(placeHolderText ==(id) [NSNull null])
//                cell.textFieldPlaceHolder.placeholder = titleText;
//            else
//                if(profileDict !=NULL){
//                    [cell.textFieldPlaceHolder setEnabled:NO];
//                    cell.textFieldPlaceHolder.text = placeHolderText;
//                }
//                else
//                    cell.textFieldPlaceHolder.text = placeHolderText;
//        }
//        
//        else
//            cell.textFieldPlaceHolder.text = typingText;
    }
    if (indexPath.row == 3)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self  options:nil];
            cell = cellButton;
            
        }
        
        int labelWidth = 0,labelHeight = 0;
        
        if(IS_IPHONE5){
            
            labelWidth =50;
            labelHeight=14;
            
            
        }
        if(IS_IPHONE6){
            labelWidth =75;
            labelHeight=25;
            
        }
        if(IS_IPHONE6_Plus)
        {
            
            labelWidth =94;
            labelHeight=25;
            
        }
        
        [cell.maleButton setTag:2004];
        [cell.femaleButton setTag:2005];
        
        maleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelWidth,labelHeight)];
        maleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:9.0];
        maleLabel.textAlignment = NSTextAlignmentCenter;
        [maleLabel setText:@"Male"];
        [cell.labelMale addSubview:maleLabel];
        
        femaleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,labelWidth, labelHeight)];
        femaleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:9.0];
        femaleLabel.textAlignment = NSTextAlignmentCenter;
        [femaleLabel setText:@"Female"];
        [cell.labelFemale addSubview:femaleLabel];
        
        if( profileDict !=NULL){
            
            profileGenderValueLabel.text =[profileDict valueForKey:@"gender"];
            
        }
        else{
            [profileGenderView setHidden:YES];
            [profileGenderLabel setHidden:YES];
            [profileGenderValueLabel setHidden:YES];
//            if(placeHolderText == (id)[NSNull null]){
            
            femaleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
            maleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
            //}
//            else{
////                if([placeHolderText isEqualToString:@"Male"])
////                {
//                femaleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
//                maleLabel.textColor = [UIColor redColor];
//                }
//                else if([placeHolderText isEqualToString:@"female"])
//                {
//                maleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
//                femaleLabel.textColor = [UIColor redColor];
//                }
//            }
        }
        
        
        cell.maleButton.userInteractionEnabled = YES;
        cell.femaleButton.userInteractionEnabled = YES;
        [cell.maleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.femaleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }


    if (indexPath.row == 4)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellDatePicker;
            
        }
        
        if(profileDict != NULL)
        {
            cell.textFieldDPPlaceHolder.text =[profileDict valueForKey:@"date_of_birth"];
        }
        else
        {
        if([currentTextfield.text isEqualToString:@""] || currentTextfield.text == nil)
            cell.textFieldDPPlaceHolder.text = placeHolderText;
        else
            cell.textFieldDPPlaceHolder.text = currentTextfield.text;
       
        }
           // cell.labelDPTitleText.text = titleText;
            [cell.textFieldDPPlaceHolder setTag:1000];

        
        
    }
    if (indexPath.row == 5)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellTextView;
            
        }
        
        
        if(profileDict !=NULL){
        
            
                if([[profileDict valueForKey:@"about"] isEqual:@""]){
                    if(textviewText == nil)
                        cell.textViewHeaderLabel.hidden = NO;
                    else
                        cell.textViewHeaderLabel.hidden = YES;
                    
                    cell.textViewAboutYou.text = textviewText;
                    //cell.labelAboutYou.text =titleText;
                    strAbout =cell.textViewAboutYou.text;
                    //cell.textViewHeaderLabel.text =placeHolderText;
                    cell.textViewAboutYou.delegate = self;
                }
                else{
                    cell.textViewAboutYou.text = [[profileDict valueForKey:@"about"]mutableCopy];
                    strAbout =cell.textViewAboutYou.text;
                    cell.textViewHeaderLabel.hidden = YES;
                    //cell.textViewHeaderLabel.text =placeHolderText;
                    //cell.labelAboutYou.text =titleText;
                    cell.textViewAboutYou.delegate = self;
                }
                
                        }
        else{
            if(textviewText == nil)
                cell.textViewHeaderLabel.hidden = NO;
            else
                cell.textViewHeaderLabel.hidden = YES;
                
                cell.textViewAboutYou.text = textviewText;
               // cell.labelAboutYou.text =titleText;
                strAbout =cell.textViewAboutYou.text;
               // cell.textViewHeaderLabel.text =placeHolderText;
                cell.textViewAboutYou.delegate = self;
        }
        
        
    }
    
    if(indexPath.row == 6)
    {
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellAddIcon;
            [cell.buttonPushHobbies addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        yAxis = 31;
        if(profileDict ==NULL)
        {
       
        }
        else
        {
            imageSize =39;
            commonWidth=19.5;
            
        }
        space = imageSize / 2;
        commonHeight = imageSize+15;
        
        NSString *plusIcon = @"Plus_icon.png";
        if ([imageNormalArray count] >=1)
        {
            for(NSString *strPlus in imageNormalArray)
            {
                if([strPlus isEqualToString:@"Plus_icon.png"])
                    [imageNormalArray removeObject:strPlus];
            }
            [imageNormalArray addObject:plusIcon];
        }
        
        UIButton *pushToHobbiesButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
        for (int i =0; i< [imageNormalArray  count]; i++) {
            cell.plusIconImageView.hidden = YES;
            UIImageView *hobbiesImage;
            
            if(i <= 4)
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+ 10, yAxis, imageSize, imageSize)];
            else if(i <= 9)
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+ 10, yAxis+imageSize+space, imageSize, imageSize)];
            else if(i <= 14)
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+ 10, yAxis+((imageSize+space) * 2), imageSize, imageSize)];
            else
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+ 10, yAxis+((imageSize+space) * 3), imageSize, imageSize)];
            NSString *image =[imageNormalArray objectAtIndex:i];
           //[imageNormalArray lastObject];
           // NSLog(@"lastObject:%@",[imageNormalArray lastObject]);
            if([image isEqualToString:@"Plus_icon.png"])
            {
                [hobbiesImage setImage:[UIImage imageNamed:image]];
            }
            else
            {
               image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
               [hobbiesImage setImageWithURL:[NSURL URLWithString:image]];
            }
            
            if (image == plusIcon) {
                hobbiesImage.userInteractionEnabled = YES;
                pushToHobbiesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [hobbiesImage addSubview:pushToHobbiesButton];
            }
            
            [cell addSubview:hobbiesImage];
            [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        for (int i =0; i< [hobbiesNameArray  count]; i++) {
            
            NSString *image =[hobbiesNameArray objectAtIndex:i];
            UILabel *hobbiesname;
            
            if(i <= 4)
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize)), yAxis + imageSize, imageSize + 20, 15)];
            else if(i <= 9)
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize)), yAxis+(imageSize * 2)+space, imageSize + 20, 15)];
            else if(i <= 14)
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize)), yAxis+((imageSize+space) * 2)+imageSize, imageSize + 20, 15)];
            else
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize)), yAxis+((imageSize+space) * 3)+imageSize, imageSize + 20, 15)];
            
            [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255 green:(float)102.0/255 blue:(float)102.0/255 alpha:1.0f];
            
            
            hobbiesname.text = image;
            [cell addSubview:hobbiesname];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    if (indexPath.row == 7)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellEmailPassword;
            
        }
        
        if(profileDict != NULL)
        {
            cell.emailTextField.text = [profileDict valueForKey:@"email"];
            //cell.passwordTextField.text =[self getPassword];

        }
      else
      {
          cell.emailTextField.text = [self getEmail];
          cell.passwordTextField.text =[self getPassword];

      }
            //if(placeHolderText ==(id) [NSNull null])
          //            else
//                if(profileDict !=NULL){
//                    [cell.emailTextField setEnabled:NO];
//                    cell.emailTextField.text = placeHolderText;
//                }
//                else
//
//                cell.emailTextField.text = placeHolderText;
     
        
        
//        else if (typingText!=nil)
//        {
//            cell.emailTextField.text=typingText;
//        }
//        if(typingTextPass == (id)[NSNull null] || [typingTextPass isEqualToString:@""]  || typingTextPass == nil)//|| [typingText  isEqual: @"NULL"])
//        {
//            if(placeHolderText ==(id) [NSNull null])
        
//            else
//                cell.passwordTextField.text =@"";
//            
//        }
//        else if (typingTextPass != nil)
//        {
//            cell.passwordTextField.text=typingTextPass;
//        }
    
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        cell.layoutConstraintAccLabelYPos.constant =42;
        cell.layoutConstraintEmailPassViewHeight.constant =50;
        }
    }
    if (indexPath.row == 8)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellSwitchOn;
            
        }
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
            cell.layoutConstraintNotificationLabelYPos.constant = 40;
            cell.layoutConstraintNotificationViewHeight.constant=51;
            cell.layoutConstraintRadioButtonYPos.constant = 18;
        }
        
        cell.messSwitchBtn.transform = CGAffineTransformMakeScale(0.50, 0.50);
        cell.SoundSwitchBtn.transform = CGAffineTransformMakeScale(0.50, 0.50);
        cell.vibrationSwitchBtn.transform = CGAffineTransformMakeScale(0.50, 0.50);
        

        
        [cell.vibrationSwitchBtn addTarget:self action:@selector(vibrationSwithAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.SoundSwitchBtn addTarget:self action:@selector(soundSwithAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messSwitchBtn addTarget:self action:@selector(messSwithAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    if (indexPath.row == 9)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellTermsOfUse;
            
        }
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        cell.layoutConstraintTermsOfUseBtnDependViewHeight.constant =50;
        }
       
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Tablecell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 6)
    {
        commonWidth = (Tablecell.contentView.frame.size.width - 20) / 14;
        imageSize = commonWidth * 2;
    }
}

- (IBAction)messSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
       
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor lightGrayColor]];
        isNotification_message =@"Yes";
        
    }else{
       
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setThumbTintColor:[UIColor redColor]];
        isNotification_message =@"No";
    }
}

- (IBAction)soundSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
       
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor lightGrayColor]];
        isNotification_message =@"Yes";
        
    }else{
       
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setThumbTintColor:[UIColor redColor]];
        isNotification_message =@"No";
        
    }
}

- (IBAction)vibrationSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor lightGrayColor]];
        isNotification_message =@"Yes";
        
    }else{
       
        
        [sender setTintColor:[UIColor grayColor]];
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setThumbTintColor:[UIColor redColor]];
        isNotification_message =@"No";
    }
}



-(void)buttonAction:(UIButton *)sender
{
    
    id button = sender;
    while (![button isKindOfClass:[UITableViewCell class]]) {
        button = [button superview];
    }
    NSIndexPath *indexPath;
     NSString *selOptionVal;
    //DSProfileTableViewCell *cell;
    
    indexPath = [_tableviewProfile indexPathForCell:(UITableViewCell *)button];
    cell = (DSProfileTableViewCell *) [_tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    if([sender tag] == 2004){
        selOptionVal = @"Male";
        maleLabel.textColor =  [UIColor redColor];    //[UIColor colorWithRed:(161.0/255.0f) green:(161.0/255.0f) blue:(161.0/255.0f) alpha:1.0f];
    }
    
    if([sender tag] == 2005){
       selOptionVal = @"female";
        femaleLabel.textColor = [UIColor redColor];   //[UIColor colorWithRed:(161.0/255.0f) green:(161.0/255.0f) blue:(161.0/255.0f) alpha:1.0f];
    }
    
    
    
    
//                if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
//                    [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"placeHolder"];
//    [_tableviewProfile beginUpdates];
//    [_tableviewProfile reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [_tableviewProfile endUpdates];
    selectGender =selOptionVal;
    
    //[_tableviewProfile reloadData];
}

#pragma mark - Textview delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
    //DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell.textViewHeaderLabel.hidden = YES;
    
    textviewText = textView.text;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
    //DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell.textViewHeaderLabel.hidden = YES;
    
    textviewText = textView.text;
}





#pragma mark - Camera Action
-(void)selectCamera: (UIButton *)sender
{
 
    imagepickerController = [[UIImagePickerController alloc] init];
    imagepickerController.delegate = self;
    [imagepickerController setAllowsEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL",@"") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //[self promptForCamera];
                                                        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                   }];
    
    UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:NSLocalizedString(@"CAMERA",@"") style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          imagepickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          [self presentViewController:imagepickerController animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"PHOTO LIBRARY",@"") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                      // [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                        imagepickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        [self presentViewController:imagepickerController animated:YES completion:nil];
                                                   }];
    
    [alert addAction:camera];
    [alert addAction:photoRoll];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    [topViewCell setHidden:NO];
    image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if(CurrentImage==0)
        profileImage1 = image;
    else if(CurrentImage == 1)
        profileImage2 = image;
    else if(CurrentImage == 2)
        profileImage3 = image;
    
    NSData *profileData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.1);
    [profileDataArray replaceObjectAtIndex:CurrentImage withObject:profileData];
    
    [imagepickerController dismissViewControllerAnimated:YES completion:nil];
    


}

#pragma mark - gotoHomeView
-(void)gotoHomeView{
    HomeViewController * objHomeview = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:objHomeview animated:NO];
    
}
#pragma mark - registerAPI
-(void) registerAPI{
    
    if(currentLatitude == nil)
        currentLatitude = @"";
    if(currentLongitude == nil)
        currentLongitude = @"";
    
    [objWebService postRegister:Register_API
                           type:strType
                     first_name:FirstName
                      last_name:LastName
                          email:emailAddressToRegister
                       password:emailPasswordToRegister
                      profileId:strProfileID
                            dob:dateChange
                  profileImage1:profileImage1
                  profileImage2:profileImage2
                  profileImage3:profileImage3
               IntersertHobbies:strInterestHobbies
                          About:strAbout
                         gender:strGender
                       latitude:currentLatitude
                      longitude:currentLongitude
                         device:Device
                       deviceid:deviceUdid
           notification_message:isNotification_message
           notification_sound  :isNotification_sound
         notification_vibration:isNotification_vibration
                        success:^(AFHTTPRequestOperation *operation, id responseObject){
                            [COMMON removeLoading];
                        }
     
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            [COMMON removeLoading];
                        }];

    
}
#pragma mark - updateAPI
-(void) updateAPI{
    if(currentLatitude == nil)
        currentLatitude = @"";
    if(currentLongitude == nil)
        currentLongitude = @"";
    
    [objWebService profileUpdate:ProfileUpdate_API
                      first_name:FirstName
                       last_name:LastName
                             dob:dateChange
                        password:emailPasswordToRegister
                   profileImage1:profileImage1
                   profileImage2:profileImage2
                   profileImage3:profileImage3
                          gender:strGender
                           about:strAbout
                         hobbies:strInterestHobbies
                        latitude:currentLatitude
                       longitude:currentLongitude
                    notification:@""
                       sessionid:loginUserSessionID
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSLog(@"profileUpdate%@",responseObject);
                             [COMMON removeLoading];
                         }
                         failure:^(AFHTTPRequestOperation *operation, id error) {
                             [COMMON removeLoading];

                         }
     ];
}
#pragma mark - loadRegisterNotification
-(void)loadRegister{
    
    [COMMON LoadIcon:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadRegisterView:)
                                                 name:@"registerform"
                                               object:nil];
    [self registerAPI];

    
}
-(void)loadRegisterView:(NSNotification *)notification{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self gotoHomeView];
    
}

#pragma mark - saveAction
-(void)saveAction:(id)sender
{
    
    [COMMON LoadIcon:self.view];
    if(profileDict !=NULL){
        
        NSArray *postPerArray;
        postPerArray = [[placeHolderArray objectAtIndex:0]valueForKey:@"TypingText"];
        
        FirstName = [profileDict valueForKey:@"first_name"];
        LastName  = [profileDict valueForKey:@"last_name"];
        strGender = [profileDict valueForKey:@"gender"];
        strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :@"";
       // strAbout;
        [self dateConverter];
        [self updateAPI];
    }
    else
        [self loadValidations];
}
#pragma mark - dateConverter
-(void)dateConverter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormatter dateFromString: strDOB];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateChange = [dateFormatter stringFromDate:date];
    NSLog(@"Converted String : %@",dateChange);

}
#pragma mark - saveAction
-(void)loadValidations
{
    
    [COMMON LoadIcon:self.view];
    NSArray *postPerArray;
    if(userDetailsDict.count >0){
    postPerArray = [[placeHolderArray objectAtIndex:0]valueForKey:@"placeHolder"];
    }
    else
    postPerArray = [[placeHolderArray objectAtIndex:0]valueForKey:@"TypingText"];
    NSLog(@"hobby:%@",hobbiesNameArray);
    
    strFirstName = [postPerArray objectAtIndex:1];
    strLastName  = [postPerArray objectAtIndex:2];
    strType      = (selectEmail== YES)?@"1":@"2";
    strProfileID = (FBprofileID!=nil)?FBprofileID:@"";
    strGender    = (selectGender!=nil)?selectGender:@"";
    //FirstName    = (strFirstName!=nil)? strFirstName:@"";
   // LastName     = (strLastName!=nil)?strLastName:@"";

    strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :@"";
    [self dateConverter];
    
    NSLog(@"isNotification_vibration:%@",isNotification_vibration);
    
    
    if(FirstName == nil)
    {

        [self showAltermessage:FIRSTNAME_REQUIRED];
        [COMMON removeLoading];
        return;
    }
   else if(LastName ==nil)
    {
        [self showAltermessage:LASTNAME_REQUIRED];
        [COMMON removeLoading];
        return;
        
    }
    
   else if ( [dateChange isEqualToString:@""] || dateChange == NULL )
    {

         [self showAltermessage:DOB_REQUIRED];
        [COMMON removeLoading];
        return;
    }
    
   else if ( [strGender isEqualToString:@""] || strGender == NULL)
    {
        [self showAltermessage:GENDER_REQUIRED];

        [COMMON removeLoading];
        return;
    }
    
   else if ( [emailAddressToRegister isEqualToString:@""] || emailAddressToRegister == nil)
    {
        [self showAltermessage:EMAIL_REQUIRED];
        [COMMON removeLoading];
        return;
    }
   else if ( [emailPasswordToRegister isEqualToString:@""] || emailPasswordToRegister == nil)
    {

        [self showAltermessage:PASSWORD_REQUIRED];
        [COMMON removeLoading];
        return;
    }
  else
  {
      [COMMON removeLoading];
      [self loadRegister];
  }
    
    
//    if(![FirstName isEqual:[NSNull null]]&& ![FirstName isEqualToString:@""]&&![LastName isEqual:[NSNull null]]&& ![LastName isEqualToString:@""] &&![dateChange isEqual:[NSNull null]]&&![strGender isEqual:[NSNull null]]&& ![strGender isEqualToString:@""] &&![emailAddressToRegister isEqual:[NSNull null]] &&![emailAddressToRegister isEqualToString:@""] &&![emailPasswordToRegister isEqual:[NSNull null]] && ![emailPasswordToRegister isEqualToString:@""]){
////            if(![NSString validateEmail:emailAddressToRegister]){
////                if(IS_GREATER_IOS8){
////                [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:INVALID_EMAIL preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
////                }
////                else
////                {
////                    [DSAppCommon showSimpleAlertWithMessage:INVALID_EMAIL];
////                }
////                [COMMON removeLoading];
////                
////                return;
////            }
//           if([dateChange isEqual:@"DD-MM-YYYY"]){
//               [self showAltermessage:@"ENTER DATE"];
//               [COMMON removeLoading];
//               return;
//           }
//        [self loadRegister];
//        
//
//    }
//    
//    else{
//        [self showAltermessage:FILL_ALL_DETAILS];
//        [COMMON removeLoading];
//        return;
//    }

}



@end
