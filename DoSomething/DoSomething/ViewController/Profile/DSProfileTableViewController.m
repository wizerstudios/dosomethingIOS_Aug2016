
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
#import "DSTermsOfUseView.h"
#import "AppDelegate.h"


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
    
    BOOL isSelectMale,isSelectFemale,isSave;
    UIWindow *windowInfo;
    
    AppDelegate *appDelegate;
    BOOL isPick;
    

}
@property(nonatomic,retain) DSTermsOfUseView *termsOfUseView;
@end


@implementation DSProfileTableViewController
@synthesize  profileData1, profileData2,profileData3,textviewText, placeHolderArray,FBprofileID;
@synthesize userDetailsDict,emailAddressToRegister,emailPasswordToRegister,selectEmail,topViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    objWebService = [[DSWebservice alloc]init];
    
    deviceUdid = [OpenUDID value];
   
    [self profileImageDisplayMethod];
    isPick=NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self loadNavigationview];
    
    
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
    infoArray=[[NSMutableArray alloc]initWithObjects:@"profile_noimg",@"profile_noimg",@"profile_noimg", nil];
    [self CustomAlterview];
   
    [self getUserCurrenLocation];
    [self loadDataMethod];
    
}

-(void)loadNavigationview
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
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:NO];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)loadDataMethod
{
    self.notificationLbl.hidden=YES;
    self.notificationview.hidden=YES;
    self.termandprivacyview.hidden=YES;
    self.profileGenderview.hidden=NO;
    self.profileMainviewbottomPosition.constant=-130;
    [self profileScroll];
    [self scrolltop];
     [self notificationMethod];
    [self hobbiesListMethod];
    if(profileDict!=nil)
    {
        self.firstnameTxt.text=[profileDict valueForKey:@"first_name"];
        self.lastNameTxt.text =[profileDict valueForKey:@"last_name"];
        self.emailTextField.text=[profileDict valueForKey:@"email"];
        self.profilegenderLbl.text =[profileDict valueForKey:@"gender"];
        self.DOBTxt.text          =[profileDict valueForKey:@"date_of_birth"];
        self.textViewAboutYou.text =[profileDict valueForKey:@"about"];
       
        
    }
    else if (userDetailsDict!=nil)
    {
        self.firstnameTxt.text=[userDetailsDict valueForKey:@"first_name"];
        self.lastNameTxt.text =[userDetailsDict valueForKey:@"last_name"];
        self.emailTextField.text=[userDetailsDict valueForKey:@"email"];
        self.profilegenderLbl.text =[userDetailsDict valueForKey:@"gender"];
        self.DOBTxt.text          =[userDetailsDict valueForKey:@"date_of_birth"];
        self.textViewAboutYou.text =[userDetailsDict valueForKey:@"about"];
    }
    else
    {
        self.notificationview.hidden=NO;
        self.termandprivacyview.hidden=NO;
        self.notificationLbl.hidden=NO;
        self.profileGenderview.hidden=YES;
        self.profileMainviewbottomPosition.constant=0;
        self.emailTextField.text=emailAddressToRegister;
        self.passwordTextField.text=emailPasswordToRegister;
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.buttonsView.hidden=YES;

    }
}

-(void)scrolltop
{
    
}
-(void)profileImageDisplayMethod
{
    profileDict=[[NSMutableDictionary alloc]init];
    profileDict =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString * strsessionID =[profileDict valueForKey:@"SessionId"];
    loginUserSessionID = strsessionID;
    NSLog(@"DICT%@",profileDict);
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItemCategoryID"];
    isNotification_message = @"Yes";
    isNotification_vibration = @"Yes";
    isNotification_sound = @"Yes";
    
    NSString *ImageURL1 , *ImageURL2, *ImageURL3 ;
    NSData *imageData1, *imageData2, *imageData3;
    if(profileDict.count > 0){
        if([[profileDict valueForKey:@"image1"] isEqual:@""]&&[[profileDict valueForKey:@"image2"] isEqual:@""] && [[profileDict valueForKey:@"image3"] isEqual:@""]){
            profileDataArray = [[NSMutableArray alloc] init];
            
            
            for(int i = 0; i < 3; i++)
            {
                NSData *data = [NSData new];
                [profileDataArray addObject:data];
            }
        }
        
        
        else{
           
            ImageURL1 = [profileDict valueForKey:@"image1"];
            
            ImageURL2 = [profileDict valueForKey:@"image2"];
            
            ImageURL3 = [profileDict valueForKey:@"image3"];
            
            
            
            profileDataArray = [[NSMutableArray alloc]initWithObjects:ImageURL1,ImageURL2,ImageURL3, nil];        }
        
    }
    else{
        if(userDetailsDict.count > 0){
            
            
            if([[userDetailsDict valueForKey:@"profileImage"] isEqual:@""]){
                ImageURL1 = [userDetailsDict valueForKey:@"profileImage"];
            }
            else{
                ImageURL1 = [userDetailsDict valueForKey:@"profileImage"];
             
                
            }
            ImageURL2 = @"";
           
            ImageURL3 = @"";
            
            
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

#pragma mark - scroll

-(void)profileScroll{
    
    self.scrView.pagingEnabled=YES;
    self.scrView.delegate=self;
    
    int spacing = 20;
    
    for(int i = 0; i < [profileDataArray count]; i++)
    {
        NSLog(@"int = %d",i);
        NSData *profileData = [profileDataArray objectAtIndex:i];
       
        if(IS_IPHONE6_Plus)
        {
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3.5) + spacing, 20,self.profileImageview.frame.size.width, self.profileImageview.frame.size.height)];
        }
        else
        {
        userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing, 20,self.profileImageview.frame.size.width, self.profileImageview.frame.size.height)];
        }
        [userProfileImage setTag:i+100];
        if([profileData length] == 0){
                [userProfileImage setImage:[UIImage imageNamed:@"profile_noimg"]];
               // [topViewCell setHidden:YES];
            if(i==0){
                [topViewCell setHidden:YES];
                self.scrView.scrollEnabled = NO;
            }
            
        }
        else{
            if(profileDict==nil){
                [userProfileImage setImage:[UIImage imageWithData:profileData]];
               
            }
            
            else{

                NSString *image     = [profileDataArray objectAtIndex:CurrentImage];
                profileData = [profileDataArray objectAtIndex:CurrentImage];
                if([image isEqualToString:@""] || image == nil)
                    [userProfileImage setImage:[UIImage imageWithData:profileData]];

                else{
                    downloadImageFromUrl(image,userProfileImage);
                    [userProfileImage setImage:[UIImage imageNamed:image]];
                }
                
            }
            
        
                [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
                [cell.cameraButton setHidden:YES];
                [topViewCell setHidden:NO];
            
        }
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height / 2;
        userProfileImage.layer.masksToBounds = YES;
        [userProfileImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCamera:)];
        [singleTap setNumberOfTapsRequired:1];
        [userProfileImage addGestureRecognizer:singleTap];
        [self.scrView addSubview:userProfileImage];
            
//        cameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(userProfileImage.frame.size.width / 2 - 15, self.scrView.frame.size.height - 55, 30, 30)];
//        [cameraImage setTag:i+200];
//        [cameraImage setImage:[UIImage imageNamed:@"profile_camera_icon"]];
//    
//        cameraImage.userInteractionEnabled = YES;
//        [cameraImage setUserInteractionEnabled:YES];
//        [userProfileImage addSubview:cameraImage];
        
    }
    
    self.scrView.contentSize=CGSizeMake(self.scrView.frame.size.width*3, self.scrView.frame.size.height);
    
    if(CurrentImage == 0)
        [self.scrView setContentOffset:CGPointMake(0, 0)animated:NO];
    else if(CurrentImage == 1)
        [self.scrView setContentOffset:CGPointMake(1.5*self.profileImageview.frame.size.width - 15, 0)animated:NO];
    else if(CurrentImage == 2)
        [self.scrView setContentOffset:CGPointMake((3*self.profileImageview.frame.size.width - 15), 0)animated:NO];
    
    
//    xslider=0;
//    pgDtView=[[UIView alloc]init];
//    pgDtView.backgroundColor=[UIColor clearColor];
//    pageImageView =[[UIImageView alloc]init];
//    profileImagePageControl.numberOfPages=infoArray.count;
//    
//    for(int i=0;i<profileImagePageControl.numberOfPages;i++)
//    {
//        blkdot=[[UIImageView alloc]init];
//        [blkdot setFrame:CGRectMake(i*18, 0, 8, 8 )];
//        [blkdot setImage:[UIImage imageNamed:@"dot_normal"]];
//
//        [pgDtView addSubview:blkdot];
//        [pageImageView setFrame:CGRectMake(0, 0, 8, 8)];
//        [pageImageView setImage:[UIImage imageNamed:@"dot_active_red"]];
//        [pgDtView addSubview:pageImageView];
//        [topViewCell addSubview:pgDtView];
//        [pgDtView setFrame:CGRectMake(15, -5, profileImagePageControl.numberOfPages*18, 10)];
//        
//    }

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
    [pageImageView setFrame:CGRectMake(jslider*18, 0, 8, 8)];
    
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
        if(textField.text.length > 0)
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
           
            else if (textField.tag ==14)
            {
                emailAddressToRegister = strSearchLetters;
            }
            else if (textField.tag == 15)
            {
                emailPasswordToRegister = strSearchLetters;
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
    
    NSLog(@"texttag:%ld",(long)textField.tag);

    textField.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
    

    
  NSString *selOptionVal;

    if (textField.tag ==1000) {
        selOptionVal = cell.textFieldDPPlaceHolder.text;
       
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        selOptionVal = [formatter stringFromDate:date];
       
        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
          
            currentTextfield.text =selOptionVal;
        }
        
        
    }

    
}


- (void)pushToHobbiesView {
    
    DSInterestAndHobbiesViewController * DSHobbiesView  = [[DSInterestAndHobbiesViewController alloc]initWithNibName:@"DSInterestAndHobbiesViewController" bundle:nil];
    DSHobbiesView.profileDetailsArray = placeHolderArray;
    [self.navigationController pushViewController:DSHobbiesView animated:YES];
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
    
        objCustomAlterview. alertBgView.hidden = YES;
        objCustomAlterview.alertMainBgView.hidden = YES;
        objCustomAlterview.view .hidden  = YES;
   
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
-(void)hobbiesListMethod
{
      [self.buttonPushHobbies addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
    yAxis = 31;
            if(profileDict ==NULL)
            {
                imageSize =39;
                commonWidth=19.5;
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
                self.plusIconImageView.hidden = YES;
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
    
                [self.addinteresthobbiesview addSubview:hobbiesImage];
                [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
            }
    
            for (int i =0; i< [hobbiesNameArray  count]; i++) {
    
                NSString *image =[[hobbiesNameArray objectAtIndex:i]uppercaseString];
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
                [self.addinteresthobbiesview addSubview:hobbiesname];
                hobbiesname.textAlignment = NSTextAlignmentCenter;
            }
}


#pragma mark -loadTermsOfUseView

-(IBAction)loadTermsOfUseViewAction:(id)sender
{
    [self loadTermsOfUseView];
}

-(void)loadTermsOfUseView
{
    windowInfo = [[[UIApplication sharedApplication] delegate] window];
    
    DSTermsOfUseView *termsOfUseView = [[DSTermsOfUseView alloc] init];
    
    [windowInfo addSubview:termsOfUseView];
    
    [termsOfUseView.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTermsOfUseView:termsOfUseView];
    
    NSDictionary *dictView = @{@"_terms":termsOfUseView};
    
    [windowInfo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_terms]|"
                                
                                                                       options:0
                                
                                                                       metrics:nil views:dictView]];
    
    [windowInfo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_terms]|"
                                
                                                                       options:0
                                
                                                                       metrics:nil views:dictView]];
}

-(IBAction)closeButtonAction:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.termsOfUseView removeFromSuperview];
        
    });
}
#pragma mark -notificationMethod
-(void)notificationMethod
{
    self.messSwitchBtn.transform = CGAffineTransformMakeScale(0.70, 0.70);
    self.SoundSwitchBtn.transform = CGAffineTransformMakeScale(0.70, 0.70);
    self.vibrationSwitchBtn.transform = CGAffineTransformMakeScale(0.70, 0.70);
    
            self.vibrationSwitchBtn.layer.cornerRadius = 16.0;
            self.SoundSwitchBtn.layer.cornerRadius = 16.0;
            self.messSwitchBtn.layer.cornerRadius = 16.0;

    
    NSString * objMsg =[isNotification_message isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[isNotification_sound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[isNotification_vibration isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [cell.messSwitchBtn setThumbTintColor:[UIColor greenColor]];
        
        [cell.messSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.messSwitchBtn setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        
    }
    if([objSound isEqualToString:@"switch_on"])
    {
        [cell.SoundSwitchBtn setThumbTintColor:[UIColor greenColor]];
        
        [cell.SoundSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.SoundSwitchBtn setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        [cell.vibrationSwitchBtn setThumbTintColor:[UIColor greenColor]];
        
        [cell.vibrationSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.vibrationSwitchBtn setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    }
    
    if([objMsg isEqualToString:@"switch_off"])
    {
        [cell.messSwitchBtn setTintColor:[UIColor redColor]];
        [cell.messSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.messSwitchBtn setThumbTintColor:[UIColor redColor]];
    }
    if([objSound isEqualToString:@"switch_off"])
    {
        [cell.SoundSwitchBtn setTintColor:[UIColor whiteColor]];
        [cell.SoundSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.SoundSwitchBtn setThumbTintColor:[UIColor redColor]];
    }
    
    if([objVibration isEqualToString:@"switch_off"])
    {
        [cell.vibrationSwitchBtn setTintColor:[UIColor whiteColor]];
        [cell.vibrationSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.vibrationSwitchBtn setThumbTintColor:[UIColor redColor]];
    }
    [self.vibrationSwitchBtn addTarget:self action:@selector(vibrationSwithAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.SoundSwitchBtn addTarget:self action:@selector(soundSwithAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.messSwitchBtn addTarget:self action:@selector(messSwithAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)messSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
       
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        isNotification_message =@"Yes";
        
    }else{
       
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
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
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        isNotification_sound =@"Yes";
        
    }else{
       
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        isNotification_sound =@"No";
        
    }
}

- (IBAction)vibrationSwithAction:(UISwitch *)sender
{
    sender.layer.cornerRadius = 16.0;
    if (sender.on) {
        
        [sender setThumbTintColor:[UIColor greenColor]];
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        isNotification_vibration =@"Yes";
        
    }else{
       
        
        [sender setTintColor:[UIColor clearColor]];
        [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [sender setThumbTintColor:[UIColor redColor]];
        isNotification_vibration =@"No";
    }
}



-(IBAction)buttonAction:(UIButton *)sender
{
    NSLog(@"buttontag=%ld",(long)sender.tag);
 
     NSString *selOptionVal;
    
    
    if([sender tag] == 2004){
        selOptionVal = @"male";
        [self.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       [self.femaleButton setTitleColor:[UIColor colorWithRed:(161.0/255.0f) green:(161.0/255.0f) blue:(161.0/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        isSelectMale =YES;
        isSelectFemale=NO;
        
    }
    
    if([sender tag] == 2005){
       selOptionVal = @"female";
      
        [self.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         [self.maleButton setTitleColor:[UIColor colorWithRed:(161.0/255.0f) green:(161.0/255.0f) blue:(161.0/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        isSelectFemale=YES;
         isSelectMale =NO;
    }
    
    strGender =selOptionVal;
    
   }

#pragma mark - Textview delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
    
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell.textViewHeaderLabel.hidden = YES;
    if(textView.tag == 0) {
        
        if(strAbout==nil){
            
            textView.text = @"";
            textView.tag = 1;
            strAbout = textView.text;

        }
        
        else if([strAbout isEqual: @"Write something about yourself here."]) {
            textView.text = @"";
            textView.tag = 1;
            strAbout = textView.text;
        }
        
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
   
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell.textViewHeaderLabel.hidden = YES;
    if([textView.text length] == 0)
    {
        textView.tag = 0;
    }

    strAbout = textView.text;
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
                                                       
                                                        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                   }];
    
    UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:NSLocalizedString(@"CAMERA",@"") style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          imagepickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          [self presentViewController:imagepickerController animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"PHOTO LIBRARY",@"") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                     
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
    
    NSData *profileData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
    
     [profileDataArray replaceObjectAtIndex:CurrentImage withObject:profileData];
    
    [imagepickerController dismissViewControllerAnimated:YES completion:nil];
    //isPick=YES;
    

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
    
    NSString *fbProfileStr;
    if([strType isEqualToString:@"2"])
        fbProfileStr = [userDetailsDict valueForKey:@"profileImage"];

    
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
                  fbprofileImage:fbProfileStr
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
#pragma mark - loadUpdateNotification
-(void)loadUpdate{
    
    [COMMON LoadIcon:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadUpdateView:)
                                                 name:@"updateprofile"
                                               object:nil];
    
   [self updateAPI];
    
    
}
-(void)loadUpdateView:(NSNotification *)notification{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self showAltermessage:@"Profile Updated Successfully"];
    [COMMON removeLoading];
    
}


#pragma mark - saveAction
-(void)saveAction:(id)sender
{
    [self.view endEditing:YES];
    [COMMON LoadIcon:self.view];
    
//    if(isSave==NO)
//    {
    if(profileDict !=NULL){
        strGender = [profileDict valueForKey:@"gender"];
          strDOB    = (currentTextfield.text !=nil)?currentTextfield.text :@"";

        [self dateConverter];
        [self loadUpdate];
        isSave =YES;
    }
    else
        [self loadValidations];
    //}
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
    
    NSLog(@"hobby:%@",hobbiesNameArray);
    strType      = (selectEmail== YES)?@"1":@"2";
    strProfileID = (FBprofileID!=nil)?FBprofileID:@"";
    //emailPasswordToRegister = cell.passwordTextField.text;
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
   else if ([strGender isEqualToString:@""] || strGender == NULL)
   {
       [self showAltermessage:GENDER_REQUIRED];
       
       [COMMON removeLoading];
       return;
   }

    
   else if ([dateChange isEqualToString:@""] || dateChange == NULL )
    {

         [self showAltermessage:DOB_REQUIRED];
        [COMMON removeLoading];
        return;
    }
    
    
   else if ([emailAddressToRegister isEqualToString:@""] || emailAddressToRegister == nil)
    {
        [self showAltermessage:EMAIL_REQUIRED];
        [COMMON removeLoading];
        return;
    }
   else if ([emailPasswordToRegister isEqualToString:@""] || emailPasswordToRegister == nil)
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
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
