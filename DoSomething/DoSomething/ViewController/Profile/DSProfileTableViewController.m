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
#import "CustomSoundview.h"
#import <AudioToolbox/AudioToolbox.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define Red_Color   [UIColor colorWithRed:227.0f/255.0f green:64.0f/255.0f blue:81.0f/255.0f alpha:1.0f]

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
    AppDelegate             *appDelegate;
    
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
    NSString * isNotification_match;
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
    CustomSoundview * objCustomSoundView;
    
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
    
    BOOL isclickIconAddBtn;
    NSString * FBImageStr;
    NSString *selectSoundStr;
    NSString *playsoundBundleStr;
    SystemSoundID * soundID;
    UIButton * blueCirecleBtn;
    NSString *plusIcon;
    BOOL isRemoveprofileimg;
    NSMutableDictionary *fbUserDetailsDict;
    NSString *firstName,*lastName,*email,*dob,*gender,*profileID,*password;
    UIImage *fbProfileImage;
    
    BOOL is_profileImgediting;
    
    BOOL isTapGesture;
    
    
    
    /* -------------------  User Profile Images  ------------------- */
    
    
    NSMutableArray *userProfileImageArray;
    
    NSInteger currentImageIndex;
    
    NSInteger selectedImageIndex;
    
    NSInteger totalImageCount;
    
    BOOL isNewUser;
    
    BOOL isSelectIndex;
    
    
}

@end


@implementation DSProfileTableViewController
@synthesize  profileData1,textviewText, placeHolderArray,FBprofileID;
@synthesize userDetailsDict,emailAddressToRegister,emailPasswordToRegister,selectEmail,currentPassword,confirmPassword,profileScrollView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.WalAlterview.hidden =YES;
    
    NSString * Firstlogin=[[NSUserDefaults standardUserDefaults]valueForKey:FirstCreateProfile];
    
    
    if([Firstlogin isEqualToString:@"Yes"])
    {
        //self.WalAlterview.hidden =NO;
        [self GerenalWalkAlterviewCreateAccount];
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:FirstCreateProfile];
    }
    
    
    Regpassword=emailPasswordToRegister;
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[_tableviewProfile class]];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    
    locationManager                 = [[CLLocationManager alloc] init];
    
    locationManager.delegate        = self;
    
    objWebService = [[DSWebservice alloc]init];
    
    deviceUdid = [OpenUDID value];
    
    isPick=NO;
    
    isPageControl=NO;
    
    isLoadData=NO;
    
    [self setInitialProfileArray];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInvalidSessionAlert:)
                                                 name:@"InvalidSession"
                                               object:nil];
    
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
    
    
    
    infoArray=[[NSMutableArray alloc]initWithObjects:@"profile_noimg",@"profile_noimg",@"profile_noimg", nil];
    
    if(!isLoadData){
        [self initializeArray];
        [self profileImageDisplayMethod];
        if (profileDict== nil)
        {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:HobbiesArray];
            
        }
        
        isLoadData = YES;
    }
    else if(isLoadData == YES && profileDict ==NULL)
    {
        
        hobbiesMainArray = [[[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray]mutableCopy];
        
        imageNormalArray = [[hobbiesMainArray valueForKey:@"image"]mutableCopy];
        
        hobbiesNameArray = [hobbiesMainArray valueForKey:@"name"];
        
        
        
        strInterestHobbies = [[hobbiesMainArray valueForKey:@"hobbies_id"] componentsJoinedByString:@","];
        
    }
    [self selectitemMethod];
    
    [_tableviewProfile reloadData];
    
    [self loadNavigation];
    
    
    if(profileDict==NULL)
    {
        [customNavigation.saveBtn setTitle:@"Create" forState:UIControlStateNormal];
    }
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self CustomAlterview];
    [self CustomSoundview];
}
-(void)viewDidLayoutSubviews{
    
    if(IS_GREATER_IOS8)
    {
        
    }
    else
    {
        if(is_profileImgediting== YES)
        {
            
            NSTimer * loadscrollview=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateprofileimageloadstop)userInfo:nil repeats:NO];
            
        }
        [self.view layoutIfNeeded];
        
        self.tableViewHeightConstraint.constant=self.tableviewProfile.contentSize.height+350;
        [profileScrollView setContentSize:CGSizeMake(0, self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height+self.tableViewHeightConstraint.constant-(self.profiletableheight.constant+50))];
        NSLog(@"tableheight=%f", self.tableViewHeightConstraint.constant);
    }
}
-(void)updateprofileimageloadstop
{
    [COMMON removeLoading];
}
-(void)loadNavigation{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
        self.layoutConstraintTableViewYPos.constant= 20;
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 415, 83);
        self.layoutConstraintTableViewYPos.constant= 20;
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
    //     [self getUserCurrenLocation];
    NSString * strsessionID =[profileDict valueForKey:@"SessionId"];
    loginUserSessionID = strsessionID;
    
    
    
    
    if(profileDict != NULL)
    {
        [self initializeArrayProfile];
        [customNavigation.buttonBack setHidden:YES];
        [customNavigation.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        
        interstAndHobbiesArray = [[profileDict valueForKey:@"hobbieslist"]mutableCopy];
        
        hobbiesNameArray       =[[interstAndHobbiesArray valueForKey:@"name"]mutableCopy];
        
        
        imageNormalArray     = [[interstAndHobbiesArray valueForKey:@"image"]mutableCopy];
        
        [self.view layoutIfNeeded];
        
        self.tableViewHeightConstraint.constant=(IS_IPHONE6_Plus||IS_IPHONE6)?50:50;
        
        
        
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedItemCategoryID"];
    
    isNotification_message = @"Yes";
    isNotification_match = @"Yes";
    isNotification_sound =@"Yes";
    
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

-(void)loadInvalidSessionAlert:(NSNotification *)notification
{
    self.WalAlterview.hidden =YES;
    self.window.hidden=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [COMMON removeUserDetails];
    
    DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
    [self.navigationController pushViewController:objSplashView animated:NO];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=YES;
    appDelegate.SepratorLbl.hidden=YES;
    
    
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

//#pragma mark - scroll
//-(void)profileScroll{
//
//    self.scrView.pagingEnabled=YES;
//    self.scrView.delegate=self;
//    [self.scrView setShowsHorizontalScrollIndicator:NO];
//
//    int spacing = 80;
//    int i;
//
//    for(i = 0; i < 3; i++)
//    {
//        NSData * profileData = [profileDataArray objectAtIndex:i];
//        NSString *image     = [profileDataArray objectAtIndex:i];
//        if(IS_IPHONE6)
//        {
//            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing+30, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
//        }
//        else if(IS_IPHONE6_Plus)
//        {
//            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing+50, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
//        }
//
//        else
//        {
//            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.scrView.frame.size.width) + spacing, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
//        }
//        [userProfileImage setTag:i+100];
//        if([profileData length] == 0){
//            [userProfileImage setImage:[UIImage imageNamed:@"profile_noimg"]];
//            if(i==0){
//                [cell.topViewCell setHidden:YES];
//                self.scrView.scrollEnabled = NO;
//            }
//
//        }
//        else{
//
//            if([[profileDataArray objectAtIndex:i]isKindOfClass:[NSData class]])
//               [userProfileImage setImage:[UIImage imageWithData:profileData]];
//            else
//               [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
//
//            if(i==2){
//                [cell.imageAddButton setHidden:YES];
//            }
//            userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height / 2;
//            userProfileImage.layer.masksToBounds = YES;
//            [userProfileImage setUserInteractionEnabled:YES];
//
//            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateProfileImageAction)];
//            [singleTap setNumberOfTapsRequired:1];
//            [userProfileImage addGestureRecognizer:singleTap];
//            [self.scrView addSubview:userProfileImage];
//            [self.scrView setContentSize:CGSizeMake(self.scrView.frame.size.width*(i+1), 150)];
//
//            [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
//            [cameraIcon setHidden:YES];
//
//            [cell.topViewCell setHidden:NO];
//            self.scrView.scrollEnabled = YES;
//        }
//
//
//    }
//
//    if(CurrentImage == 0)
//    {
//
//        [self.scrView setContentOffset:CGPointMake(0, 0)animated:NO];
//        if(profileDict!=nil)
//        {
//           [self pageScrollView];
//        }
//    }
//    else if(CurrentImage == 1)
//    {
//        if(IS_IPHONE6)
//        {
//            [self.scrView setContentOffset:CGPointMake(1.95*self.profileImageView.frame.size.width - 25  , 0)animated:NO];
//        }
//        else  if(IS_IPHONE6_Plus)
//        {
//            [self.scrView setContentOffset:CGPointMake(1.95*self.profileImageView.frame.size.width - 25  , 0)animated:NO];
//        }
//
//        else
//        {
//            [self.scrView setContentOffset:CGPointMake(2.3*self.profileImageView.frame.size.width, 0)animated:NO];
//        }
//         [self pageScrollView];
//    }
//    else if(CurrentImage == 2)
//    {
//        if(IS_IPHONE6)
//        {
//            [self.scrView setContentOffset:CGPointMake(3.65*self.profileImageView.frame.size.width - 15, 0)animated:NO];
//        }
//        else  if(IS_IPHONE6_Plus)
//        {
//            [self.scrView setContentOffset:CGPointMake(3.65*self.profileImageView.frame.size.width -15 , 0)animated:NO];
//        }
//
//        else
//        {
//            [self.scrView setContentOffset:CGPointMake((4.6*self.profileImageView.frame.size.width), 0)animated:NO];
//        }
//         [cell.imageAddButton setHidden:YES];
//         [self pageScrollView];
//    }
//}
-(void) pageScrollView{
    
    xslider=0;
    pgDtView=[[UIView alloc]init];
    pgDtView.backgroundColor=[UIColor clearColor];
    pageImageView =[[UIImageView alloc]init];
    profileImagePageControl.numberOfPages = totalImageCount + 1;
    if(infoArray.count > 3)
    {
        [cell.imageAddButton setHidden:NO];
    }
    
    for(int i=0;i<profileImagePageControl.numberOfPages;i++)
    {
        blkdot=[[UIImageView alloc]init];
        
        [blkdot setFrame:CGRectMake(i*18, 0, 8, 8 )];
        [blkdot setImage:[UIImage imageNamed:@"dot_normal"]];
        [pgDtView addSubview:blkdot];
        [pageImageView setImage:[UIImage imageNamed:@"dot_active_red"]];
        [pageImageView setFrame:CGRectMake(0, 0, 8, 8)];
        
        [pgDtView addSubview:pageImageView];
        [cell.topViewCell addSubview:pgDtView];
        
        if(IS_IPHONE6) {
            
            if( i ==1)
            {
                [pgDtView setFrame:CGRectMake(30, -5, profileImagePageControl.numberOfPages*18, 10)];
                //                    if(is_photoaddImg==YES)
                //                    {
                //                        [pageImageView setFrame:CGRectMake(i*18, 0, 8, 8)];
                //                    }
                //                    else
                //                    {
                //                        [pageImageView setFrame:CGRectMake(0, 0, 8, 8)];
                //                    }
            }
            else if(i ==2)
            {
                [pgDtView setFrame:CGRectMake(20, -5, profileImagePageControl.numberOfPages*18, 10)];
                //[pageImageView setFrame:CGRectMake(i*18, 0, 8, 8)];
            }
            
        }
        else if(IS_IPHONE6_Plus) {
            
            if( i ==1)
            {
                [pgDtView setFrame:CGRectMake(30, -5, profileImagePageControl.numberOfPages*18, 10)];
            }
            else if(i ==2)
            {
                [pgDtView setFrame:CGRectMake(20, -5, profileImagePageControl.numberOfPages*18, 10)];
                
            }
            
        }
        else
        {
            if( i ==1)
            {
                [pgDtView setFrame:CGRectMake(30, -5, profileImagePageControl.numberOfPages*18, 10)];
            }
            else if(i ==2)
            {
                [pgDtView setFrame:CGRectMake(20, -5, profileImagePageControl.numberOfPages*18, 10)];
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    isPageControl=YES;
    [cell.topViewCell addSubview:pgDtView];
}

- (IBAction)pageChanged:(id)sender {
    
    
    CGFloat x = profileImagePageControl.currentPage * self.scrView.frame.size.width;
    NSLog(@"pagenation=%f",x);
    [self.scrView setContentOffset:CGPointMake(x, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidths = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidths;
    NSInteger page = lround(fractionalPage);
    profileImagePageControl.currentPage = page;
    [pageImageView setFrame:CGRectMake(page*18, 0, 8, 8)];
    
    isTapping=NO;
    scrolldragging=@"YES";
    //    if([FirstSignin isEqualToString:@"FirstSiginProfile"])
    //    {
    //        //self.WalAlterview.hidden =NO;
    //        [self GerenalWalkAlterviewSign];
    //        [[NSUserDefaults standardUserDefaults]removeObjectForKey:FistSiginprofile];
    //    }
    
    
    //     CurrentImage = scrollView.contentOffset.x / scrollView.frame.size.width;
    //
    //        if (scrollView==self.scrView) {    }
    //        pull=@"";
    //        jslider = scrollView.contentOffset.x / scrollView.frame.size.width;
    //        [self.scrView setNeedsDisplay];
    //        profileImagePageControl.currentPage=selectedImageIndex;
    
    //    NSString * FirstSignin=[[NSUserDefaults standardUserDefaults]valueForKey:FistSiginprofile];
    
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
    
    [locationManager stopUpdatingLocation];
    
    NSString *savedLatitude =  [[NSUserDefaults standardUserDefaults]valueForKey:CurrentLatitude];
    NSString *savedLongitude = [[NSUserDefaults standardUserDefaults]valueForKey:CurrentLongitude];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    NSLog(@"savedLatitude & saved Longitude = %@ & %@",savedLatitude,savedLongitude);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if((![currentLatitude isEqualToString:savedLatitude] || ![currentLongitude isEqualToString:savedLongitude]) && (currentLongitude !=nil || currentLatitude != nil))
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
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    if(deviceToken == nil)
        deviceToken = @"";
    if(profileDict != NULL)
    {
        [objWebService locationUpdate:LocationUpdate_API
                            sessionid:[COMMON getSessionID]
                             latitude:currentLatitude
                            longitude:currentLongitude
                          deviceToken:deviceToken
                             pushType:push_type
                              success:^(AFHTTPRequestOperation *operation, id responseObject){
                                  NSLog(@"responseObject = %@",responseObject);
                                  [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:CurrentLatitude];
                                  [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:CurrentLongitude];
                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, id error) {
                                  
                              }];
    }
    
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
    
    if([currentTextfield.text length] > 0  && ![currentTextfield.text isEqualToString:@"DD/MM/YYYY"]){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        
        dateFromString = [dateFormatter dateFromString:currentTextfield.text];
        if(dateFromString !=nil)
        {
            [datePicker setDate:dateFromString animated:NO];
        }
        
        //[datePicker setDate:dateFromString animated:NO];
        
    }
    
    [currentTextfield setInputView:datePicker];
    
    currentTextfield.tintColor=[UIColor clearColor];
}


- (IBAction)DateSelectionAction:(UIDatePicker *)sender
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
        //[textField resignFirstResponder];
        
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
        [formatter setDateFormat:@"dd/MM/yyyy"];
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
    
    isclickIconAddBtn = YES;
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
    [objCustomAlterview.btnYes addTarget:self action:@selector(alertPressYes:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.btnNo addTarget:self action:@selector(alertPressNo:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.alertCancelButton addTarget:self action:@selector(alertPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    objCustomAlterview.mainalterviewheight.constant=0;
    
    
    
    [self.view addSubview:objCustomAlterview.view];
}

- (IBAction)alertPressNo:(id)sender {
    
    objCustomAlterview. alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    objCustomAlterview.view .hidden  = YES;
    
}
-(IBAction)alertPressYes:(id)sender
{
    objCustomAlterview. alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    objCustomAlterview.view .hidden  = YES;
    [self loadRegister];
}
-(IBAction)alertPressCancel:(id)sender
{
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
    objCustomAlterview.alertCancelButton.hidden=NO;
    //[objCustomAlterview.btnYes setTitle:@"Create" forState:UIControlStateNormal];
    //[objCustomAlterview.btnNo setTitle:@"No" forState:UIControlStateNormal];
    objCustomAlterview.alertMsgLabel.text = msg;
    objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    objCustomAlterview.alertMsgLabel.numberOfLines = 2;
    [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];
    
}

-(void)showAccountCreateAltermessage:(NSString*)msg
{
    
    objCustomAlterview.view.hidden =NO;
    //objCustomAlterview.view.alpha=0.0;
    objCustomAlterview.alertBgView.hidden = NO;
    objCustomAlterview.alertMainBgView.hidden = NO;
    objCustomAlterview.alertCancelButton.hidden = NO;
    objCustomAlterview.btnYes.hidden = NO;
    objCustomAlterview.btnNo.hidden = NO;
    objCustomAlterview.alertCancelButton.hidden=YES;
    [objCustomAlterview.btnYes setTitle:@"Create" forState:UIControlStateNormal];
    [objCustomAlterview.btnNo setTitle:@"No" forState:UIControlStateNormal];
    objCustomAlterview.alertMsgLabel.text = msg;
    objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    objCustomAlterview.alertMsgLabel.numberOfLines = 2;
    [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];
    
}
#pragma CustomSoundView
-(void)CustomSoundview
{
    objCustomSoundView = [[CustomSoundview alloc] initWithNibName:@"CustomSoundview" bundle:nil];
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
        objCustomSoundView.view.frame = CGRectMake(self.view.frame.origin.x, customNavigation.view.frame.origin.y+ customNavigation.view.frame.size.height+40, CGRectGetWidth(self.view.frame), self.view.frame.size.height-110);
    }
    else
    {
        objCustomSoundView.view.frame = CGRectMake(self.view.frame.origin.x, customNavigation.view.frame.origin.y+ customNavigation.view.frame.size.height+10, CGRectGetWidth(self.view.frame), self.view.frame.size.height-50);
    }
    // [objCustomSoundview.alertBgView setHidden:YES];
    [objCustomSoundView.soundmenuView setHidden:YES];
    
    [objCustomSoundView.soundMenuCancelBtn addTarget:self action:@selector(DidclickSoundMenuCancel:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomSoundView.soundmenuOkBtn addTarget:self action:@selector(didClickSoundOk:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
        objCustomSoundView.soundmenutrailing.constant=130;
    }
    
    [self.view addSubview:objCustomSoundView.view];
    
}
-(IBAction)DidclickSoundMenuCancel:(id)sender
{
    
    objCustomSoundView.view.hidden=YES;
    objCustomSoundView.soundmenuView.hidden=YES;
    playsoundBundleStr=objCustomSoundView.urlString;
    soundID =objCustomSoundView.selectSoundID;
    
    if(soundID != 0 || soundID != NULL)
    {
        
        AudioServicesRemoveSystemSoundCompletion (*(soundID));
        
        AudioServicesDisposeSystemSoundID(*(soundID));
    }
}
-(IBAction)didClickSoundOk:(id)sender
{
    
    selectSoundStr=objCustomSoundView.selectSoundStr;
    NSLog(@"Soundstring=%@",selectSoundStr);
    //[self loadUpdateNotificationAPI];
    playsoundBundleStr=objCustomSoundView.urlString;
    soundID =objCustomSoundView.selectSoundID
    ;
    
    if(soundID != 0 || soundID != NULL)
    {
        
        AudioServicesRemoveSystemSoundCompletion (*(soundID));
        
        AudioServicesDisposeSystemSoundID(*(soundID));
    }
    
    objCustomSoundView.view.hidden=YES;
    objCustomSoundView.soundmenuView.hidden=YES;
    
    
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
        if([strAbout isEqualToString:@""]|| dataSize.height ==20){
            return 40;
        }
        else
        {
            
            
            self.aboutTextHeight.constant=dataSize.height-10;
            
            return  dataSize.height-10;
        }
        
    }
    
    if ( indexPath.row ==6)
    {
        //imageSize =39;
        //commonWidth=19.5;
        //commonHeight = 54;
        if([imageNormalArray count] < 1)
            return 80;
        else if([imageNormalArray count] <=5)
            return 100;
        
        else if([imageNormalArray count] <= 10)
            return  154;
        
        else if([imageNormalArray count] <= 15)
            return 210;
        
        else if([imageNormalArray count] <= 20)
            return  268;
    }
    
    
    if ( indexPath.row == 7) {
        
        
        if(profileDict!=nil)
        {
            NSString *objlogintype=[profileDict valueForKey:@"showpassword"];
            if([objlogintype isEqual:@"no"])
                
            {
                return 0;
            }
            else
            {
                return 180;
            }
            
        }
        else if (userDetailsDict.count > 0)
        {
            
            return 80;
            
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
            return 50;
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
        profileImagePageControl.pageIndicatorTintColor = [UIColor clearColor];
        profileImagePageControl.currentPageIndicatorTintColor = [UIColor clearColor];
        
        cameraIcon=[UIButton buttonWithType:UIButtonTypeCustom];
        if(IS_IPHONE6)
        {
            
            [cameraIcon setFrame:CGRectMake(cell.contentView.center.x+5,cell.contentView.frame.size.height-36,37,37)];
        }
        else  if(IS_IPHONE6_Plus)
        {
            [cameraIcon setFrame:CGRectMake(cell.contentView.center.x+25,cell.contentView.frame.size.height-36,37,37)];
        }
        
        else{
            [cameraIcon setFrame:CGRectMake(cell.contentView.center.x-22,cell.contentView.frame.size.height-36,37,37)];
        }
        [cameraIcon addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIImage *cameraIconImg = [UIImage imageNamed:@"camera_icon"];
        //        [cameraIcon setImage:cameraIconImg forState:UIControlStateNormal];
        //        [cameraIcon setTag:101];
        //        [cell addSubview:cameraIcon];
        
        [cell.addnextprofileimageimage addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        [cameraIcon setHidden:NO];
        
        [self setUserProfileImages];
        
        
        if(totalImageCount == 2)
        {
            cell.addnextprofileimageimage.hidden = YES;
            profileImagePageControl.hidden = NO;
        }
        else if(totalImageCount == 1)
        {
            cell.addnextprofileimageimage.hidden = NO;
            profileImagePageControl.hidden = NO;
        }
        else
        {
            cell.addnextprofileimageimage.hidden = NO;
            profileImagePageControl.hidden = YES;
        }
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
            cell.firstnameTxt.textColor =[UIColor darkGrayColor];
            cell.lastNameTxt.textColor = [UIColor darkGrayColor];
            cell.firstaftersepratorlbl.hidden =YES;
            [cell.firstnameTxt setEnabled:NO];
            [cell.lastNameTxt setEnabled:NO];
        }
        else if(userDetailsDict.count > 0){
            
            cell.firstnameTxt.text =(FirstName==0)?[userDetailsDict valueForKey:@"first_name"]:FirstName;
            cell.lastNameTxt.text  =(LastName==0)? [userDetailsDict valueForKey:@"last_name"]:LastName;
            FirstName = cell.firstnameTxt.text;
            LastName  = cell.lastNameTxt.text;
            cell.firstnameTxt.textColor =[UIColor darkGrayColor];
            cell.lastNameTxt.textColor = [UIColor darkGrayColor];
            cell.firstaftersepratorlbl.hidden =YES;
            [cell.firstnameTxt setEnabled:NO];
            [cell.lastNameTxt setEnabled:NO];
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
                    [cell.femaleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                else if([[userDetailsDict valueForKey:@"gender"]isEqual:@"female"]){
                    [cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    strGender=[userDetailsDict valueForKey:@"gender"];
                    [cell.maleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    
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
                        cell.textFieldDPPlaceHolder.text = @"DD/MM/YYYY";
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
            
            NSString *datestr= [userDetailsDict valueForKey:@"birthday"];
            if(datestr!=nil ){
                
                
                if(currentTextfield.text == NULL){
                    cell.textFieldDPPlaceHolder.text =[userDetailsDict valueForKey:@"birthday"];
                    NSString *datestr=[userDetailsDict valueForKey:@"birthday"];
                    currentTextfield.text=cell.textFieldDPPlaceHolder.text;
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"dd/mm/yyyy"];
                    NSDate *date = [dateFormat dateFromString:datestr];
                    dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    dateChange = [dateFormat stringFromDate:date];
                    NSLog(@"%@",dateChange);
                    
                    strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :dateChange;
                    [cell.textFieldDPPlaceHolder setTag:1000];
                    
                }
                else{
                    [cell.textFieldDPPlaceHolder setTag:1000];
                    cell.textFieldDPPlaceHolder.text = currentTextfield.text;
                }
            }
            else{
                if(currentTextfield.text == NULL){
                    cell.textFieldDPPlaceHolder.text =[userDetailsDict valueForKey:@"birthday"];
                    
                    
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
                
                
                
                
            }
            
            else{
                if(![[profileDict valueForKey:@"about"] isEqual:strAbout]){
                    
                    
                    if(strAbout == NULL){
                        cell.textViewAboutYou.text = [[profileDict valueForKey:@"about"]mutableCopy];
                        strAbout =cell.textViewAboutYou.text;
                        dataSize = [COMMON getControlHeight:strAbout withFontName:@"Patron-Regular" ofSize:14.0 withSize:CGSizeMake(tableView.frame.size.width-20,tableView.frame.size.height)];
                        
                        
                    }
                    else{
                        cell.textViewAboutYou.text = strAbout;
                        
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
        
        plusIcon = @"Plus_icon.png";
        
        if ([imageNormalArray count] >=1)
        {
            for(NSString *strPlus in imageNormalArray)
            {
                if([strPlus isEqualToString:@"Plus_icon.png"])
                    [imageNormalArray removeObject:strPlus];
                
            }
            [imageNormalArray addObject:plusIcon];
            
        }
        
    }
    
    if (indexPath.row == 7)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellEmailPassword;
            
        }
        
    }
    if (indexPath.row == 8)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellSwitchOn;
            
        }
        
        
    }
    
    if (indexPath.row == 9)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellTermsOfUse;
            
        }
        
    }
    if(indexPath.row==10)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellloginTypeView;
        }
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(IS_GREATER_IOS8)
    {
        [self settableviewheight];
        
    }
    else
    {
        [self viewDidLayoutSubviews];
    }
    
    
    
    return cell;
    
}
-(void)settableviewheight{
    
    [self.tableviewProfile setScrollEnabled:NO];
    
    if(IS_GREATER_IOS8)
    {
        self.tableViewHeightConstraint.constant=(IS_IPHONE6|| IS_IPHONE6_Plus)?self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height+50:self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height-10;
    }
    
    
    if(profileDict != NULL)
    {
        if(IS_IPHONE6 || IS_IPHONE6_Plus)
        {
            [profileScrollView setContentSize:CGSizeMake(0, self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height+self.tableViewHeightConstraint.constant-(self.profiletableheight.constant+130))];
        }
        else
        {
            
            [profileScrollView setContentSize:CGSizeMake(0, self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height+self.tableViewHeightConstraint.constant-(self.profiletableheight.constant+55))];
            
        }
    }
    else
    {
        if(IS_IPHONE6 || IS_IPHONE6_Plus)
        {
            [profileScrollView setContentSize:CGSizeMake(0, self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height+self.tableViewHeightConstraint.constant-(self.profiletableheight.constant+150))];
        }
        else
        {
            if(IS_GREATER_IOS8)
            {
                [profileScrollView setContentSize:CGSizeMake(0, self.tableviewProfile.frame.origin.y + self.tableviewProfile.contentSize.height+self.tableViewHeightConstraint.constant-(self.profiletableheight.constant+110))];
            }
            else{
                [self viewDidLayoutSubviews];
                
                
            }
            
        }
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Tablecell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row==6)
    {
        yAxis = 31;
        imageSize =39;
        space = imageSize / 2;
        //commonHeight = imageSize+15;
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
        
        
        
        UIButton *pushToHobbiesButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
        for (int i =0; i< [imageNormalArray  count]; i++) {
            cell.plusIconImageView.hidden = YES;
            UIImageView *hobbiesImage;
            UILabel *hobbiesname;
            NSString *imageName;
            
            if([hobbiesNameArray count] > i)
            {
                imageName =[[hobbiesNameArray objectAtIndex:i]uppercaseString];
            }
            
            
            if(i <= 4){
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+ imageXPos, yAxis, imageSize, imageSize)];
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+textXPos, yAxis + imageSize, imageSize + 20, 15)];
            }
            else if(i <= 9){
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+ imageXPos, yAxis+imageSize+space, imageSize, imageSize)];
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+textXPos, yAxis+(imageSize * 2)+space, imageSize + 20, 15)];
            }
            else if(i <= 14){
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+ imageXPos, yAxis+((imageSize+space) * 2), imageSize, imageSize)];
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+textXPos, yAxis+((imageSize+space) * 2)+imageSize, imageSize + 20, 15)];
            }
            else{
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+ imageXPos, yAxis+((imageSize+space) * 3), imageSize, imageSize)];
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+textXPos, yAxis+((imageSize+space) * 3)+imageSize, imageSize + 20, 15)];
            }
            
            NSString *image =[imageNormalArray objectAtIndex:i];
            
            [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255 green:(float)102.0/255 blue:(float)102.0/255 alpha:1.0f];
            
            
            
            
            if([image isEqualToString:@"Plus_icon.png"])
            {
                [hobbiesImage setImage:[UIImage imageNamed:image]];
            }
            else
            {
                image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //                 downloadImageFromUrl(image,hobbiesImage);
                [hobbiesImage setImageWithURL:[NSURL URLWithString:image]];
            }
            
            if (image == plusIcon) {
                hobbiesImage.userInteractionEnabled = YES;
                pushToHobbiesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [hobbiesImage addSubview:pushToHobbiesButton];
            }
            
            
            [cell addSubview:hobbiesImage];
            [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
            hobbiesname.text = imageName;
            [cell addSubview:hobbiesname];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
        }
        
        
        
    }
    
    if(indexPath.row == 7)
    {
        cell.currentpassword.hidden=NO;
        cell.conformationpassword.hidden=NO;
        cell.currentpasswordlbl.text=@"Current password";
        cell.confirmpasswordlbl.hidden =NO;
        cell.passwordlbl.hidden =NO;
        cell.passwordTextField.hidden =NO;
        cell.currentpasswordlbl.hidden=NO;
        
        
        if(profileDict != NULL)
        {
            NSString *loginType =[profileDict valueForKey:@"showpassword"];
            if([loginType isEqualToString:@"no"])
            {
                cell.Accounttittlelbl.hidden=YES;
                
                
                cell.emailview.hidden =YES;
                
            }
            else
            {
                cell.Accounttittlelbl.hidden=NO;
                
                cell.emailview.hidden =NO;
                
                [cell.emailTextField setUserInteractionEnabled:NO];
                cell.emailTextField.text =(emailAddressToRegister==nil)?[profileDict valueForKey:@"email"]:emailAddressToRegister;
                cell.emailTextField.textColor =[UIColor darkGrayColor];
                if(emailPasswordToRegister==nil || [emailPasswordToRegister isEqualToString:@""])
                {
                    emailPasswordToRegister=[profileDict valueForKey:@"password"];
                    
                }
                emailPasswordToRegister =(emailPasswordToRegister==nil)?[profileDict valueForKey:@"password"]:emailPasswordToRegister;
                
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
            cell.emailTextField.textColor =[UIColor darkGrayColor];
            cell.passwordTextField.text  =(emailPasswordToRegister==0)? @"":emailPasswordToRegister;
            emailAddressToRegister   = cell.emailTextField.text;
            
            cell.passwordTextField.hidden =YES;
            cell.currentpassword.hidden=YES;
            cell.conformationpassword.hidden=YES;
            cell.currentpasswordlbl.hidden=YES;
            
            cell.confirmpasswordlbl.hidden =YES;
            cell.passwordlbl.hidden =YES;
            [cell.emailTextField setEnabled:NO];
            if (IS_IPHONE6 ||IS_IPHONE6_Plus){
                //cell.layoutConstraintAccLabelYPos.constant =42;
                cell.layoutConstraintEmailPassViewHeight.constant =40;
            }
            else
            {
                cell.layoutConstraintEmailPassViewHeight.constant =40;
            }
            
            
        }
        else
        {
            cell.layoutConstraintEmailPassViewHeight.constant =80;
            cell.emailTextField.text = [self getEmail];
            cell.passwordTextField.text = [self getPassword];
            cell.currentpassword.hidden=YES;
            cell.conformationpassword.hidden=YES;
            cell.currentpasswordlbl.text =@"Password";
            cell.confirmpasswordlbl.hidden =YES;
            cell.passwordlbl.hidden=YES;
            
            
        }
        
        
    }
    if(indexPath.row ==8)
    {
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
        [cell.SoundviewDisplay addTarget:self action:@selector(displaySoundmenuList:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(indexPath.row ==9)
    {
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
        NSString *objloginType =[profileDict valueForKey:@"registervia"];
        if([objloginType isEqualToString:@"dosomething"])
        {
            cell.logilTypelbl.text =@"You are connected via DoSomething Account";
            
            if(IS_IPHONE6_Plus)
            {
                self.TypeImgexposition.constant=68;
            }
            else
            {
                self.TypeImgexposition.constant=(IS_IPHONE6)?50:20;
            }
            cell.loginTypeImg.image=[UIImage imageNamed:@"loginTypeDS"];
        }
        else{
            cell.logilTypelbl.text =@"You are connected via Facebook";
            if(IS_IPHONE6_Plus)
            {
                self.TypeImgexposition.constant=100;
            }
            else
            {
                self.TypeImgexposition.constant=(IS_IPHONE6||IS_IPHONE6_Plus)?75:55;
            }
            
            cell.loginTypeImg.image=[UIImage imageNamed:@"loginTypeFB"];
        }
        
    }
    
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
    objCustomSoundView.view.hidden=NO;
    objCustomSoundView.soundmenuView.hidden=NO;
    [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    isNotification_sound =@"Yes";
    
}
-(void)NotificationvibrationBtnSwipLeftAction:(id)sender
{
    
    [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    isNotification_match =@"No";
    
    
}
-(void)NotificationvibrationBtnSwipRightAction:(id)sender
{
    
    [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
    isNotification_match =@"Yes";
    
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
            
            objCustomSoundView.view.hidden=NO;
            objCustomSoundView.soundmenuView.hidden=NO;
            [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            isNotification_sound =@"Yes";
        }
        
        
    }
    
    else if([sender tag] == 503)
    {
        if ( [isNotification_match isEqualToString:@"Yes"]) {
            
            [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            isNotification_match =@"No";
            
        }else{
            
            [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
            //[self notificationButtonOFFAction:sender];
            isNotification_match =@"Yes";
        }
        
        
    }
    
}


#pragma mark -loadTermsOfUseView

-(IBAction)loadTermsOfUseViewAction:(id)sender
{
    
    DSTermsViewController* termViewController = [[DSTermsViewController alloc] init];
    //termViewController.policytypeofContent =@"Term";
    [self.navigationController pushViewController:termViewController animated:YES];
}

#pragma mark -notificationMethod
-(void)notificationMethod
{
    
    NSString * objMsg =[isNotification_message isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objSound =[isNotification_sound isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    NSString * objVibration =[isNotification_match isEqualToString:@"Yes"]? @"switch_on":@"switch_off";
    
    if([objMsg isEqualToString:@"switch_on"])
    {
        [cell.messSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_message =@"Yes";
        
        
    }
    if([objSound isEqualToString:@"switch_on"])
    {
        [cell.SoundSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_sound =@"Yes";
    }
    
    if([objVibration isEqualToString:@"switch_on"])
    {
        [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isNotification_match =@"Yes";
        
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
        isNotification_sound =@"No";
    }
    
    if([objVibration isEqualToString:@"switch_off"])
    {
        [cell.vibrationSwitchBtn setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        isNotification_match =@"No";
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
    
    //[self.tableviewProfile scrollToRowAtIndexPath:[self.tableviewProfile indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [self.tableviewProfile beginUpdates];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableviewProfile reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self performSelector:@selector(settableviewheight) withObject:nil afterDelay:0.2];
    [self.tableviewProfile endUpdates];
    
    
    
}
- (void) textViewDidChange:(UITextView *)textView
{
    
    //    [self.tableviewProfile beginUpdates];
    //
    //    [self.tableviewProfile endUpdates];
    
}

-(void)addnextprofileimage:(UIButton *)sender
{
    
}

-(void)updateProfileImageAction: (UITapGestureRecognizer *)tapGesture
{
    UIView *selectedView = tapGesture.view;
    selectedImageIndex = selectedView.tag - 1;
    
    isTapGesture = YES;
    [self selectimagePicker];
}


//-(void)updateProfileImageAction{
//
//    isTapGesture = YES;
//
//    [self selectimagePicker];
//
//}

-(void)selectimagePicker{
    
    NSLog(@"currentimge=%ld",(long)CurrentImage);
    //
    if(CurrentImage==0)
    {
        CurrentImage=CurrentImage+1;
    }
    NSString * currentimgField=[NSString stringWithFormat:@"image%d",CurrentImage];
    //
    NSString * selectimg=[profileDict valueForKey:currentimgField];
    
    [COMMON TrackerWithName:@"User Profile"];
    
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
        
        UIActionSheet *actionSheet1 ;
        actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",@"") destructiveButtonTitle:NSLocalizedString(@"CAMERA",@"") otherButtonTitles:NSLocalizedString(@"PHOTO LIBRARY",@""), nil];
        
        
        
        if(isTapGesture == YES){
            
            if(!isNewUser)
            {
                actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",@"") destructiveButtonTitle:NSLocalizedString(@"CAMERA",@"") otherButtonTitles:NSLocalizedString(@"PHOTO LIBRARY",@""),NSLocalizedString(@"REMOVE",@""), nil];
                
            }
        }
        
        [actionSheet1 showInView:self.view];
        [actionSheet1 sizeToFit];
        
    }
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"CAMERA",@"") style:UIAlertActionStyleDefault
                             
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       imagepickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                       
                                                       [self presentViewController:imagepickerController animated:YES completion:nil];
                                                       
                                                   }];
    
    
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:NSLocalizedString(@"PHOTO LIBRARY",@"") style:UIAlertActionStyleDefault
                                   
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             // [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                             
                                                             imagepickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             
                                                             [self presentViewController:imagepickerController animated:YES completion:nil];
                                                             
                                                         }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL",@"") style:UIAlertActionStyleDefault
                             
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       //[self promptForCamera];
                                                       
                                                       [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                       
                                                       
                                                   }];
    UIAlertAction *RemoveImage;
    
    if(!isNewUser)
    {
        
        RemoveImage = [UIAlertAction actionWithTitle:NSLocalizedString(@"REMOVE",@"") style:UIAlertActionStyleDefault
                       
                                             handler:^(UIAlertAction * action) {
                                                 
                                                 //[self promptForCamera];
                                                 
                                                 [self RemoveprofileImage];
                                                 
                                             }];
    }
    
    
    if(IS_GREATER_IOS8){
        
        [alert addAction:cancel];
        
        [alert addAction:camera];
        
        [alert addAction:photoLibrary];
        
        
        if(isTapGesture == YES){
            
            if(!isNewUser)
            {
                [alert addAction:RemoveImage];
            }
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Camera Action

-(void)selectCamera: (UIButton *)sender

{
    isTapGesture = NO;
    
    [self selectimagePicker];
    
}

/*
 -(void)RemoveprofileImage
 {
 int imgfield;
 
 if(CurrentImage == 0)
 {
 imgfield =1;
 }
 else
 {
 imgfield=CurrentImage+1;
 }
 NSString * removeimgField=[NSString stringWithFormat:@"image%d",imgfield];
 
 NSString * Removeselectimg=[profileDict valueForKey:removeimgField];
 
 NSLog(@"sfhdsfdhsgfdg%@",Removeselectimg);
 
 if(![Removeselectimg isEqualToString:@""])
 {
 
 [objWebService getDeleteprofileImage:deleteprofileImg sessionID:[COMMON getSessionID] Fieldimage:removeimgField success:^(AFHTTPRequestOperation *operation, id responseObject) {
 if([[[responseObject valueForKey:@"deleteprofileimage"]valueForKey:@"status"]isEqualToString:@"success"])
 {
 //          if(profileDataArray.count!=0)
 //          {
 //           [profileDataArray removeObjectAtIndex:CurrentImage];
 //              if(profileDataArray.count == 0)
 //              {
 //                  [profileDataArray addObject:@"profile_noimg.png"];
 //              }
 //          }
 //
 //           self.scrView.scrollEnabled = YES;
 //           int  currentpage;
 //
 //           if(imgfield == 1)
 //           {
 //
 //               currentpage = 0;
 //
 //       }
 //
 //           else if(imgfield == 2)
 //           {
 //
 //
 //               currentpage=1;
 //
 //           }
 //           else if(imgfield == 3)
 //           {
 //
 //               currentpage=2;
 //            }
 if([[profileDict valueForKey:@"type"] isEqualToString:@"1"])
 {
 [COMMON removeUserDetails];
 [self loadloginAPi];
 }
 else if([[profileDict valueForKey:@"type"] isEqualToString:@"2"])
 {
 //[COMMON removeUserDetails];
 //[self checkUserEmail];
 [self loadloginAPi];
 }
 //           [self setupScrollView:self.scrView :currentpage];
 //
 //
 //           jslider = profileDataArray.count;   //self.scrView.contentOffset.x / self.scrView.frame.size.width;
 //           [self.scrView setNeedsDisplay];
 //           profileImagePageControl.currentPage=jslider;
 //           [pageImageView setFrame:CGRectMake(jslider*18, 0, 8, 8)];
 //
 
 NSLog(@"deleteimageresponse=%@",responseObject);
 
 }
 } failure:^(AFHTTPRequestOperation *operation, id error) {
 NSLog(@"error=%@",error);
 }];
 }
 }
 
 */


-(void)loadloginAPi
{
    NSString* proflieid=[profileDict valueForKey:@"profile_id"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    if(deviceToken == nil)
        deviceToken = @"";
    [objWebService getLogin:Login_API
                       type:[profileDict valueForKey:@"type"]
                      email:[profileDict valueForKey:@"email"]
                   password:[profileDict valueForKey:@"password"]
                  profileId:proflieid
                        dob:@""
               profileImage:@""
                     gender:@""
                   latitude:currentLatitude
                  longitude:currentLongitude
                     device:@"iPhone"
                   deviceid:deviceToken
                   pushType:push_type
                    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"responseObjectLogin = %@",responseObject);
         
         NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
         
         loginDict = [responseObject valueForKey:@"signin"];
         
         if([[loginDict valueForKey:@"status"]isEqualToString:@"success"]){
             
             [COMMON setUserDetails:[[loginDict valueForKey:@"userDetails"]objectAtIndex:0]];
             
             
             
             
             NSLog(@"userdetails = %@",[COMMON getUserDetails]);
             [COMMON removeLoading];
             
             DSProfileTableViewController*profileview =[[DSProfileTableViewController alloc]initWithNibName:@"DSProfileTableViewController" bundle:nil];
             [self.navigationController pushViewController:profileview animated:NO];
             
         }
         else{
             NSLog(@"responseObject = %@",responseObject);
             //[self showAltermessage:[loginDict valueForKey:@"Message"]];
             [COMMON removeLoading];
             
         }
         
         
     }
                    failure:^(AFHTTPRequestOperation *operation, id error){
                        
                        NSLog(@"ERROR = %@",error);
                        
                        [COMMON removeLoading];
                        
                    }];
    
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
            
        case 2:
            if(isTapGesture == YES){
                
                if(!isNewUser)
                {
                    [self RemoveprofileImage];
                }
            }
            
            else{
                [imagepickerController dismissViewControllerAnimated:YES completion:nil];
            }
            
            break;
            
        default:
            
            break;
            
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(IS_GREATER_IOS8)
    {}
    else{
        [COMMON LoadIcon:self.view];
        is_profileImgediting=YES;
        
    }
    UIImage *image = nil;
    [cell.topViewCell setHidden:NO];
    image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *profileData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
    if([[userProfileImageArray objectAtIndex:0] isEqual:@""])
    {
        currentImageIndex = 0;
        profileImage1  = [UIImage imageWithData:profileData];
    }
    else if ([[userProfileImageArray objectAtIndex:1] isEqual:@""])
    {
        currentImageIndex = 1;
        profileImage2  = [UIImage imageWithData:profileData];
    }
    else if ([[userProfileImageArray objectAtIndex:2] isEqual:@""])
    {
        currentImageIndex = 2;
        profileImage3  = [UIImage imageWithData:profileData];
    }
    
    if(isNewUser)
    {
        currentImageIndex = 0;
        profileImage1  = [UIImage imageWithData:profileData];
        isNewUser = NO;
    }
    
    NSInteger selectedIndex = (isTapGesture) ? selectedImageIndex : currentImageIndex;
    
    
    [userProfileImageArray replaceObjectAtIndex:selectedIndex withObject:image];
    
    
    
    [self setUserProfileImages];
    [imagepickerController dismissViewControllerAnimated:YES completion:nil];
    
    /*
     UIImage *image = nil;
     [cell.topViewCell setHidden:NO];
     image = [info valueForKey:UIImagePickerControllerEditedImage];
     NSData *profileData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
     
     NSLog(@"profileDataArray = %@",profileDataArray);
     NSLog(@"infoarray = %d",infoArray.count);
     NSString *imageStr;
     for (int i = 0; i < [profileDataArray count]; i++) {
     
     imageStr = [NSString stringWithFormat:@"%@",[profileDataArray objectAtIndex:i]];
     
     if([imageStr isKindOfClass:[NSData class]])
     imageStr = [[NSString alloc] initWithData:[profileDataArray objectAtIndex:i] encoding:NSUTF8StringEncoding];
     
     if([imageStr isEqualToString:@""]){
     
     if(i == 1){
     CurrentImage = 1;
     profileImage2 = image;
     is_photoaddImg=YES;
     [infoArray removeLastObject];
     
     
     }
     if(i == 2){
     CurrentImage = 2;
     profileImage3 = image;
     isPageControl=NO;
     is_photoaddImg=YES;
     
     }
     
     [profileDataArray replaceObjectAtIndex:i withObject:profileData];
     
     [self profileScroll];
     
     [imagepickerController dismissViewControllerAnimated:YES completion:nil];
     
     return;
     }
     
     }
     
     */
    
    
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
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    if(deviceToken == nil)
        deviceToken = @"";
    
    NSString *fbProfileStr;
    
    if([strType isEqualToString:@"2"])
        fbProfileStr =([FBImageStr isEqualToString:@"1"])?@"":[userDetailsDict valueForKey:@"profileImage"];
    if([COMMON isInternetReachable]){
        
        [objWebService postRegister:Register_API
                               type:strType
                         first_name:FirstName
                          last_name:LastName
                              email:emailAddressToRegister
                           password:(currentPassword==nil)?emailPasswordToRegister:currentPassword
                          profileId:strProfileID
                                dob:dateChange
                      profileImage1:[userProfileImageArray objectAtIndex:0]
                      profileImage2:[userProfileImageArray objectAtIndex:1]
                      profileImage3:[userProfileImageArray objectAtIndex:2]
                   IntersertHobbies:strInterestHobbies
                              About:strAbout
                             gender:strGender
                           latitude:currentLatitude
                          longitude:currentLongitude
                             device:Device
                           deviceid:deviceToken
                     fbprofileImage:fbProfileStr
               notification_message:isNotification_message
               notification_sound  :isNotification_sound
                            isMatch:isNotification_match
                              sound:selectSoundStr
                           pushType:push_type
                            fbimage:FBImageStr
                            success:^(AFHTTPRequestOperation *operation, id responseObject){
                                [COMMON removeLoading];
                            }
         
                            failure:^(AFHTTPRequestOperation *operation, id error) {
                                
                                [COMMON removeLoading];
                                
                                
                            }];
        
        
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }
}
#pragma mark - updateAPI
-(void) updateAPI{
    
    //[COMMON AddLoadIcon:self.view];
    if(currentLatitude == nil)
        currentLatitude = @"";
    if(currentLongitude == nil)
        currentLongitude = @"";
    
    if([COMMON isInternetReachable]){
        [objWebService profileUpdate:ProfileUpdate_API
                          first_name:FirstName
                           last_name:LastName
                                 dob:dateChange
                            password:(currentPassword==nil)?emailPasswordToRegister:currentPassword
                       profileImage1:[userProfileImageArray objectAtIndex:0]
                       profileImage2:[userProfileImageArray objectAtIndex:1]
                       profileImage3:[userProfileImageArray objectAtIndex:2]
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
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }
    
}
#pragma mark - loadRegisterNotification
-(void)loadRegister{
    
    //  [COMMON AddLoadIcon:self.view];
    
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
    
    // [COMMON AddLoadIcon:self.view];
    
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=YES;
    appDelegate.SepratorLbl.hidden=YES;
    [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    
}

#pragma mark - saveAction
-(void)saveAction:(id)sender
{
    self.WalAlterview.hidden=YES;
    self.window.hidden=YES;
    [self.view endEditing:YES];
    
    if(profileDict !=NULL){
        
        strGender = [profileDict valueForKey:@"gender"];
        [self loadValidations];
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
//#pragma mark - dateConverter
//-(void)dateConverter{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    NSDate *date = [dateFormatter dateFromString: strDOB];
//    dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    dateChange = [dateFormatter stringFromDate:date];
//
//
//}
#pragma mark - saveAction
-(void)loadValidations
{
    // [COMMON AddLoadIcon:self.view];
    
    strType      = (selectEmail== YES)?@"1":@"2";
    strProfileID = (FBprofileID!=nil)?FBprofileID:@"";
    NSString *datestr= [userDetailsDict valueForKey:@"birthday"];
    if(userDetailsDict==0)
    {
        strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :[profileDict valueForKey:@"date_of_birth"];
        strDOB  = (currentTextfield.text !=nil)?currentTextfield.text :[profileDict valueForKey:@"date_of_birth"];
        dateChange=[NSString stringWithFormat:@"%@/%@/%@",[[strDOB componentsSeparatedByString:@"/"]objectAtIndex:2],[[strDOB componentsSeparatedByString:@"/"]objectAtIndex:1],[[strDOB componentsSeparatedByString:@"/"]objectAtIndex:0]];
        
    }
    else if (datestr==nil)
    {
        strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :[profileDict valueForKey:@"date_of_birth"];
        strDOB  = (currentTextfield.text !=nil)?currentTextfield.text :[profileDict valueForKey:@"date_of_birth"];
        dateChange=[NSString stringWithFormat:@"%@/%@/%@",[[strDOB componentsSeparatedByString:@"/"]objectAtIndex:2],[[strDOB componentsSeparatedByString:@"/"]objectAtIndex:1],[[strDOB componentsSeparatedByString:@"/"]objectAtIndex:0]];
    }
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
        else if ([strAbout isEqualToString:@""] || strAbout == NULL )
        {
            
            [self showAltermessage:@"About Required"];
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
            
            if(userDetailsDict > 0)
            {
                [COMMON removeLoading];
                
                
                [self showAccountCreateAltermessage:@"By clicking create,you agree to the Term of \n Use & Privacy policy"];
                return;
            }
            else
                
            {
                [self showAltermessage:PASSWORD_REQUIRED];
                [COMMON removeLoading];
                
                return;
            }
        }
        else
            
        {
            
            [COMMON removeLoading];
            
            [self showAccountCreateAltermessage:@"By clicking create,you agree to the Term of \n Use & Privacy policy"];
        }
        
    }
    
    if(profileDict!=nil)
    {
        if ([strAbout isEqualToString:@""] || strAbout == NULL )
        {
            
            [self showAltermessage:@"About Required"];
            [COMMON removeLoading];
            
            return;
        }
        
        if([[profileDict valueForKey:@"showpassword"] isEqualToString:@"Yes"])
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

#pragma mark - CustomAlterviewload
-(void)CustomAlterviewload
{
    objCustomAlterview = [[CustomAlterview alloc] initWithNibName:@"CustomAlterview" bundle:nil];
    [objCustomAlterview.alertBgView setHidden:YES];
    [objCustomAlterview.alertMainBgView setHidden:YES];
    [objCustomAlterview.view setHidden:YES];
    [objCustomAlterview.alertCancelButton addTarget:self
                                             action:@selector(alertPressCancel:)
                                   forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.btnNo addTarget:self
                                 action:@selector(alertPressNo:)
                       forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.btnYes addTarget:self
                                  action:@selector(alertPressYes:)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:objCustomAlterview.view];
}

-(IBAction)didClickGeneralWalkAlterviewBtn:(id)sender
{
    self.WalAlterview.hidden=YES;
    self.window.hidden=YES;
    [self flashOff:blueCirecleBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)displaySoundmenuList:(id)sender
{
    objCustomSoundView.view.hidden=NO;
    objCustomSoundView.soundmenuView.hidden=NO;
}
-(void)GerenalWalkAlterviewCreateAccount
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIButton * ClosewindowBtn =[[UIButton alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [ClosewindowBtn addTarget:self action:@selector(didClickGeneralWalkAlterviewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.window addSubview:ClosewindowBtn];
    //UIButton * blueCirecleBtn;
    UILabel * Savelbl;
    UIView * altermsgView;
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
        blueCirecleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.window.frame.size.width-65,self.window.frame.origin.y+25,45,45)];
        Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(self.window.frame.size.width-60,self.window.frame.origin.y+30,35,35)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.window.center.x-75,self.view.frame.origin.y+160,150,50)];
    }
    else{
        blueCirecleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-65,15,45,45)];
        Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60,20,35,35)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-80,self.view.frame.origin.y+150,160,60)];
    }
    
    [blueCirecleBtn setImage:[UIImage imageNamed:@"BlueCirecleimg"] forState:UIControlStateNormal];
    blueCirecleBtn.userInteractionEnabled=YES;
    [self flashOn:blueCirecleBtn];
    [self.window addSubview:blueCirecleBtn];
    
    Savelbl.text =@"Save";
    Savelbl.textColor=[UIColor whiteColor];
    Savelbl.textAlignment= NSTextAlignmentCenter;
    Savelbl.numberOfLines=2;
    [Savelbl setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [self.window addSubview:Savelbl];
    
    
    
    UIImageView * blueTxtImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,160,60)];
    blueTxtImg.userInteractionEnabled=YES;
    blueTxtImg.image=[UIImage imageNamed:@"BlueBgText"];
    [altermsgView addSubview:blueTxtImg];
    UILabel * AlterMsg=[[UILabel alloc]initWithFrame:CGRectMake(0,0,160,60)];
    AlterMsg.text =@"Fill your info below";
    AlterMsg.textColor=[UIColor whiteColor];
    AlterMsg.textAlignment= NSTextAlignmentCenter;
    AlterMsg.numberOfLines=2;
    [AlterMsg setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [altermsgView addSubview:AlterMsg];
    
    [self.window addSubview:altermsgView];
    [blueCirecleBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.window.hidden=NO;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor =[UIColor colorWithRed:(53.0/255.0f) green:(53.0/255.0f) blue:(53.0/255.0f) alpha:0.5];
    
    
}

-(void)GerenalWalkAlterviewSign
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIView * CommWalkView;
    
    UILabel * Savelbl;
    UIView * altermsgView;
    
    if(IS_IPHONE6_Plus ||IS_IPHONE6)
    {
        CommWalkView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-63,self.view.frame.origin.y+25,45,45)];
        blueCirecleBtn=[[UIButton alloc]initWithFrame:CGRectMake(2,3,40,40)];
        Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(5,5,35,35)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-90,self.view.center.y+80,200,60)];
    }
    else{
        CommWalkView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-63,self.view.frame.origin.y+15,45,45)];
        blueCirecleBtn=[[UIButton alloc]initWithFrame:CGRectMake(2,3,40,40)];
        Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(5,5,35,35)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-90,self.view.center.y+20,200,60)];
    }
    
    CommWalkView.backgroundColor =[UIColor clearColor];
    
    
    
    [blueCirecleBtn setImage:[UIImage imageNamed:@"BlueCirecleimg"] forState:UIControlStateNormal];
    
    [self flashOn:blueCirecleBtn];
    [CommWalkView addSubview:blueCirecleBtn];
    
    Savelbl.text =@"Save";
    Savelbl.textColor=[UIColor whiteColor];
    Savelbl.textAlignment= NSTextAlignmentCenter;
    Savelbl.numberOfLines=2;
    [Savelbl setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [CommWalkView addSubview:Savelbl];
    
    
    UIImageView * blueTxtImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,200,60)];
    blueTxtImg.userInteractionEnabled=YES;
    blueTxtImg.image=[UIImage imageNamed:@"BlueBgText"];
    [altermsgView addSubview:blueTxtImg];
    UILabel * AlterMsg=[[UILabel alloc]initWithFrame:CGRectMake(0,0,200,60)];
    AlterMsg.text =@"Once all information are filled in.\n just hit “Save”";
    AlterMsg.textColor=[UIColor whiteColor];
    AlterMsg.textAlignment= NSTextAlignmentCenter;
    AlterMsg.numberOfLines=2;
    [AlterMsg setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [altermsgView addSubview:AlterMsg];
    
    [self.window addSubview:altermsgView];
    
    UIButton * ClosewindowBtn =[[UIButton alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [ClosewindowBtn addTarget:self action:@selector(didClickGeneralWalkAlterviewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.window addSubview:ClosewindowBtn];
    [self.window addSubview:CommWalkView];
    [blueCirecleBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.window.hidden=NO;
    [self.window makeKeyAndVisible];
    [self.window.rootViewController.view addSubview:CommWalkView];
    self.window.backgroundColor =[UIColor colorWithRed:(53.0/255.0f) green:(53.0/255.0f) blue:(53.0/255.0f) alpha:0.5];
    
    
}

- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .05;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha =1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}

#pragma mark - Display User Profile

/*  *****************************  Display User Profile Image  ***************************** */

-(void)setInitialProfileArray
{
    UIImage *defaultProfile = [UIImage imageNamed:@"profile_noimg"];
    NSMutableDictionary *profileDictionary = [COMMON getUserDetails];
    userProfileImageArray  = [NSMutableArray new];
    
    if(userDetailsDict != NULL)   /// FB User Deatil
    {
        NSString *imageString = [userDetailsDict valueForKey:@"profileImage"];
        NSURL *imageURL = [NSURL URLWithString:imageString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *fbImage = [UIImage imageWithData:imageData];
        
        UIImage *fbProfile = (imageData == nil) ? defaultProfile : fbImage;
        
        userProfileImageArray = [@[fbProfile, @"", @""] mutableCopy];
        isNewUser = NO;
    }
    else if(profileDictionary != NULL)  /// User Details
    {
        NSURL *imageURLOne   = [NSURL URLWithString:[profileDictionary valueForKey:@"image1"]];
        NSData *imageDataOne = [NSData dataWithContentsOfURL:imageURLOne];
        
        NSURL *imageURLTwo   = [NSURL URLWithString:[profileDictionary valueForKey:@"image2"]];
        NSData *imageDataTwo = [NSData dataWithContentsOfURL:imageURLTwo];
        
        NSURL *imageURLThree   = [NSURL URLWithString:[profileDictionary valueForKey:@"image3"]];
        NSData *imageDataThree = [NSData dataWithContentsOfURL:imageURLThree];
        
        
        UIImage *imageOne   = [UIImage imageWithData:imageDataOne];
        UIImage *imageTwo   = [UIImage imageWithData:imageDataTwo];
        UIImage *imageThree = [UIImage imageWithData:imageDataThree];
        
        UIImage *profileImageOne   = (imageDataOne == nil)   ? [UIImage imageNamed:@""] : imageOne;
        UIImage *profileImageTwo   = (imageDataTwo == nil)   ? @"" : imageTwo;
        UIImage *profileImageThree = (imageDataThree == nil) ? @"" : imageThree;
        
        
        userProfileImageArray = [@[profileImageOne, profileImageTwo, profileImageThree] mutableCopy];
        isNewUser = NO;
    }
    else
    {
        userProfileImageArray = [@[defaultProfile, @"", @""] mutableCopy];
        isNewUser = YES;
    }
    
    [self pageScrollView];
}

-(void)setUserProfileImages
{
    self.scrView.pagingEnabled=YES;
    self.scrView.delegate=self;
    [self.scrView setShowsHorizontalScrollIndicator:NO];
    totalImageCount = 0;
    
    UIImage * lastobject = [userProfileImageArray valueForKey: @"@lastObject"];
    
    
    
    for(int imageIndex = 0; imageIndex < [userProfileImageArray count]; imageIndex++)
    {
        if(![[userProfileImageArray objectAtIndex:imageIndex] isEqual:@""])
        {
            UIImage *imageProfile = [userProfileImageArray objectAtIndex:imageIndex];
            
            NSInteger extraSpace;
            
            if(IS_IPHONE6_Plus)
            {
                extraSpace = 130;
            }
            else if (IS_IPHONE6)
            {
                extraSpace = 115;
            }
            else
            {
                if(imageIndex==1 ||imageIndex==2)
                {
                    extraSpace =80;
                }
                
                else
                    
                {
                    extraSpace = 90;
                }
            }
            
            if(IS_IPHONE6)
            {
                if(![lastobject  isEqual: @""] && imageIndex ==1)
                {
                    userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageIndex * self.scrView.frame.size.width)+50 + extraSpace,
                                                                                    20, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
                }
                else
                {
                    userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageIndex * self.scrView.frame.size.width) + extraSpace,
                                                                                    20, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
                }
            }
            
            if(IS_IPHONE6_Plus)
            {
                if(![lastobject  isEqual: @""] && imageIndex ==1)
                {
                    
                    userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageIndex * self.scrView.frame.size.width)+110,
                                                                                    20, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
                }
                else if (![lastobject  isEqual: @""] && imageIndex ==2)
                {
                    
                    
                    userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageIndex * self.scrView.frame.size.width)+120,
                                                                                    20, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
                    
                }
                else
                {
                    userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageIndex * self.scrView.frame.size.width) + extraSpace,
                                                                                    20, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
                }
            }
            
            
            
            else
            {
                userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageIndex * self.scrView.frame.size.width) + extraSpace,
                                                                                20, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
            }
            
            
            [userProfileImage setImage:imageProfile];
            
            userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height / 2;
            userProfileImage.layer.masksToBounds = YES;
            [userProfileImage setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateProfileImageAction:)];
            [singleTap setNumberOfTapsRequired:1];
            userProfileImage.tag = 1 + imageIndex;
            [userProfileImage addGestureRecognizer:singleTap];
            [self.scrView addSubview:userProfileImage];
            
            [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
            [cameraIcon setHidden:YES];
            [cell.topViewCell setHidden:NO];
            self.scrView.scrollEnabled = YES;
            
            if(IS_IPHONE6)
            {
                [self.scrView setContentSize:CGSizeMake(self.scrView.frame.size.width*(imageIndex+1)+45, 150)];
            }
            else if(IS_IPHONE6_Plus)
            {
                [self.scrView setContentSize:CGSizeMake(self.scrView.frame.size.width*(imageIndex+1)+80, 150)];
            }
            else
            {
                [self.scrView setContentSize:CGSizeMake(self.scrView.frame.size.width*(imageIndex+1)-8, 150)];
            }
            
            totalImageCount = imageIndex;
        }
    }
    
    
    if(totalImageCount != 0)
        [self pageScrollView];
}

-(void)RemoveprofileImage
{
    NSString * obj =[profileDict valueForKey:@"image1"];
    
    NSLog(@"objimage=%@",obj);
    UIImage *defaultProfile = [UIImage imageNamed:@"profile_noimg"];
    UIImage *imageTwo   = [userProfileImageArray objectAtIndex:1];
    UIImage *imageThree = [userProfileImageArray objectAtIndex:2];
    
    UIImage *profilaImageTwo   = (imageTwo == nil)   ? [UIImage imageNamed:@""] : imageTwo;
    UIImage *profilaImageThree = (imageThree == nil) ? [UIImage imageNamed:@""] : imageThree;
    
    if(selectedImageIndex == 0)
    {
        [userProfileImageArray replaceObjectAtIndex:0 withObject:profilaImageTwo];
        [userProfileImageArray replaceObjectAtIndex:1 withObject:profilaImageThree];
        [userProfileImageArray replaceObjectAtIndex:2 withObject:@""];
    }
    else if (selectedImageIndex == 1)
    {
        [userProfileImageArray replaceObjectAtIndex:1 withObject:profilaImageThree];
        [userProfileImageArray replaceObjectAtIndex:2 withObject:@""];
    }
    else if (selectedImageIndex == 2)
    {
        [userProfileImageArray replaceObjectAtIndex:2 withObject:@""];
    }
    
    if([imageTwo isEqual:@""] && [imageThree isEqual:@""])
    {
        userProfileImageArray = [@[defaultProfile, @"", @""] mutableCopy];
        isNewUser = YES;
    }
    if(selectedImageIndex==0)
    {
        selectedImageIndex=selectedImageIndex+1;
    }
    NSString * removeimgField=[NSString stringWithFormat:@"image%ld",(long)selectedImageIndex];
    
    NSLog(@"removeimgField=%@",removeimgField);
    
    
    [objWebService getDeleteprofileImage:deleteprofileImg sessionID:[COMMON getSessionID] Fieldimage:removeimgField success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[[responseObject valueForKey:@"deleteprofileimage"]valueForKey:@"status"]isEqualToString:@"success"])
        {
            NSLog(@"response=%@",responseObject);
        }
    }
                                 failure:^(AFHTTPRequestOperation *operation, id error) {
                                     NSLog(@"error=%@",error);
                                 }];
    [_tableviewProfile reloadData];
}
@end
