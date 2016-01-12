
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
#import "UIImageView+AFNetworking.h"
#import "CustomAlterview.h"
#import "DSHomeViewController.h"
#import "AppDelegate.h"
#import "DSTermsViewController.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"



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
    BOOL isPick;
    BOOL isPageControl;
    BOOL isLoadData;
    NSString *sessionID;
    CustomNavigationView *customNavigation;
    UIButton *cameraIcon;
    NSMutableArray *hobbiesMainArray;
    NSString * Regpassword;
    

}

@end


@implementation DSProfileTableViewController
@synthesize  profileData1,textviewText, placeHolderArray,FBprofileID;
@synthesize userDetailsDict,emailAddressToRegister,emailPasswordToRegister,selectEmail,currentPassword,confirmPassword;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Regpassword=emailPasswordToRegister;
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[_tableviewProfile class]];
    
    locationManager                 = [[CLLocationManager alloc] init];
    
    locationManager.delegate        = self;
    
    objWebService = [[DSWebservice alloc]init];
    
    deviceUdid = [OpenUDID value];
    
    isPick=NO;
    
    isPageControl=NO;
    
    isLoadData=NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [self loadNavigation];
    
    [self getUserCurrenLocation];
    
    imageNormalArray =[[NSMutableArray alloc]init];
    
    hobbiesMainArray = [[NSMutableArray alloc]init];
    
    profileDict=[[NSMutableDictionary alloc]init];
    profileDict =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray] != NULL)
        hobbiesMainArray = [[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray];
    else{
        if([profileDict valueForKey:@"hobbieslist"]!=NULL)
               hobbiesMainArray = [[profileDict valueForKey:@"hobbieslist"]mutableCopy];
        emailPasswordToRegister=[profileDict valueForKey:@"password"];
        
    }
    [[NSUserDefaults standardUserDefaults]setObject:hobbiesMainArray forKey:HobbiesArray];
    
    [self selectitemMethod];
    
    infoArray=[[NSMutableArray alloc]initWithObjects:@"profile_noimg",@"profile_noimg",@"profile_noimg", nil];
    
    if(!isLoadData){
        [self initializeArray];
        [self profileImageDisplayMethod];
        isLoadData = YES;
    }
    else if(isLoadData == YES && profileDict ==NULL)
    {
      
        hobbiesMainArray = [[[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray]mutableCopy];
        
        imageNormalArray = [[hobbiesMainArray valueForKey:@"image"]mutableCopy];
        
        hobbiesNameArray = [hobbiesMainArray valueForKey:@"name"];
        
       
        
        strInterestHobbies = [[hobbiesMainArray valueForKey:@"hobbies_id"] componentsJoinedByString:@","];
       
    }

     [_tableviewProfile reloadData];
        
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self CustomAlterview];
}

-(void)loadNavigation{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
        //self.layoutConstraintTableViewYPos.constant= 20;
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        //self.layoutConstraintTableViewYPos.constant= 20;
    }
    [customNavigation.menuBtn setHidden:YES];
    if(profileDict == NULL)
    {
    [customNavigation.buttonBack setHidden:NO];
    }
    [customNavigation.saveBtn setHidden:NO];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)profileImageDisplayMethod
{
    
    NSString * strsessionID =[profileDict valueForKey:@"SessionId"];
    loginUserSessionID = strsessionID;
  
    if(profileDict != NULL)
    {
        [self initializeArrayProfile];
        [customNavigation.buttonBack setHidden:YES];
        
        interstAndHobbiesArray = [[profileDict valueForKey:@"hobbieslist"]mutableCopy];
        hobbiesNameArray       =[[interstAndHobbiesArray valueForKey:@"name"]mutableCopy];
        imageNormalArray     = [[interstAndHobbiesArray valueForKey:@"image"]mutableCopy];
        self.tableViewHeightConstraint.constant=50;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItemCategoryID"];
    
    isNotification_message = @"Yes";
    isNotification_vibration = @"Yes";
    isNotification_sound = @"Yes";
    
    NSString *ImageURL1 , *ImageURL2, *ImageURL3 ;
    
    if(profileDict.count > 0){
        
        if([[profileDict valueForKey:@"image1"] isEqual:@""]&&[[profileDict valueForKey:@"image2"] isEqual:@""] && [[profileDict valueForKey:@"image3"] isEqual:@""]){
            [self profileDataArrayValue];
        }
        
        else{
            ImageURL1 = [profileDict valueForKey:@"image1"];
            ImageURL2 = [profileDict valueForKey:@"image2"];
            ImageURL3 = [profileDict valueForKey:@"image3"];
            
            profileDataArray = [[NSMutableArray alloc]initWithObjects:ImageURL1,ImageURL2,ImageURL3, nil];
        }
        
    }
    else{
        if(userDetailsDict.count > 0){
            if([[userDetailsDict valueForKey:@"profileImage"] isEqual:@""]){
                ImageURL1 = [userDetailsDict valueForKey:@"profileImage"];
            }
            else{
                ImageURL1 = [userDetailsDict valueForKey:@"profileImage"];
                
            }
            ImageURL2 = @"";ImageURL3 = @"";
            profileDataArray = [[NSMutableArray alloc]initWithObjects:ImageURL1,ImageURL2,ImageURL3, nil];
            
        }
        else{
            [self profileDataArrayValue];
        }
    }
    
}

-(void)selectitemMethod
{
    
    hobbiesMainArray = [[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray];
    
    strInterestHobbies = [[hobbiesMainArray valueForKey:@"hobbies_id"] componentsJoinedByString:@","];
    
    
    imageNormalArray = [[hobbiesMainArray valueForKey:@"image"]mutableCopy];
    
    hobbiesNameArray = [hobbiesMainArray valueForKey:@"name"];
    
    [_tableviewProfile reloadData];
    
   
    
}



#pragma mark - profileDataArray

-(void)profileDataArrayValue{
    profileDataArray = [NSMutableArray new];
    
    
    for(int i = 0; i < 3; i++)
    {
        NSData *data = [NSData new];
        [profileDataArray addObject:data];
    }
}

#pragma mark - scroll
-(void)profileScroll{
    
    self.scrView.pagingEnabled=YES;
    self.scrView.delegate=self;
    
    int spacing = 20;
   
    
    for(int i = 0; i < 3; i++)
    {
        
        NSData * profileData = [profileDataArray objectAtIndex:i];
        NSString *image     = [profileDataArray objectAtIndex:i];
        if(IS_IPHONE6_Plus || IS_IPHONE6)
        {
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing+30, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
        }
    
        else
        {
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
        }
        [userProfileImage setTag:i+100];
        if([profileData length] == 0){
            [userProfileImage setImage:[UIImage imageNamed:@"profile_noimg"]];
            if(i==0){
                [cell.topViewCell setHidden:YES];
                self.scrView.scrollEnabled = NO;
               
            }
            
        }
        else{
            if(profileDict==nil){
                if(userDetailsDict.count>0) {
                    if(isPick==YES){
                        if([[userDetailsDict valueForKey:@"profileImage"] isEqual:[profileDataArray objectAtIndex:i]])
                        {
                            [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
                        }
                        else{
                            [userProfileImage setImage:[UIImage imageWithData:profileData]];
                        }
                    }
                    else
                        [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
                }
                else{
                    [userProfileImage setImage:[UIImage imageWithData:profileData]];
                }
            }
            else{
                
                if(isPick==YES){
                    
                    if([[profileDict valueForKey:@"image1"] isEqual:[profileDataArray objectAtIndex:i]]){
                        downloadImageFromUrl(image, userProfileImage);
                        [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
                    }
                    else if([[profileDict valueForKey:@"image2"] isEqual:[profileDataArray objectAtIndex:i]]){
                        downloadImageFromUrl(image, userProfileImage);
                        [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
                    }
                    else if([[profileDict valueForKey:@"image3"] isEqual:[profileDataArray objectAtIndex:i]]){
                        downloadImageFromUrl(image, userProfileImage);
                        [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
                        
                    }
                    else
                        [userProfileImage setImage:[UIImage imageWithData:profileData]];
                }
                else{
                    downloadImageFromUrl(image, userProfileImage);
                    [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
                }
            }
            [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
            [cameraIcon setHidden:YES];
            [cell.topViewCell setHidden:NO];
            self.scrView.scrollEnabled = YES;
        }
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height / 2;
        userProfileImage.layer.masksToBounds = YES;
        [userProfileImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCamera:)];
        [singleTap setNumberOfTapsRequired:1];
        [userProfileImage addGestureRecognizer:singleTap];
        [self.scrView addSubview:userProfileImage];
        
        cameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(userProfileImage.frame.size.width / 2 -17, self.scrView.frame.size.height - 55, 30, 30)];
        [cameraImage setTag:i+200];
        [cameraImage setImage:[UIImage imageNamed:@"profile_camera_icon"]];
        // [topViewCell setHidden:YES];
        cameraImage.userInteractionEnabled = YES;
        [cameraImage setUserInteractionEnabled:YES];
        [userProfileImage addSubview:cameraImage];
      

    }
    
    self.scrView.contentSize=CGSizeMake(self.scrView.frame.size.width*3, self.scrView.frame.size.height);
    
    if(CurrentImage == 0)
        [self.scrView setContentOffset:CGPointMake(0, 0)animated:NO];
    else if(CurrentImage == 1)
    {
        if(IS_IPHONE6|| IS_IPHONE6_Plus)
        {
            [self.scrView setContentOffset:CGPointMake(4.5*self.profileImageView.frame.size.width - 25  , 0)animated:NO];
        }
    else
    {
        [self.scrView setContentOffset:CGPointMake(1.5*self.profileImageView.frame.size.width - 15, 0)animated:NO];
    }
    }
    else if(CurrentImage == 2)
    {
        if(IS_IPHONE6|| IS_IPHONE6_Plus)
        {
            [self.scrView setContentOffset:CGPointMake(9*self.profileImageView.frame.size.width - 15, 0)animated:NO];
        }
        else
        {

        [self.scrView setContentOffset:CGPointMake((3*self.profileImageView.frame.size.width - 15), 0)animated:NO];
        }
    }
    
    [self pageScrollView];
    
}
-(void) pageScrollView{
    if(isPageControl==NO){
        xslider=0;
        pgDtView=[[UIView alloc]init];
        pgDtView.backgroundColor=[UIColor clearColor];
        pageImageView =[[UIImageView alloc]init];
        profileImagePageControl.numberOfPages=infoArray.count;
        
        for(int i=0;i<profileImagePageControl.numberOfPages;i++)
        {
            blkdot=[[UIImageView alloc]init];
            [blkdot setFrame:CGRectMake(i*18, 0, 8, 8 )];
            [blkdot setImage:[UIImage imageNamed:@"dot_normal"]];
            
            [pgDtView addSubview:blkdot];
            [pageImageView setFrame:CGRectMake(0, 0, 8, 8)];
            [pageImageView setImage:[UIImage imageNamed:@"dot_active_red"]];
            [pgDtView addSubview:pageImageView];
            [cell.topViewCell addSubview:pgDtView];
            if(IS_IPHONE6||IS_IPHONE6_Plus) {
            [pgDtView setFrame:CGRectMake(40, -5, profileImagePageControl.numberOfPages*18, 10)];
            }
            else{
            [pgDtView setFrame:CGRectMake(15, -5, profileImagePageControl.numberOfPages*18, 10)];
            }
            
            
        }
        
    }
    isPageControl=YES;
   [cell.topViewCell addSubview:pgDtView];
   
    
}

- (IBAction)pageChanged:(id)sender {
   
    
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
   
    return emailAddress;
}
- (NSString *) getPassword {
    
    if (emailPasswordToRegister == NULL) {
        emailPasswordToRegister =Regpassword;              //@"";
    }
    NSString *emailPassword = emailPasswordToRegister;
   
    return emailPassword;
}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadLocationUpdateAPI];
        dispatch_async(dispatch_get_main_queue(), ^(){
            
        });
        
    });
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}

-(void)loadLocationUpdateAPI{
    
    [objWebService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              NSLog(@"responseObject = %@",responseObject);
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              
                          }];
    
    
}

-(void)loadDatePicker:(NSInteger)_tag{
    
    currentTextfield=(UITextField *)[self.view viewWithTag:_tag];
    
    datePicker   = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 320, 150)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger minimumYear = year - 1915;//Given some year here for example
    NSInteger minimumMonth = month - 1;
    NSInteger minimumDay = day - 1;
    [comps setYear:-minimumYear];
    [comps setMonth:-minimumMonth];
    [comps setDay:-minimumDay];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:[NSDate date]];
    
    datePicker.backgroundColor = [UIColor whiteColor];
    
    [datePicker addTarget:self action:@selector(DateSelectionAction:) forControlEvents:UIControlEventValueChanged];
    
    datePicker.tag =_tag;
    
    if([currentTextfield.text length] > 0  && ![currentTextfield.text isEqualToString:@"DD / MM / YYYY"]){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd / MM / yyyy"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        
        dateFromString = [dateFormatter dateFromString:currentTextfield.text];
        
        [datePicker setDate:dateFromString animated:NO];
        
    }
    
    [currentTextfield setInputView:datePicker];
    
    currentTextfield.tintColor=[UIColor clearColor];
}


- (void)DateSelectionAction:(UIDatePicker *)sender
{
    currentTextfield=(UITextField *)[self.view viewWithTag:[sender tag]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    [dateFormat setDateFormat:@"dd / MM / YYYY"];
    
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
            else if (textField.tag ==16)
            {
                currentPassword  =strSearchLetters;
            }
            else if (textField.tag == 17)
            {
                confirmPassword =strSearchLetters;
            }
            
            
        }
        
    }

        return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
 
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSInteger tag = [textField tag];
    if(textField.tag == 1000){
        [self loadDatePicker:tag];
    }
    else if (textField.tag == 15)
    {
        emailPasswordToRegister = @"";
    }
    else if (textField.tag ==16)
    {
        currentPassword  =@"";
    }
    else if (textField.tag == 17)
    {
        confirmPassword =@"";
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   

    textField.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
    

    
  NSString *selOptionVal;

    if (textField.tag ==1000) {
        selOptionVal = cell.textFieldDPPlaceHolder.text;
       
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd / MM / yyyy"];
        selOptionVal = [formatter stringFromDate:date];
       
        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
          
            currentTextfield.text =selOptionVal;
        }
        
        
    }
  //  [self.tableviewProfile scrollToRowAtIndexPath:[self.tableviewProfile indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    
}



-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToHobbiesView {
    
    DSInterestAndHobbiesViewController * DSHobbiesView  = [[DSInterestAndHobbiesViewController alloc]initWithNibName:@"DSInterestAndHobbiesViewController" bundle:nil];
    [self.navigationController pushViewController:DSHobbiesView animated:YES];

    

}

-(void)initializeArray{
    
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];
    
    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder", nil],
                                    
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"first_name"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"last_name"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"gender"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"DD / MM / YYYY",@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Write something about yourself here.",@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"email"],@"placeHolder",@"Password",@"placeHolderPass",@"",@"TypingTextPass", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"switch_on",@"placeHolder",@"",@"NewMessageImage",@"",@"SoundImage",@"",@"VibrationImage",nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"TermsOfUse",@"placeHolder",@"",@"TypingText", nil], nil]atIndex:0];
    
    
   
   
   
}
-(void)initializeArrayProfile{
    
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];
    
    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder",@"",@"TypingText", nil],
                                    
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"first_name"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"last_name"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"gender"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"date_of_birth"],@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Write something about yourself here.",@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeHolder", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[profileDict valueForKey:@"email"],@"placeHolder",@"Password",@"placeHolderPass",@"Current\n password",@"placeHolderCurrentPassword",@"Password\n Conformation",@"placeHolderconformation",@"",@"TypingTextPass", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"loginType",@"placeHolder", nil],
                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"loginType",@"placeHolder", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"loginType",@"placeHolder", nil], nil]atIndex:0];
    
   
    
   
    
    
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
    
   
    NSString *msgStr;
    msgStr = objCustomAlterview.alertMsgLabel.text;
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
            return 45;
        }
       if(indexPath.row == 4)
           return  48;
    
       if(indexPath.row == 5)
        {
            dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(tableView.frame.size.width-20,tableView.frame.size.height)];
            if([strAbout isEqualToString:@""]|| dataSize.height ==10){
                 return 40 ;
            }
            

            else
            {
                 self.aboutTextHeight.constant=dataSize.height;
                 return dataSize.height;
            }
            
        }
    
            if ( indexPath.row ==6)
            {
                imageSize =39;
                commonWidth=19.5;
                commonHeight = 54;
            if([imageNormalArray count] < 1)
                return 80;
            else if([imageNormalArray count] <= 4)
                return commonHeight + 46;

            else if([imageNormalArray count] <= 9)
                return (commonHeight*2)+46;

            else if([imageNormalArray count] <= 14)
                return (commonHeight * 3)+48;
                
           else if([imageNormalArray count] <= 20)
                return (commonHeight * 4)+52;
            }

       
            if ( indexPath.row == 7) {
                
                
                if(profileDict!=nil)
                {
                    NSString *objlogintype=[profileDict valueForKey:@"type"];
                    if([objlogintype isEqual:@"2"])
                    
                    {
                        return 0;
                    }
                    else
                    {
                    return 180;
                    }
                }
            
                return 120;
            }
            if (indexPath.row ==8) {
                
                if(profileDict!=nil)
                {
                    return 0;
                }
                return 150;
            }

        
            if (indexPath.row == 9) {
                
                if(profileDict != nil)
                {
                    return 0;
                }
                return 80;
            }
       if(indexPath.row ==10)
       {
           if(profileDict!=nil)
           {
               return 40;
           }
           return 0;
       }


    return 0;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    cell = (DSProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.row == 0)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellProfileImg;
        }
        
//        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
//        {
//            //cell.layoutConstraintProfileImageHeight.constant =159;
//            //cell.layoutConstraintProfileImageWidth.constant =161;
//        }
        cameraIcon=[UIButton buttonWithType:UIButtonTypeCustom];
        if(IS_IPHONE6 || IS_IPHONE6_Plus)
        {
        [cameraIcon setFrame:CGRectMake(cell.contentView.center.x+5,cell.contentView.frame.size.height-36,37,37)];
        }
        else{
            [cameraIcon setFrame:CGRectMake(cell.contentView.center.x-22,cell.contentView.frame.size.height-36,37,37)];
        }
        [cameraIcon addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *cameraIconImg = [UIImage imageNamed:@"camera_icon"];
        [cameraIcon setImage:cameraIconImg forState:UIControlStateNormal];
        [cameraIcon setTag:101];
        [cell addSubview:cameraIcon];
        [cameraIcon setHidden:NO];

       
        [self profileScroll];
        
        if(!profileData1){
            [profileImagePageControl setHidden:YES];
            
        }
        else
            [profileImagePageControl setHidden:NO];
        
                
        
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
            //cell.layoutConstraintViewHeight.constant =49;

        }
        if(profileDict !=NULL){
            [cell.textFieldPlaceHolder setEnabled:NO];
            cell.firstnameTxt.text =(FirstName==0)?[profileDict valueForKey:@"first_name"]:FirstName;
            cell.lastNameTxt.text  =(LastName==0)? [profileDict valueForKey:@"last_name"]:LastName;
            FirstName = cell.firstnameTxt.text;
            LastName  = cell.lastNameTxt.text;
            cell.firstaftersepratorlbl.hidden =YES;
            [cell.firstnameTxt setEnabled:NO];
            [cell.lastNameTxt setEnabled:NO];
        }
        else if(userDetailsDict.count > 0){

            cell.firstnameTxt.text =(FirstName==0)?[userDetailsDict valueForKey:@"first_name"]:FirstName;
            cell.lastNameTxt.text  =(LastName==0)? [userDetailsDict valueForKey:@"last_name"]:LastName;
            FirstName = cell.firstnameTxt.text;
            LastName  = cell.lastNameTxt.text;
            cell.firstaftersepratorlbl.hidden =YES;
            
        }
        else
           {
            cell.firstnameTxt.text = FirstName;
            cell.lastNameTxt.text   =LastName;
            cell.firstaftersepratorlbl.hidden =NO;
           }
        cell.firstnameTxt.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        cell.lastNameTxt.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        cell.lastNameTxt.autocorrectionType = UITextAutocorrectionTypeNo;

    }
    
    if(indexPath.row ==2)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellButton;
            
        }
        [cellButton setHidden:YES];

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
        
        
        if( profileDict !=NULL){

            profileGenderValueLabel.text =[profileDict valueForKey:@"gender"];
            
        }
        else if(userDetailsDict.count > 0){
            
            
            if(strGender==NULL){
                if([[userDetailsDict valueForKey:@"gender"]isEqual:@"male"]){
                    [cell.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    strGender=[userDetailsDict valueForKey:@"gender"];
                }
                else if([[userDetailsDict valueForKey:@"gender"]isEqual:@"female"]){
                    [cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    strGender=[userDetailsDict valueForKey:@"gender"];
                }
            }
            else{
                if([strGender isEqual:@"male"]){
                    [cell.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                else if([strGender isEqual:@"female"]){
                    [cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
            }
        
            [profileGenderView setHidden:YES];
            [profileGenderLabel setHidden:YES];
            [profileGenderValueLabel setHidden:YES];
            
            if(isSelectFemale ==YES)
            {
                [cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else if (isSelectMale==YES)
            {
                [cell.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
        else{
            [profileGenderView setHidden:YES];
            [profileGenderLabel setHidden:YES];
            [profileGenderValueLabel setHidden:YES];
            
            if(isSelectFemale ==YES)
            {
                [cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else if (isSelectMale==YES)
            {
                [cell.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
        }
        
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
            
            if(![[profileDict valueForKey:@"date_of_birth"] isEqual:currentTextfield.text]){
                
                
                if(currentTextfield.text == NULL){
                    if([[profileDict valueForKey:@"date_of_birth"]isEqualToString:@"00/00/0000"])
                        cell.textFieldDPPlaceHolder.text = @"DD / MM / YYYY";
                    else{
                        NSString *dateStr = [profileDict valueForKey:@"date_of_birth"];
                        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@" / "];
                        cell.textFieldDPPlaceHolder.text =dateStr;
                    }
                        [cell.textFieldDPPlaceHolder setTag:1000];

                }
                else{
                   
                    cell.textFieldDPPlaceHolder.text = currentTextfield.text;
                }
            }
            else{
                NSString *dateStr = [profileDict valueForKey:@"date_of_birth"];
                dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@" / "];
                cell.textFieldDPPlaceHolder.text =dateStr;
                
            }
             [cell.textFieldDPPlaceHolder setTag:1000];
           
            
        }
        else if(userDetailsDict.count > 0){
          
            if(![[userDetailsDict valueForKey:@"dob"] isEqual:currentTextfield.text]){
                if(currentTextfield.text == NULL){
                    cell.textFieldDPPlaceHolder.text =[userDetailsDict valueForKey:@"dob"];
                    [cell.textFieldDPPlaceHolder setTag:1000];
                    
                }
                else{
                    [cell.textFieldDPPlaceHolder setTag:1000];
                    cell.textFieldDPPlaceHolder.text = currentTextfield.text;
                }
            }
            else{
                if(currentTextfield.text == NULL){
                    cell.textFieldDPPlaceHolder.text =[userDetailsDict valueForKey:@"dob"];
                    [cell.textFieldDPPlaceHolder setTag:1000];
                    
                }
                else{
                    [cell.textFieldDPPlaceHolder setTag:1000];
                    cell.textFieldDPPlaceHolder.text = currentTextfield.text;
                }
            }
        }
        
        else
        {
        if([currentTextfield.text isEqualToString:@""] || currentTextfield.text == nil)
            
            [cell.textFieldDPPlaceHolder setTag:1000];
            cell.textFieldDPPlaceHolder.text = currentTextfield.text;
        }
        
        
    }
    if (indexPath.row == 5)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellTextView;
            
        }
        
          cell.textViewAboutYou.delegate = self;
        if(profileDict !=NULL){
            
            
            if([[profileDict valueForKey:@"about"] isEqual:@""]){
                
                
                cell.textViewAboutYou.text = textviewText;
                
                
                strAbout =cell.textViewAboutYou.text;
                
//              dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(cell.frame.size.width-20,tableView.frame.size.height)];
//                
//                cell.textViewAboutYou.delegate = self;
                
            }
            
            else{
                if(![[profileDict valueForKey:@"about"] isEqual:strAbout]){
                    
                  
                    if(strAbout == NULL){
                        cell.textViewAboutYou.text = [[profileDict valueForKey:@"about"]mutableCopy];
                        strAbout =cell.textViewAboutYou.text;
//                         dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(cell.frame.size.width-20,tableView.frame.size.height)];
//                        self.aboutTextHeight.constant =dataSize.height;
                    }
                    else{
                         cell.textViewAboutYou.text = strAbout;
//                        dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(cell.frame.size.width-20,tableView.frame.size.height)];
//                        self.aboutTextHeight.constant =dataSize.height-12;
                    }
                }
                else{
                    
                    cell.textViewAboutYou.text = [[profileDict valueForKey:@"about"]mutableCopy];
                    strAbout =cell.textViewAboutYou.text;
                    
                }
               
                
                
              
                
            }
            
            
            
        }
       
        else{
            if(textviewText == nil){
                
                if([strAbout isEqualToString:@""] ||strAbout == nil)
                {
               
                cell.textViewAboutYou.text = @"Write something about yourself here.";
                    cell.textViewAboutYou.scrollEnabled=YES;
                   
                }
                else
                {
                    
                    cell.textViewAboutYou.text =strAbout;
                    dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(cell.frame.size.width-20,tableView.frame.size.height)];
                    self.aboutTextHeight.constant =dataSize.height-12;

                    
                }
                }
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
        
//        yAxis = 31;
//        imageSize =39;
//        space = imageSize / 2;
//        commonHeight = imageSize+15;
//        int imageXPos = 0;
//        int textXPos = 0;
//        if(IS_IPHONE6_Plus){
//            imageXPos = 33;
//            textXPos = 23;
//            commonWidth=29.5;
//        }
//        else if (IS_IPHONE6){
//            imageXPos = 18;
//            textXPos = 8;
//            commonWidth=29.5;
//        }
//        else{
//            imageXPos = 10;
//            textXPos = 0;
//            commonWidth=19.5;
//        }
//        
//        NSString *plusIcon = @"Plus_icon.png";
//        if ([imageNormalArray count] >=1)
//        {
//            for(NSString *strPlus in imageNormalArray)
//            {
//                if([strPlus isEqualToString:@"Plus_icon.png"])
//                    [imageNormalArray removeObject:strPlus];
//            }
//            [imageNormalArray addObject:plusIcon];
//        }
//       
//        
//        UIButton *pushToHobbiesButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
//        for (int i =0; i< [imageNormalArray  count]; i++) {
//            cell.plusIconImageView.hidden = YES;
//            UIImageView *hobbiesImage;
//           
//           
//            
//            if(i <= 4){
//                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+ imageXPos, yAxis, imageSize, imageSize)];
//              
//            }
//            else if(i <= 9){
//                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+ imageXPos, yAxis+imageSize+space, imageSize, imageSize)];
//                          }
//            else if(i <= 14){
//                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+ imageXPos, yAxis+((imageSize+space) * 2), imageSize, imageSize)];
//               
//            }
//            else{
//                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+ imageXPos, yAxis+((imageSize+space) * 3), imageSize, imageSize)];
//              
//            }
//            
//             NSString *image =[imageNormalArray objectAtIndex:i];
//           
//            
//            if([image isEqualToString:@"Plus_icon.png"])
//            {
//                [hobbiesImage setImage:[UIImage imageNamed:image]];
//            }
//            else
//            {
//                image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                [hobbiesImage setImageWithURL:[NSURL URLWithString:image]];
//            }
//            
//            if (image == plusIcon) {
//                hobbiesImage.userInteractionEnabled = YES;
//                pushToHobbiesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//                [hobbiesImage addSubview:pushToHobbiesButton];
//            }
//            
//
//            [cell addSubview:hobbiesImage];
//            [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
//        }
//        
//        for (int i =0; i< [hobbiesNameArray  count]; i++) {
//            
//            NSString *image =[[hobbiesNameArray objectAtIndex:i]uppercaseString];
//            UILabel *hobbiesname;
//            
//            if(i <= 4)
//                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+textXPos, yAxis + imageSize, imageSize + 20, 15)];
//            else if(i <= 9)
//                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+textXPos, yAxis+(imageSize * 2)+space, imageSize + 20, 15)];
//            else if(i <= 14)
//                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+textXPos, yAxis+((imageSize+space) * 2)+imageSize, imageSize + 20, 15)];
//            else
//                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+textXPos, yAxis+((imageSize+space) * 3)+imageSize, imageSize + 20, 15)];
//            
//            [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
//            hobbiesname.textAlignment = NSTextAlignmentCenter;
//            hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255 green:(float)102.0/255 blue:(float)102.0/255 alpha:1.0f];
//            
//            
//            hobbiesname.text = image;
//            [cell addSubview:hobbiesname];
//            hobbiesname.textAlignment = NSTextAlignmentCenter;
//        }
    }
    
    if (indexPath.row == 7)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellEmailPassword;
            
        }
        
        cell.currentpassword.hidden=NO;
        cell.conformationpassword.hidden=NO;
        cell.currentpasswordlbl.text=@"Current password";
        cell.confirmpasswordlbl.hidden =NO;
        cell.passwordlbl.hidden =NO;
        
       
        if(profileDict != NULL)
        {
            NSString *loginType =[profileDict valueForKey:@"type"];
            if([loginType isEqualToString:@"2"])
            {
                 cell.Accounttittlelbl.hidden=YES;


                cell.emailview.hidden =YES;

            }
            else
            { cell.Accounttittlelbl.hidden=NO;
                
                cell.emailview.hidden =NO;
          
            [cell.emailTextField setUserInteractionEnabled:NO];
            cell.emailTextField.text =(emailAddressToRegister==nil)?[profileDict valueForKey:@"email"]:emailAddressToRegister;
             if(emailPasswordToRegister==nil || [emailPasswordToRegister isEqualToString:@""])
             {
                 emailPasswordToRegister=[profileDict valueForKey:@"password"];
                
             }
           emailPasswordToRegister =(emailPasswordToRegister==nil)?[profileDict valueForKey:@"password"]:emailPasswordToRegister;
           //cell.passwordTextField.placeholder  =(emailPasswordToRegister!=nil)?@"Your Current password":emailPasswordToRegister;
            cell.currentpassword.text    =(currentPassword==nil)?@"":@"Your new password";
            cell.conformationpassword.text =(confirmPassword==nil)?@"":@"confirm your new password";
            }

        }
        else if(userDetailsDict.count > 0){

            NSString *loginType =[userDetailsDict valueForKey:@"type"];
           if([loginType isEqualToString:@"1"])
           {
               cell.Accounttittlelbl.hidden=NO;
           }
            else
            {
                 cell.Accounttittlelbl.hidden=NO;
            }
            cell.emailTextField.text =(emailAddressToRegister==0)?[userDetailsDict valueForKey:@"email"]:emailAddressToRegister;
            cell.passwordTextField.text  =(emailPasswordToRegister==0)? @"":emailPasswordToRegister;
            emailAddressToRegister   = cell.emailTextField.text;
         
    
            cell.currentpassword.hidden=YES;
            cell.conformationpassword.hidden=YES;
            cell.currentpasswordlbl.text =@"Password";
            cell.confirmpasswordlbl.hidden =YES;
            cell.passwordlbl.hidden =YES;

            
        }
        else
        {
            
            cell.emailTextField.text = [self getEmail];
            cell.passwordTextField.text = [self getPassword];
            cell.currentpassword.hidden=YES;
            cell.conformationpassword.hidden=YES;
            cell.currentpasswordlbl.text =@"Password";
            cell.confirmpasswordlbl.hidden =YES;
            cell.passwordlbl.hidden=YES;
           
        }
        
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
        if(profileDict != nil)
        {
            cell.notificationTittlelbl.hidden=YES;
        }
        else
        {
            cell.notificationTittlelbl.hidden=NO;
        }
        
       [self notificationMethod];
        
        UISwipeGestureRecognizer *messBtnleftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationmsgBtnSwipLeftAction:)];
        [messBtnleftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
        [cell.messSwitchBtn addGestureRecognizer:messBtnleftRecognizer];
       
        
        UISwipeGestureRecognizer *messBtnrightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationmessBtnSwipRightAction:)];
        [messBtnrightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
        [cell.messSwitchBtn addGestureRecognizer:messBtnrightRecognizer];
       
        UISwipeGestureRecognizer *soundBtnleftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationsoundBtnSwipLeftAction:)];
        [soundBtnleftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
        [cell.SoundSwitchBtn addGestureRecognizer:soundBtnleftRecognizer];
        
        
        UISwipeGestureRecognizer *SoundBtnrightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationsoundBtnSwipRightAction:)];
        [SoundBtnrightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
        [cell.SoundSwitchBtn addGestureRecognizer:SoundBtnrightRecognizer];

        UISwipeGestureRecognizer *VibrationBtnleftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationvibrationBtnSwipLeftAction:)];
        [VibrationBtnleftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
        [cell.vibrationSwitchBtn addGestureRecognizer:VibrationBtnleftRecognizer];
        
        
        UISwipeGestureRecognizer *vibrationBtnrightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationvibrationBtnSwipRightAction:)];
        [vibrationBtnrightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
        [cell.vibrationSwitchBtn addGestureRecognizer:vibrationBtnrightRecognizer];
        
        [cell.vibrationSwitchBtn addTarget:self action:@selector(NotificationbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.SoundSwitchBtn addTarget:self action:@selector(NotificationbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messSwitchBtn addTarget:self action:@selector(NotificationbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    if (indexPath.row == 9)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellTermsOfUse;
            
        }
        if(profileDict !=nil)
        {
            cell.termsOfUse.hidden =YES;
            cell.privacyPolicy.hidden=YES;
        }
        else{
            cell.termsOfUse.hidden =NO;
            cell.privacyPolicy.hidden=NO;
        }
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        cell.layoutConstraintTermsOfUseBtnDependViewHeight.constant =50;
        }
        
       
    }
    if(indexPath.row==10)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellloginTypeView;
        }
        NSString *objloginType =[profileDict valueForKey:@"type"];
        if([objloginType isEqualToString:@"1"])
        {
            cell.logilTypelbl.text =@"You are connect via DoSomething Account";
            cell.loginTypeImg.image=[UIImage imageNamed:@"loginTypeDS"];
        }
        else{
            cell.logilTypelbl.text =@"You are connect via through Facebook";
            cell.loginTypeImg.image=[UIImage imageNamed:@"loginTypeFB"];
        }
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Tablecell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==6)
    {
    yAxis = 31;
    imageSize =39;
    space = imageSize / 2;
    commonHeight = imageSize+15;
    int imageXPos = 0;
    int textXPos = 0;
    if(IS_IPHONE6_Plus){
        imageXPos = 33;
        textXPos = 23;
        commonWidth=29.5;
    }
    else if (IS_IPHONE6){
        imageXPos = 18;
        textXPos = 8;
        commonWidth=29.5;
    }
    else{
        imageXPos = 10;
        textXPos = 0;
        commonWidth=19.5;
    }
    
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
        
        
        
        if(i <= 4){
            hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+ imageXPos, yAxis, imageSize, imageSize)];
            
        }
        else if(i <= 9){
            hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+ imageXPos, yAxis+imageSize+space, imageSize, imageSize)];
        }
        else if(i <= 14){
            hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+ imageXPos, yAxis+((imageSize+space) * 2), imageSize, imageSize)];
            
        }
        else{
            hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+ imageXPos, yAxis+((imageSize+space) * 3), imageSize, imageSize)];
            
        }
        
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
        
        
        [cell addSubview:hobbiesImage];
        [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int i =0; i< [hobbiesNameArray  count]; i++) {
        
        NSString *image =[[hobbiesNameArray objectAtIndex:i]uppercaseString];
        UILabel *hobbiesname;
        
        if(i <= 4)
            hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+textXPos, yAxis + imageSize, imageSize + 20, 15)];
        else if(i <= 9)
            hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+textXPos, yAxis+(imageSize * 2)+space, imageSize + 20, 15)];
        else if(i <= 14)
            hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+textXPos, yAxis+((imageSize+space) * 2)+imageSize, imageSize + 20, 15)];
        else
            hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+textXPos, yAxis+((imageSize+space) * 3)+imageSize, imageSize + 20, 15)];
        
        [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
        hobbiesname.textAlignment = NSTextAlignmentCenter;
        hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255 green:(float)102.0/255 blue:(float)102.0/255 alpha:1.0f];
        
        
        hobbiesname.text = image;
        [cell addSubview:hobbiesname];
        hobbiesname.textAlignment = NSTextAlignmentCenter;
    }
    }
//    if(indexPath.row == 6)
//    {
//            commonWidth = (Tablecell.contentView.frame.size.width - 20) / 14;
//            imageSize = commonWidth * 2;
//
//        }
    
//    if ( indexPath.row ==6)
//    {
//                        imageSize =39;
//                        commonWidth=19.5;
//                        commonHeight = 54;
//        if([imageNormalArray count] < 1)
//            commonHeight= 80;
//        else if([imageNormalArray count] <= 5)
//            commonHeight= commonHeight + 46;
//        else if([imageNormalArray count] <= 10)
//            commonHeight= (commonHeight*2)+46;
//        else if([imageNormalArray count] <= 15)
//            commonHeight= (commonHeight * 3)+48;
//        else if([imageNormalArray count] <= 20)
//            commonHeight= (commonHeight * 4)+52;
//    }
    
    

}

#pragma mark- hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)NotificationmsgBtnSwipLeftAction:(id)sender
{
    
    [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    isNotification_message =@"No";
            
    
}
-(void)NotificationmessBtnSwipRightAction:(id)sender
  {
    
        [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_message =@"Yes";
    
  }


-(void)NotificationsoundBtnSwipLeftAction:(id)sender
{
    
    [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    isNotification_sound =@"No";
    
    
}
-(void)NotificationsoundBtnSwipRightAction:(id)sender
{
    
    [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    isNotification_sound =@"Yes";
    
}
-(void)NotificationvibrationBtnSwipLeftAction:(id)sender
{
    
    [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    isNotification_vibration =@"No";
    
    
}
-(void)NotificationvibrationBtnSwipRightAction:(id)sender
{
    
    [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    isNotification_vibration =@"Yes";
    
}


-(void)NotificationbuttonAction:(UIButton *)sender
{
    
    id button = sender;
    while (![button isKindOfClass:[UITableViewCell class]]) {
        button = [button superview];
    }
    
    NSIndexPath *indexPath;
   
    
    indexPath = [_tableviewProfile indexPathForCell:(UITableViewCell *)button];
    cell = (DSProfileTableViewCell *) [_tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    if([sender tag] == 501){
        if ( [isNotification_message isEqualToString:@"Yes"]) {
            
            [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
             isNotification_message =@"No";
            
        }else{
            
            [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            isNotification_message =@"Yes";
        }

        
    }
    
   else if([sender tag] == 502){
        if ( [isNotification_sound isEqualToString:@"Yes"]) {
            
            [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            isNotification_sound =@"No";
            
        }else{
            
            [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            isNotification_sound =@"Yes";
        }

        
    }
    
   else if([sender tag] == 503)
   {
       if ( [isNotification_vibration isEqualToString:@"Yes"]) {
           
           [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
           isNotification_vibration =@"No";
           
       }else{
           
           [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
           //[self notificationButtonOFFAction:sender];
           isNotification_vibration =@"Yes";
       }
       
       
   }

    
  
    
}


#pragma mark -loadTermsOfUseView

-(IBAction)loadTermsOfUseViewAction:(id)sender
{
    
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
    
    [self.navigationController pushViewController:termViewController animated:YES];
}

#pragma mark -notificationMethod
-(void)notificationMethod
{
    
    NSString * objMsg =[isNotification_message isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[isNotification_sound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[isNotification_vibration isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_message =@"Yes";

        
    }
    if([objSound isEqualToString:@"switch_on"])
    {
        [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_message =@"Yes";
    }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_message =@"Yes";
       
    }
    
    if([objMsg isEqualToString:@"switch_off"])
    {
//        [cell.messSwitchBtn setTintColor:[UIColor redColor]];
//        [cell.messSwitchBtn setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        isNotification_message =@"No";
    }
    if([objSound isEqualToString:@"switch_off"])
    {
        [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        isNotification_message =@"No";
    }
    
    if([objVibration isEqualToString:@"switch_off"])
    {
        [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        isNotification_message =@"No";
    }
    
}


-(void)notificationButtonONAction:(id)sender
{
    [sender setThumbTintColor:[UIColor greenColor]];
    
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setOnTintColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];

}

-(void)notificationButtonOFFAction:(id)sender
{
    [sender setTintColor:[UIColor clearColor]];
    [sender setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [sender setThumbTintColor:[UIColor redColor]];
}


-(void)buttonAction:(UIButton *)sender
{
    
    id button = sender;
    while (![button isKindOfClass:[UITableViewCell class]]) {
        button = [button superview];
    }
    
    NSIndexPath *indexPath;
     NSString *selOptionVal;
    
    indexPath = [_tableviewProfile indexPathForCell:(UITableViewCell *)button];
    cell = (DSProfileTableViewCell *) [_tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    if([sender tag] == 2004){
        selOptionVal = @"male";
        [cell.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       [cell.femaleButton setTitleColor:[UIColor colorWithRed:(161.0/255.0f) green:(161.0/255.0f) blue:(161.0/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        isSelectMale =YES;
        isSelectFemale=NO;
        
    }
    
    if([sender tag] == 2005){
       selOptionVal = @"female";
      
        [cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         [cell.maleButton setTitleColor:[UIColor colorWithRed:(161.0/255.0f) green:(161.0/255.0f) blue:(161.0/255.0f) alpha:1.0f] forState:UIControlStateNormal];
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
    //cell.textViewHeaderLabel.hidden = YES;
    if(textView.tag == 0) {
        if([textView.text isEqualToString:@"Write something about yourself here."])
        {
        textView.text = @"";
        }
        textView.tag = 1;
        strAbout = textView.text;
       
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    cell.textViewAboutYou.scrollEnabled=NO;
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
   
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    
    if([textView.text length] == 0)
    {
        textView.tag = 0;
    }

    strAbout = textView.text;
    
     [self.tableviewProfile scrollToRowAtIndexPath:[self.tableviewProfile indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [self.tableviewProfile beginUpdates];
    [self.tableviewProfile endUpdates];
}
- (void) textViewDidChange:(UITextView *)textView
{
    
    [self.tableviewProfile beginUpdates];
      
    [self.tableviewProfile endUpdates];
    
}

#pragma mark - Camera Action
-(void)selectCamera: (UIButton *)sender

{
    
    imagepickerController = [[UIImagePickerController alloc] init];
    
    imagepickerController.delegate = self;
    
    [imagepickerController setAllowsEditing:YES];
    
    UIAlertController *alert;
    
    if(IS_GREATER_IOS8){
        
        alert = [UIAlertController alertControllerWithTitle:@""
                 
                                                    message:@""
                 
                                             preferredStyle:UIAlertControllerStyleAlert];
        
    }
    
    else{
        
        UIActionSheet *actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",@"") destructiveButtonTitle:NSLocalizedString(@"CAMERA",@"") otherButtonTitles:NSLocalizedString(@"PHOTO LIBRARY",@""), nil];
        
        [actionSheet1 showInView:self.view];
        
        [actionSheet1 sizeToFit];
        
    }
    
    
    
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
    
    if(IS_GREATER_IOS8){
        
        [alert addAction:camera];
        
        [alert addAction:photoRoll];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    switch (buttonIndex) {
            
        case 0:
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                
            {
                
                UIAlertView *altView = [[UIAlertView alloc]initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
                                        
                                                                 message:NSLocalizedString(@"Sorry, you do not have a camera",@"")
                                        
                                                                delegate:nil
                                        
                                                       cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                        
                                                       otherButtonTitles:nil];
                
                [altView show];
                
                return;
                
            }else{
                
                imagepickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:imagepickerController animated:YES completion:nil];
                
            }
            
            break;
            
            
            
        case 1:
            
            
            
            imagepickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagepickerController animated:YES completion:nil];
            
            break;
            
            
            
        default:
            
            break;
            
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    [cell.topViewCell setHidden:NO];
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
    isPick=YES;
    


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
                       password:(currentPassword==nil)?emailPasswordToRegister:currentPassword
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
                        password:(currentPassword==nil)?emailPasswordToRegister:currentPassword
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadUpdateError:)
                                                 name:@"updateprofileLogOut"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableSendButton:)
                                                 name:@"profilesuccess"
                                               object:nil];
    
    
    
   [self updateAPI];
    
    
}
-(void)loadUpdateView:(NSNotification *)notification{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
   // [self showAltermessage:@"Profile Updated Successfully"];
    [COMMON removeLoading];
    
}
-(void)loadUpdateError:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [COMMON removeUserDetails];
    DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
    [self.navigationController pushViewController:objSplashView animated:NO];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=YES;
    appDelegate.SepratorLbl.hidden=YES;
    [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];

}

#pragma mark - saveAction
-(void)saveAction:(id)sender
{
    [self.view endEditing:YES];
    [COMMON LoadIcon:self.tableviewProfile];
    //[customNavigation.saveBtn setUserInteractionEnabled:NO];
//    if(isSave==NO)
//    {
    if(profileDict !=NULL){
        

          strGender = [profileDict valueForKey:@"gender"];
          //strDOB    = (currentTextfield.text !=nil)?currentTextfield.text :[profileDict valueForKey:@"date_of_birth"];

      //  [self dateConverter];
        [self loadValidations];
       // [self loadUpdate];
        
        
        isSave =YES;
       
    }
    else
        [self loadValidations];
   
   
    }

-(void) enableSendButton:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [customNavigation.saveBtn setUserInteractionEnabled:YES];
}


//}
#pragma mark - dateConverter
-(void)dateConverter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormatter dateFromString: strDOB];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateChange = [dateFormatter stringFromDate:date];
   

}
#pragma mark - saveAction
-(void)loadValidations
{
    [COMMON LoadIcon:self.view];
    
   
    strType      = (selectEmail== YES)?@"1":@"2";
    strProfileID = (FBprofileID!=nil)?FBprofileID:@"";
    strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :[profileDict valueForKey:@"date_of_birth"];
    [self dateConverter];

    if(profileDict== NULL)
    {
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
    
     if(profileDict!=nil)
    {
        
       
         if ([emailPasswordToRegister isEqualToString:@""] || emailPasswordToRegister == nil)
        {
            
            [self showAltermessage:@"Enter your Current password"];
            [COMMON removeLoading];
            return;
        }
        
        else if (![[profileDict valueForKey:@"password"] isEqualToString:emailPasswordToRegister])
        {
            
            [self showAltermessage:@"Your password mismatching"];
            [COMMON removeLoading];
            return;
        }
        
        else if([currentPassword isEqualToString:@""])
        {
            if([emailPasswordToRegister isEqualToString:@""])
            {
                [self showAltermessage:@"Enter your current password"];
                [COMMON removeLoading];
                return;
            }
            else if(![confirmPassword isEqualToString:@""] && confirmPassword!=nil)
            {
                [self showAltermessage:@"Enter your New password"];
                [COMMON removeLoading];
                return;
            }
            else
            
            {
                [COMMON removeLoading];
                [self updateAPI];
           
            }
            
        }
       else  if ([confirmPassword isEqualToString:@""] || confirmPassword==nil)
        {
            if([currentPassword isEqualToString:@""])
            {
                [self showAltermessage:@"Enter New password"];
                [COMMON removeLoading];
                return;
            }
            else if (currentPassword!=nil || confirmPassword !=nil)
            {
                if(![currentPassword isEqualToString:confirmPassword])
                [self showAltermessage:@"Password don't match"];
                [COMMON removeLoading];
                return;
                
            }
            else
            {
                [COMMON removeLoading];
                [self updateAPI];
            }
            
        }
        else if (![confirmPassword isEqualToString:@""])
        {
            if([currentPassword isEqualToString:@""] || currentPassword==nil)
            {
                [self showAltermessage:@"Enter New password"];
                [COMMON removeLoading];
                return;
            }
            else
            {
                [COMMON removeLoading];
                [self updateAPI];
            }
        }

        else
         {
           [COMMON removeLoading];
           [self updateAPI];
         }
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
