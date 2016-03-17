//
//  DSLocationViewController.m
//  DoSomething
//
//  Created by Ocs-web on 15/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSLocationViewController.h"
#import "LocationCollectionViewCell.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "UIImageView+AFNetworking.h"
#import "DSAppCommon.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "CustomAlterview.h"
#import "DSNearByDetailViewController.h"
#import "DSChatDetailViewController.h"

#define hobbiesbackcolor = [UIColor colorWithRed: (199.0/255.0) green: (65.0/255.0) blue: (81.0/255.0) alpha: 1.0];

@interface DSLocationViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CustomAlterview             * objCustomAlterview;
    DSWebservice                * objWebservice;
    AppDelegate                 * appDelegate;
    LocationCollectionViewCell  * locationCellView;
    CustomNavigationView        * customNavigation;
    UISwipeGestureRecognizer    * swiperight;
    UILabel                     * usernotfoundlbl;
    UIRefreshControl            * refreshControl;

    NSString                    * longitude;
    NSString                    * latitude;
    NSString                    * currentLatitude, * currentLongitude;
    NSString                    * profileUserID;
    NSString                    * currentloadPage;
    NSString                    * onlineStatus;
    NSString                    * GenderStatus;
    NSString                    * avalableStatus;
    NSString                    * filterAge;
    NSString                    * filterDistance;
    
    NSString                    *recordCount;
    
    NSMutableArray              * matchUserArray;
    
    NSDictionary                *currentuser;
    NSString * selectuserstatus;
    BOOL isgestureenable;
    BOOL isLoadWebservice;
    BOOL isAllPost;
    BOOL isFilteraction;
    BOOL isLoadData;
    BOOL isfilterChange;
    NSString * RequestStr;
    NSMutableArray *detailsArray;
    BOOL isuserdetail;
    
}
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * collectionviewxpostion;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * filterviewxposition;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * CollectionviewWidth;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * FilterScrollviewYposition;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * FilterScrollviewWidth;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * FilterScrollviewXposition;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * MatchImgviewXposition;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint  * MatchImgviewYposition;
@property (nonatomic,strong)  CLLocationManager         *  locationManager;

@property(nonatomic,strong) IBOutlet UIButton *onlineBtn;
@property(nonatomic,strong) IBOutlet UIButton *offlineBtn;
@property(nonatomic,strong) IBOutlet UIButton *statusBothBtn;

@property(nonatomic,strong) IBOutlet UIButton *avalableYesBtn;
@property(nonatomic,strong) IBOutlet UIButton *avalableNoBtn;
@property(nonatomic,strong) IBOutlet UIButton *avalableBothBtn;

@property(nonatomic,strong) IBOutlet UIButton *maleBtn;
@property(nonatomic,strong) IBOutlet UIButton *FemaleBtn;
@property(nonatomic,strong) IBOutlet UIButton *genderbothBtn;


@property(nonatomic,strong) IBOutlet UISwipeGestureRecognizer * locationviewSwipright;

@end

@implementation DSLocationViewController
@synthesize delegate;
@synthesize locationCollectionView,locationManager;
@synthesize profileImages,profileNames,kiloMeterlabel,userID,dosomethingImageArry,commonlocationArray,matchactivityBtn,matchActivitylbl,matchActivityView,sendrequestConversationID;
- (void)viewDidLoad {
    
   
    NSString * Firstlogin=[[NSUserDefaults standardUserDefaults]valueForKey:FirstloginLocationView];
     
    if([Firstlogin isEqualToString:@"Yes"])
    {
       // self.walkAlterview.hidden =NO;
        [self GerenalWalkAlterview];
         [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:FirstloginLocationView];
    }

    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(releaseToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.locationCollectionView addSubview:refreshControl];
   
    latitude     =[COMMON getLatitude];
  
    longitude    =[COMMON  getLongitude];
    matchUserArray =[[NSMutableArray alloc]init];
    commonlocationArray =[[NSMutableArray alloc]init];
    onlineStatus=@"";
    GenderStatus=@"";
    avalableStatus=@"";
    objWebservice =[[DSWebservice alloc]init];
    currentloadPage= @"";
    if (![CLLocationManager locationServicesEnabled]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"Turn on location services to allow “Do Something” to determine your locationDoSomething would like to use your location"
                                                       delegate:self
                                              cancelButtonTitle:@"Settings"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
        
        
    }

    else
    {
         [COMMON DSLoadIcon:self.view];
         [self nearestLocationWebservice];
    }
  
    
    [super viewDidLoad];
    isLoadData=NO;
    isLoadWebservice=YES;
    isgestureenable =YES;
    isfilterChange=NO;
    [self configureAgeChangeSlider];
     [self configureLabelSlider];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInvalidSessionAlert:)
                                                 name:@"InvalidSession"
                                               object:nil];
   
    [self loadCustomNavigationview];
    [self CustomAlterview];
    
    UINib *cellNib = [UINib nibWithNibName:@"LocationCollectionViewCell" bundle:nil];
    [self.locationCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LocationCell"];
    
    locationCollectionView.delegate=self;
    locationCollectionView.dataSource=self;
    profileImages =[[NSArray alloc]init];
    profileNames =[[NSArray alloc]init];
    dosomethingImageArry=[[NSMutableArray alloc]init];
    kiloMeterlabel =[[NSArray alloc]init];
     detailsArray=[[NSMutableArray alloc]init];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ViewuserDetail"]) {
      [self nearestLocationWebservice];
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ViewuserDetail"];
    }
    
    
    if(!isLoadData){
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.headerReferenceSize = CGSizeMake(locationCollectionView.bounds.size.width,45);
      

    [locationCollectionView setCollectionViewLayout:flowLayout1];
    

    if(IS_IPHONE5)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:locationCollectionView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:-20.0]];
        isLoadData=YES;
    
    }
     [self filterPageButtonAction];
    if(self.senduserDetail.count>0)
    {
        self.matchActivityView.hidden=NO;
        [matchUserArray removeAllObjects];
        matchUserArray=self.senduserDetail;
        if(IS_IPHONE6 || IS_IPHONE6_Plus)
        {
//            self.CollectionviewWidth.constant =self.view.frame.size.width+100;
            //self.filterviewxposition.constant =self.view.frame.size.width ;
            self.collectionviewxpostion.constant =10;
            self.CollectionviewWidth.constant    =self.view.frame.size.width+100-10;
            self.filterviewxposition.constant    = self.CollectionviewWidth.constant+10;
        }
        
          [self RequestSendNotification];
    }
    else{
        self.matchActivityView.hidden=YES;
        if(IS_IPHONE6 || IS_IPHONE6_Plus)
        {
            //self.CollectionviewWidth.constant =self.view.frame.size.width+100;
            self.filterviewxposition.constant =self.view.frame.size.width ;
            
        }
    }

    
   

    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"dot_Image"] forState:UIControlStateNormal];
    
   
    
}
-(void)loadCustomNavigationview
{
   
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 76);
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:YES];
    [customNavigation.FilterBtn setHidden:NO];
    [customNavigation.FilterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
}
-(void)loadMatchActivityMethod
{
    
    self.walkAlterview.hidden =YES;
     self.blueCircle.hidden=YES;
    NSString * Firstlogin=[[NSUserDefaults standardUserDefaults]valueForKey:FirstMatchUser];
    
    if([Firstlogin isEqualToString:@"Yes"])
    {
        self.walkAlterview.hidden =NO;
        self.blueCircle.hidden=NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:FirstMatchUser];
    }

    if(matchUserArray !=0 && ![matchUserArray isEqual:@"0"])
    {
        self.matchActivityView.hidden =NO;
        if(IS_IPHONE6)
        {
           self.MatchImgviewXposition.constant=50;
        }
        else if (IS_IPHONE6_Plus)
        {
            self.MatchImgviewXposition.constant=70;
        }
        else
        {
            self.MatchImgviewXposition.constant=20;
        }
        self.MatchImgviewYposition.constant=(IS_IPHONE6||IS_IPHONE6_Plus)?170:130;
     NSString *matchprofileImg =[matchUserArray valueForKey:@"image1"];
        if([matchprofileImg isEqualToString:@""] || matchprofileImg ==nil)
        {
            [self.matcheduserImg setImage:[UIImage imageNamed:@"profile_noimg"]];
        }
        else
        {
            matchprofileImg= [matchprofileImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            downloadImageFromUrl(matchprofileImg,self.matcheduserImg);
            [self.matcheduserImg setImage:[UIImage imageNamed:matchprofileImg]];
        }
    
    currentuser=[[NSMutableDictionary alloc]init];
    currentuser =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString *objCurrentuserImg=[currentuser valueForKey:@"image1_thumb"];
        if([objCurrentuserImg isEqualToString:@""] || objCurrentuserImg ==nil)
        {
             [self.currentUserImg setImage:[UIImage imageNamed:@"profile_noimg"]];
        }
        else
        {
            objCurrentuserImg= [objCurrentuserImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            downloadImageFromUrl(objCurrentuserImg,self.currentUserImg);

            [self.currentUserImg setImage:[UIImage imageNamed:objCurrentuserImg]];
        }
    
   
    
    self.currentUserImg .layer.cornerRadius = 60;
     self.currentUserImg .clipsToBounds = YES;
    self.currentUserImg.layer.borderWidth=1;
    [self.currentUserImg.layer setBorderColor:[UIColor redColor].CGColor];
    
   self.matcheduserImg .layer.cornerRadius = 60;
    self.matcheduserImg .clipsToBounds = YES;
    self.matcheduserImg.layer.borderWidth=1;
    [self.matcheduserImg.layer setBorderColor:[UIColor redColor].CGColor];
    
    NSString*objmatchusername =[NSString stringWithFormat:@"You and %@ are a match \n Start Chatting to",[matchUserArray valueForKey:@"Name"]];
    self.matchActivitylbl.text =objmatchusername;
    }
    else{
        self.matchActivityView.hidden =YES;
    }
}
-(void)filterPageButtonAction
{
    self.onlineBtn.layer.cornerRadius =10;
    self.onlineBtn.layer.masksToBounds = YES;
    self.onlineBtn.layer.borderWidth =4;
    [self.onlineBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.offlineBtn.layer.cornerRadius =10;
    self.offlineBtn.layer.masksToBounds = YES;
    self.offlineBtn.layer.borderWidth =4;
    [self.offlineBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.statusBothBtn.layer.cornerRadius =10;
    self.statusBothBtn.layer.masksToBounds = YES;
    self.statusBothBtn.layer.borderWidth =4;
    [self.statusBothBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.maleBtn.layer.cornerRadius =10;
    self.maleBtn.layer.masksToBounds = YES;
    self.maleBtn.layer.borderWidth =4;
    [self.maleBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.FemaleBtn.layer.cornerRadius =10;
    self.FemaleBtn.layer.masksToBounds = YES;
    self.FemaleBtn.layer.borderWidth =4;
    [self.FemaleBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.genderbothBtn.layer.cornerRadius =10;
    self.genderbothBtn.layer.masksToBounds = YES;
    self.genderbothBtn.layer.borderWidth =4;
    [self.genderbothBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.avalableYesBtn.layer.cornerRadius =10;
    self.avalableYesBtn.layer.masksToBounds = YES;
    self.avalableYesBtn.layer.borderWidth =4;
    [self.avalableYesBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.avalableNoBtn.layer.cornerRadius =10;
    self.avalableNoBtn.layer.masksToBounds = YES;
    self.avalableNoBtn.layer.borderWidth =4;
    [self.avalableNoBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    self.avalableBothBtn.layer.cornerRadius =10;
    self.avalableBothBtn.layer.masksToBounds = YES;
    self.avalableBothBtn.layer.borderWidth =4;
    [self.avalableBothBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
}
-(void)loadInvalidSessionAlert:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [COMMON removeUserDetails];
    DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
    [self.navigationController pushViewController:objSplashView animated:NO];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=YES;
    appDelegate.SepratorLbl.hidden=YES;
    [appDelegate.locationButton setBackgroundImage:[UIImage imageNamed:@"loaction_normal.png"] forState:UIControlStateNormal];
}

#pragma mark - loadLocationUpdateAPI
-(void)loadLocationUpdateAPI{
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    if(deviceToken == nil)
        deviceToken = @"";
    if([COMMON isInternetReachable]){
        [objWebservice locationUpdate:LocationUpdate_API
                            sessionid:[COMMON getSessionID]
                             latitude:currentLatitude
                            longitude:currentLongitude
                          deviceToken:deviceToken
                             pushType:push_type
                              success:^(AFHTTPRequestOperation *operation, id responseObject){
                                  NSLog(@"responseObject = %@",responseObject);
                              }
                              failure:^(AFHTTPRequestOperation *operation, id error) {
                                  //[self showAltermessage:[NSString stringWithFormat:@"%@",error]];
                              }];
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

    
}
#pragma mark - nearestLocationWebserviceAPI
-(void)nearestLocationWebservice
{
    
    if([COMMON isInternetReachable]){
        [objWebservice nearestUsers:NearestUsers_API
                          sessionid:[COMMON getSessionID]
                           latitude:latitude
                          longitude:longitude
                      filter_status:onlineStatus
                      filter_gender:GenderStatus
                   filter_available:avalableStatus
                    filter_agerange:(filterAge==nil)?@"":filterAge
                    filter_distance:(filterDistance==nil)?@"":filterDistance
                               page:currentloadPage
                            success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSLog(@"response=%@",responseObject);
             recordCount =[[responseObject valueForKey:@"nearestusers"]valueForKey:@"recordCount"];
             //matchUserArray =[[responseObject valueForKey:@"nearestusers"]valueForKey:@"matchedUser"];
             
             //[self loadMatchActivityMethod];
             
             if ( responseObject !=nil && [[[responseObject valueForKey:@"nearestusers"]valueForKey:@"status"] isEqualToString:@"success"])
             {
                 
                 if ([[[responseObject valueForKey:@"nearestusers"]valueForKey:@"pageCount"] isEqualToString:@"1"])
                 {
                     NSMutableArray * nearestUserdetaile =[[NSMutableArray alloc]init];
                     nearestUserdetaile =[[responseObject valueForKey:@"nearestusers"] valueForKey:@"UserList"];
                     commonlocationArray =[nearestUserdetaile mutableCopy];
                     [locationCollectionView reloadData];
                 }
                 else
                 {
                     NSArray * nextpageUserdetaile =[[responseObject valueForKey:@"nearestusers"] valueForKey:@"UserList"];
                     for (NSDictionary *dict in nextpageUserdetaile)
                     {
                         [commonlocationArray addObject:dict];
                     }
                 }
                 [COMMON DSRemoveLoading];
             }
             else if([[[responseObject valueForKey:@"nearestusers"]valueForKey:@"status"] isEqualToString:@"error"])
             {
                 [COMMON removeUserDetails];
                 DSHomeViewController*objSplashView =[[DSHomeViewController alloc]initWithNibName:@"DSHomeViewController" bundle:nil];
                 [self.navigationController pushViewController:objSplashView animated:NO];
                 appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 appDelegate.buttonsView.hidden=YES;
                 appDelegate.SepratorLbl.hidden=YES;
                 [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];
             }
             else{
                 isAllPost = YES;
                 [COMMON DSRemoveLoading];
                 if([[[responseObject valueForKey:@"nearestusers"]valueForKey:@"status"] isEqualToString:@"failed"])
                 {
                     [commonlocationArray removeLastObject];
                     NSString * nearestuserMsg=[NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"nearestusers"]valueForKey:@"Message"]];
                     [self showAltermessage:nearestuserMsg];
                     
                 }
             }
             [refreshControl endRefreshing];
             
             [locationCollectionView reloadData];
         }
                            failure:^(AFHTTPRequestOperation *operation, id error)
         {
             [COMMON DSRemoveLoading];
         }];
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }
    
    
}

#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
       return [commonlocationArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    locationCellView = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCell" forIndexPath:indexPath];
    if(IS_IPHONE5)
        locationCellView.bounds = CGRectMake(0,0, 100, 180);
    if(IS_IPHONE6)
        locationCellView.bounds = CGRectMake(0,0, 100, 180);
    

    
    NSString *profileImg = [[commonlocationArray valueForKey:@"image1_thumb"] objectAtIndex:indexPath.row];
    
   
    NSString * firstname =[[commonlocationArray valueForKey:@"first_name"] objectAtIndex:indexPath.row];
    NSString * lastname  =[[commonlocationArray valueForKey:@"last_name"] objectAtIndex:indexPath.row];
    
    locationCellView.nameProfile.text =[NSString stringWithFormat:@"%@ %@", firstname, lastname];;
    locationCellView.kiloMeter.text=[[commonlocationArray valueForKey:@"distance"] objectAtIndex:indexPath.row];
    NSString * availableStr =[[commonlocationArray valueForKey:@"available_now"] objectAtIndex:indexPath.row];
    locationCellView.activeNow.text=([availableStr isEqualToString:@"Yes"])?@"NOW":@"";
    locationCellView.activeNow.backgroundColor=([availableStr isEqualToString:@"Yes"])?[UIColor whiteColor]:[UIColor clearColor];
    NSString* reguestStr = [[commonlocationArray valueForKey:@"send_request"] objectAtIndex:indexPath.row];
    
    locationCellView.sendRequest.text = ([reguestStr isEqualToString:@"No"])?@"Send Request":@"Request Sent!";
    
    locationCellView.sendRequest.textColor =([reguestStr isEqualToString:@"No"])?[UIColor whiteColor]:[UIColor lightGrayColor];
    locationCellView.hobbiesImagebackView.backgroundColor =([reguestStr isEqualToString:@"No"])?[UIColor colorWithRed:(218/255.0) green:(40/255.0) blue:(64.0/255.0f) alpha:1.0]:[UIColor whiteColor];
    
   NSMutableArray * dosomethingImageSprateArry =[[commonlocationArray valueForKey:@"dosomething"]objectAtIndex:indexPath.row];
    
      dosomethingImageArry =([reguestStr isEqualToString:@"No"])?[dosomethingImageSprateArry valueForKey:@"NearbyImage"]:[dosomethingImageSprateArry valueForKey:@"InactiveImage"];
     NSString *dosomethingImage1,* dosomethingImage2,* dosomethingImage3;
    
    if([dosomethingImageArry count]== 1){
        NSLog(@"count one");
        if(![[dosomethingImageArry objectAtIndex:0]isEqualToString:@""])
        {
            
            locationCellView.dosomethingImage1Xposition.constant=40;

            dosomethingImage1=[dosomethingImageArry objectAtIndex:0];
           
           [locationCellView.dosomethingImage1 setImageWithURL:[NSURL URLWithString:dosomethingImage1]];
            locationCellView.dosomethingImage2.image=[UIImage imageNamed:@""];
             locationCellView.dosomethingImage3.image=[UIImage imageNamed:@""];
            
        }
       

    }
    else if([dosomethingImageArry count] == 2){
         NSLog(@"count two");
        if(![[dosomethingImageArry objectAtIndex:0]isEqualToString:@""])
        {
              locationCellView.dosomethingImage1Xposition.constant=60;
            dosomethingImage1=[dosomethingImageArry objectAtIndex:0];
           
            [locationCellView.dosomethingImage1 setImageWithURL:[NSURL URLWithString:dosomethingImage1]];
            
        }
        if (![[dosomethingImageArry objectAtIndex:1] isEqualToString:@""])
        {
            dosomethingImage2=[dosomethingImageArry objectAtIndex:1];
            locationCellView.dosomethingImage2Xposition.constant=30;
            [locationCellView.dosomethingImage2 setImageWithURL:[NSURL URLWithString:dosomethingImage2]];
           
            locationCellView.dosomethingImage3.image=[UIImage imageNamed:@""];
            
        }

        
    }else {
   
          if(![[dosomethingImageArry objectAtIndex:0]isEqualToString:@""])
           {
                dosomethingImage1=[dosomethingImageArry objectAtIndex:0];
               locationCellView.dosomethingImage1Xposition.constant=10;
              [locationCellView.dosomethingImage1 setImageWithURL:[NSURL URLWithString:dosomethingImage1]];
               
           }
         if (![[dosomethingImageArry objectAtIndex:1] isEqualToString:@""])
        {
            dosomethingImage2=[dosomethingImageArry objectAtIndex:1];
            locationCellView.dosomethingImage2Xposition.constant=(IS_IPHONE6 || IS_IPHONE6_Plus)?5:8;
            [locationCellView.dosomethingImage2 setImageWithURL:[NSURL URLWithString:dosomethingImage2]];
           
        }
       if (![[dosomethingImageArry objectAtIndex:2]isEqualToString:@""])
        {
             dosomethingImage3=[dosomethingImageArry objectAtIndex:2];
            [locationCellView.dosomethingImage3 setImageWithURL:[NSURL URLWithString:dosomethingImage3]];
        }
    }
   
    
    if([profileImg isEqual: [NSNull null]] || [profileImg isEqualToString:@""])
    {
        [locationCellView.imageProfile setImage:[UIImage imageNamed:@"profile_noimg"]];
    }
    else
    {
        profileImg= [profileImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        downloadImageFromUrl(profileImg,locationCellView.imageProfile);
        
        
        [locationCellView.imageProfile setImage:[UIImage imageNamed:profileImg]];
   
    }
    
    locationCellView.imageProfile.layer.cornerRadius = locationCellView.imageProfile.frame.size.height/2;
    
    locationCellView.imageProfile.layer.masksToBounds = YES;
    
    [locationCellView.requestsendBtn addTarget:self action:@selector(didClickRequestSend:) forControlEvents:UIControlEventTouchUpInside];
   

    return locationCellView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize returnSize = CGSizeZero;
    if (IS_IPHONE6)
        returnSize = CGSizeMake((self.view.frame.size.width / 3.300f), 184);
    if(IS_IPHONE6_Plus)
        returnSize = CGSizeMake((self.view.frame.size.width / 3.300f), 182);
    if (IS_IPHONE4 ||IS_IPHONE5 )
        returnSize = CGSizeMake((self.view.frame.size.width / 3.300f), 184);
    
    return returnSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(IS_IPHONE6_Plus)
    {
        return UIEdgeInsetsMake(0,15, 0, 0);
    }
    else if(IS_IPHONE6)
    {
        return UIEdgeInsetsMake(0,0, 0,5);
    }
    else
    {
    return UIEdgeInsetsMake(0,0, 0, 0);
    }                                         // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    UICollectionViewCell *cell;
    
    if(isgestureenable ==YES)
    {
    cell = [collectionView cellForItemAtIndexPath:indexPath];
      
        if([detailsArray count] == 0)
        {
             detailsArray = [[commonlocationArray objectAtIndex:indexPath.row] mutableCopy];
        }
        
        DSNearByDetailViewController * detailViewController  = [[DSNearByDetailViewController alloc]initWithNibName:@"DSNearByDetailViewController" bundle:nil];
    
        detailViewController.userDetailsArray = detailsArray;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ((30-1) == indexPath.row && !isAllPost ) {
        
        int x = [currentloadPage intValue];
        
        x ++;
        
        currentloadPage= [NSString stringWithFormat:@"%d",x];
        
        [self nearestLocationWebservice];
        //[locationCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        
    }
    

}
#pragma mark Request Action
-(IBAction)didClickRequestSend:(id)sender
{
    if(isgestureenable==YES)
    {
    id button = sender;
    while (![button isKindOfClass:[UICollectionViewCell class]]) {
        button = [button superview];
    }
    
    NSIndexPath *indexPath;
    
    
    indexPath = [locationCollectionView indexPathForCell:(UICollectionViewCell *)button];
    locationCellView = (LocationCollectionViewCell *) [locationCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
 
     profileUserID=[[commonlocationArray valueForKey:@"user_id"] objectAtIndex:indexPath.row];
    
    NSString *onlineStausofSelectuser=[[commonlocationArray valueForKey:@"online_status"] objectAtIndex:indexPath.row];
       selectuserstatus =([onlineStausofSelectuser isEqualToString:@"1"])? @"Online":@"Offline";
        NSLog(@"%@",locationCellView.sendRequest.text);
    if([locationCellView.sendRequest.text isEqualToString:@"Send Request"])
    {
        UIButton *buttonSender = (UIButton *)sender;
        locationCellView.requestsendBtn = buttonSender;
        [locationCellView.hobbiesImagebackView setBackgroundColor:[UIColor whiteColor]];
        locationCellView.sendRequest.text =@"Request Sent!";
        locationCellView.sendRequest.textColor=[UIColor lightGrayColor];
        
       
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = [[commonlocationArray objectAtIndex:indexPath.row] mutableCopy];
        
        [dict removeObjectForKey:@"send_request"];
        [dict setObject:@"Yes" forKey:@"send_request"];
        detailsArray =[dict copy];
        
        dosomethingImageArry =[[[commonlocationArray valueForKey:@"dosomething"]objectAtIndex:indexPath.row] valueForKey:@"InactiveImage"];
        if([dosomethingImageArry count]== 1){
            NSLog(@"count one");
        }
        else if([dosomethingImageArry count] == 2){
            NSLog(@"count two");
        }else{
        
        NSString *dosomethingImage1=[dosomethingImageArry objectAtIndex:0];
        NSString *dosomethingImage2=[dosomethingImageArry objectAtIndex:1];
        NSString *dosomethingImage3=[dosomethingImageArry objectAtIndex:2];
        
       
        [locationCellView.dosomethingImage1 setImageWithURL:[NSURL URLWithString:dosomethingImage1]];
        [locationCellView.dosomethingImage2 setImageWithURL:[NSURL URLWithString:dosomethingImage2]];
        [locationCellView.dosomethingImage3 setImageWithURL:[NSURL URLWithString:dosomethingImage3]];
            
            
        }
        [self loadRequestsendWebService];
        
      
    }
      
    else if([locationCellView.sendRequest.text isEqualToString:@"Request Sent!"])
    {
        UIButton *buttonSender = (UIButton *)sender;
        locationCellView.requestsendBtn = buttonSender;
        [locationCellView.hobbiesImagebackView setBackgroundColor:[UIColor colorWithRed:(218/255.0) green:(40/255.0) blue:(64.0/255.0f) alpha:1.0]];
        locationCellView.sendRequest.text =@"Send Request";
        locationCellView.sendRequest.textColor=[UIColor whiteColor];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = [[commonlocationArray objectAtIndex:indexPath.row] mutableCopy];
        
        [dict removeObjectForKey:@"send_request"];
        [dict setObject:@"No" forKey:@"send_request"];
        detailsArray =[dict copy];
        
        
        
        dosomethingImageArry =[[[commonlocationArray valueForKey:@"dosomething"]objectAtIndex:indexPath.row] valueForKey:@"NearbyImage"];
        if([dosomethingImageArry count]== 1){
            NSLog(@"count one");
        }
        else if([dosomethingImageArry count] == 2){
            NSLog(@"count two");
        }else{
            
            NSString *dosomethingImage1=[dosomethingImageArry objectAtIndex:0];
            NSString *dosomethingImage2=[dosomethingImageArry objectAtIndex:1];
            NSString *dosomethingImage3=[dosomethingImageArry objectAtIndex:2];
            
            
            [locationCellView.dosomethingImage1 setImageWithURL:[NSURL URLWithString:dosomethingImage1]];
            [locationCellView.dosomethingImage2 setImageWithURL:[NSURL URLWithString:dosomethingImage2]];
            [locationCellView.dosomethingImage3 setImageWithURL:[NSURL URLWithString:dosomethingImage3]];
        }
        [self loadRequestsendWebService];
    }
        
        }
    }


#pragma mark - loadRequestsendWebServiceAPI
-(void)loadRequestsendWebService
{
    
    if([COMMON isInternetReachable]){
                    [objWebservice sendRequest:SendRequest_API
                                     sessionid:[COMMON getSessionID]
                                    request_send_user_id:profileUserID
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
                                {
                                    if([[[responseObject valueForKey:@"sendrequest"]valueForKey:@"status"] isEqualToString:@"success"])
                                    {
                                        matchUserArray =[[responseObject valueForKey:@"sendrequest"]valueForKey:@"Conversaion"];
                                         [self loadMatchActivityMethod];
                                        [self nearestLocationWebservice];
                                       
                                        
//                                        NSString * resposeMsg =[[responseObject valueForKey:@"sendrequest"]valueForKey:@"Message"];
//                                        [self showAltermessage:resposeMsg];
                 
                                    }
             
                                }
                             failure:^(AFHTTPRequestOperation *operation, id error)
                            {
                                NSLog(@"requestSend RESPONSE=%@",error);
                            }];
                            }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

    
}
-(IBAction)filterAction:(id)sender
{
    if(isFilteraction==NO)
    {
        self.collectionviewxpostion.constant =(IS_IPHONE6 || IS_IPHONE6_Plus)?-300:-245;
        self.FilterScrollviewYposition.constant=(IS_IPHONE6|| IS_IPHONE6_Plus)?80:58;
        self.FilterScrollviewWidth.constant    =(IS_IPHONE6|| IS_IPHONE6_Plus)?308:270;
        self.FilterScrollviewXposition.constant =(IS_IPHONE6|| IS_IPHONE6_Plus)?25:0;
        self.CollectionviewWidth.constant    =self.view.frame.size.width;
        self.filterviewxposition.constant    =(IS_IPHONE6_Plus)?104:65;
          [UIView animateWithDuration:0.5 animations:^{
             
              [self.view layoutIfNeeded];
            
             
               [self filterviewPosition];
          }];
        
       
            
            
            [customNavigation.FilterBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [customNavigation.FilterBtn setTitle:@"Apply" forState:UIControlStateNormal];
        
            appDelegate.settingButton.userInteractionEnabled=NO;
            isFilteraction=YES;
            [self.locationCollectionView setUserInteractionEnabled:YES];
            swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
            swiperight.direction=UISwipeGestureRecognizerDirectionRight;
            
            [self.locationCollectionView addGestureRecognizer:swiperight];
            
            isgestureenable=NO;

    }
    else if (isFilteraction==YES)
    {
        self.collectionviewxpostion.constant =10;
        self.CollectionviewWidth.constant    =self.view.frame.size.width-10;
        self.filterviewxposition.constant    = self.CollectionviewWidth.constant+10;
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view layoutIfNeeded];
            
             [self filterviewPosition];
           
        }];

        [customNavigation.FilterBtn setImage:[UIImage imageNamed:@"filerImage"] forState:UIControlStateNormal];
        [customNavigation.FilterBtn setTitle:@"" forState:UIControlStateNormal];
       
        isFilteraction=NO;
        [self.locationCollectionView setUserInteractionEnabled:YES];
        appDelegate.settingButton.userInteractionEnabled=YES;
        currentloadPage = @"";
        filterAge = ([filterAge isEqualToString:@""])?@"":filterAge;
        filterDistance=([filterDistance isEqualToString:@""])?@"":filterDistance;
        isgestureenable=YES;
       if( isfilterChange==YES)
       {
            [self nearestLocationWebservice];
           isfilterChange=NO;
       }
       
    }
   //self.upperLabel.text=@"";
    //self.lowerLabel.text=@"";
    //self.ageupperLabel.text=@"";
    //self.agelowerLabel.text =@"";
    
}
-(void)filterviewPosition
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.frame=CGRectMake(self.collectionviewxpostion.constant-10,self.view.frame.origin.y+self.view.frame.size.height-50,self.view.frame.size.width,50);
    appDelegate.SepratorLbl.frame =CGRectMake(self.collectionviewxpostion.constant-10,appDelegate.buttonsView.frame.origin.y-2,self.view.frame.size.width,3);

}
-(IBAction)StatusButtonAction:(id)sender
{
    if([sender tag] == 301)
    {
        self.onlineBtn.backgroundColor =[UIColor redColor];
        self.offlineBtn.backgroundColor =[UIColor whiteColor];
        self.statusBothBtn.backgroundColor=[UIColor whiteColor];
        onlineStatus=@"1";
        isfilterChange=YES;
        
    }
    else if ([sender tag] == 302)
    {
        self.onlineBtn.backgroundColor =[UIColor whiteColor];
        self.offlineBtn.backgroundColor =[UIColor redColor];
        self.statusBothBtn.backgroundColor=[UIColor whiteColor];
        onlineStatus =@"0";
        isfilterChange=YES;
    }
    else if ([sender tag] == 303)
    {
        self.onlineBtn.backgroundColor =[UIColor whiteColor];
        self.offlineBtn.backgroundColor =[UIColor whiteColor];
        self.statusBothBtn.backgroundColor=[UIColor redColor];
        onlineStatus =@"";
        isfilterChange=YES;
    }
    else if ([sender tag]== 304)
    {
        self.avalableYesBtn.backgroundColor =[UIColor redColor];
        self.avalableNoBtn.backgroundColor =[UIColor whiteColor];
        self.avalableBothBtn.backgroundColor=[UIColor whiteColor];
         avalableStatus=@"Yes";
         isfilterChange=YES;
        
    }
    else if ([sender tag] == 305)
    {
        self.avalableYesBtn.backgroundColor =[UIColor whiteColor];
        self.avalableNoBtn.backgroundColor =[UIColor redColor];
        self.avalableBothBtn.backgroundColor=[UIColor whiteColor];
        avalableStatus =@"No";
        isfilterChange=YES;
       
    }
    else if ([sender tag] == 306)
    {
        self.avalableYesBtn.backgroundColor =[UIColor whiteColor];
        self.avalableNoBtn.backgroundColor =[UIColor whiteColor];
        self.avalableBothBtn.backgroundColor=[UIColor redColor];
        avalableStatus =@"";
        isfilterChange=YES;
       
    }
    
    else if ([sender tag]== 307)
    {
        self.maleBtn.backgroundColor =[UIColor redColor];
        self.FemaleBtn.backgroundColor =[UIColor whiteColor];
        self.genderbothBtn.backgroundColor=[UIColor whiteColor];
        GenderStatus =@"male";
        isfilterChange=YES;
        
    }
    else if ([sender tag] == 308)
    {
        self.maleBtn.backgroundColor =[UIColor whiteColor];
        self.FemaleBtn.backgroundColor =[UIColor redColor];
        self.genderbothBtn.backgroundColor=[UIColor whiteColor];
        GenderStatus =@"female";
        isfilterChange=YES;
        
    }
    else if ([sender tag] == 309)
    {
        self.maleBtn.backgroundColor =[UIColor whiteColor];
        self.FemaleBtn.backgroundColor =[UIColor whiteColor];
        self.genderbothBtn.backgroundColor=[UIColor redColor];
        GenderStatus =@"";
        isfilterChange=YES;
    }
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
    if(IS_IPHONE6||IS_IPHONE6_Plus)
    {
        objCustomAlterview.mainalterviewheight.constant=50;
    }
    else
    {
        objCustomAlterview.mainalterviewheight.constant=0;
    }

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

#pragma mark - UIRefresh Control Delegate

- (void)releaseToRefresh:(UIRefreshControl *)_refreshControl
{
    currentloadPage=@"";
    avalableStatus=@"";
    GenderStatus =@"";
    onlineStatus  =@"";
    filterAge     =@"";
    filterDistance=@"";
    [self nearestLocationWebservice];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    isgestureenable=YES;
    self.collectionviewxpostion.constant =10;
    self.CollectionviewWidth.constant    =self.view.frame.size.width-10;
    self.filterviewxposition.constant    = self.CollectionviewWidth.constant+10;
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view layoutIfNeeded];
        
        [self filterviewPosition];
        
    }];
    //[self filterviewPosition];
    isFilteraction=NO;
    [locationCellView setUserInteractionEnabled:YES];
    
    
    [customNavigation.FilterBtn setImage:[UIImage imageNamed:@"filerImage"] forState:UIControlStateNormal];
    [customNavigation.FilterBtn setTitle:@"" forState:UIControlStateNormal];
    
   
    appDelegate.settingButton.userInteractionEnabled=YES;
    currentloadPage =@"";
   
}

-(IBAction)DidClickClearFilter:(id)sender
{
    self.onlineBtn.backgroundColor =[UIColor whiteColor];
    self.offlineBtn.backgroundColor =[UIColor whiteColor];
    self.statusBothBtn.backgroundColor=[UIColor redColor];
    onlineStatus =@"";
    
    self.maleBtn.backgroundColor =[UIColor whiteColor];
    self.FemaleBtn.backgroundColor =[UIColor whiteColor];
    self.genderbothBtn.backgroundColor=[UIColor redColor];
    GenderStatus =@"";
    
    self.avalableYesBtn.backgroundColor =[UIColor whiteColor];
    self.avalableNoBtn.backgroundColor =[UIColor whiteColor];
    self.avalableBothBtn.backgroundColor=[UIColor redColor];
    avalableStatus=@"";

    [self configureLabelSlider];
    [self configureAgeChangeSlider];
    //self.upperLabel.text=@"";
    //self.lowerLabel.text=@"";
    //self.ageupperLabel.text=@"";
   // self.agelowerLabel.text =@"";
    filterAge=@"";  //18-26
    filterDistance=@"";  //0-5
    isfilterChange=YES;
}


#pragma mark - Label  Slider

- (void) configureMetalThemeForSlider:(NMRangeSlider*) slider
{
    UIImage* image = nil;

    image = [UIImage imageNamed:@"backgroundImg"];  //slider-metal-trackBackground
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
    slider.trackBackgroundImage = image;

    image = [UIImage imageNamed:@"dot_active_red"];    //slider-metal-track
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    slider.trackImage = image;

    image = [UIImage imageNamed:@"Filter_track"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0,0,0,0)];
    slider.lowerHandleImageNormal = image;
    slider.upperHandleImageNormal = image;

    image = [UIImage imageNamed:@"Filter_track"];          //slider-metal-handle-highlighted
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0,0, 0,0)];
    slider.lowerHandleImageHighlighted = image;
    slider.upperHandleImageHighlighted = image;
}
- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 100;
    
    self.labelSlider.minimumRange = 0;
   [self configureMetalThemeForSlider:self.labelSlider];
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 100;
    self.upperLabel.text   =@"100";
    self.lowerLabel.text   =@"0";
}

- (void) updateDistanceSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x+12);
    lowerCenter.y = (self.labelSlider.center.y - 15.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x+12);
    upperCenter.y = (self.labelSlider.center.y - 15.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
    
    NSString * filterdistanceStr   =[NSString stringWithFormat:@"%@-%@",self.lowerLabel.text,self.upperLabel.text];


     filterDistance=([filterdistanceStr isEqual:@"0-0"])?@"":filterdistanceStr;
     isfilterChange=YES;
}


- (void) configureAgeChangeSlider
{
    self.labelSlider1.minimumValue = 18;
    //self.labelSlider1.upperHandleHidden = YES;
    self.labelSlider1.maximumValue = 80;
    
    self.labelSlider1.lowerValue = 18;
    self.labelSlider1.upperValue = 80;
    
    
    [self configureMetalThemeForSlider:self.labelSlider1];
    
    self.labelSlider1.lowerValue = 18;
    self.labelSlider1.upperValue = 80;
    self.ageupperLabel.text         =@"80+";
    self.agelowerLabel.text        =@"18";
}

- (void) updateAgeSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider1.lowerCenter.x + self.labelSlider1.frame.origin.x+8);
    lowerCenter.y = (self.labelSlider1.center.y - 20.0f);
    self.agelowerLabel.center = lowerCenter;
    self.agelowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider1.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider1.upperCenter.x + self.labelSlider1.frame.origin.x+12);
    upperCenter.y = (self.labelSlider1.center.y - 20.0f);
    self.ageupperLabel.center = upperCenter;
    NSString *upperlable;
    if(self.labelSlider1.upperValue==80)
    {
        upperlable=[NSString stringWithFormat:@"%d",(int)self.labelSlider1.upperValue];
       self.ageupperLabel.text = [NSString stringWithFormat:@"%d+",(int)self.labelSlider1.upperValue];
    }
    else
    {
        upperlable=[NSString stringWithFormat:@"%d",(int)self.labelSlider1.upperValue];
        self.ageupperLabel.text = [NSString stringWithFormat:@"%d",(int)self.labelSlider1.upperValue];
    }
   NSString*agefilterSTr =[NSString stringWithFormat:@"%@-%@",self.agelowerLabel.text,upperlable
                           ];
    
    if([self.agelowerLabel.text isEqualToString:@"80"])
    {
        filterAge=[NSString stringWithFormat:@"%@",self.agelowerLabel.text];
    }
    else
    {
        filterAge=([agefilterSTr isEqual:@"18-80"])?@"":agefilterSTr;
    }
    isfilterChange=YES;

}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateDistanceSliderLabels];
}
-(IBAction)ageSliderChanged:(id)sender
{
    [self updateAgeSliderLabels];
}

-(IBAction)didClickmatchuserDosomethingBtnAction:(id)sender
{
    self.walkAlterview.hidden =YES;
    self.blueCircle.hidden=YES;
    self.matchActivityView.hidden =YES;
    DSChatDetailViewController *ChatDetail =[[DSChatDetailViewController alloc]initWithNibName:nil bundle:nil];
    NSMutableDictionary *matchuserdic = [[NSMutableDictionary alloc] init];
    ChatDetail.status =selectuserstatus;
    matchuserdic = (self.senduserDetail.count > 0)?[self.senduserDetail mutableCopy]:[matchUserArray mutableCopy];
    ChatDetail.conversionID=sendrequestConversationID;
    ChatDetail.chatuserDetailsDict = matchuserdic;
    
    [self.navigationController pushViewController:ChatDetail animated:YES];
 
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    if (buttonIndex == 0)
    {
        //code for opening settings app in iOS 8
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)RequestSendNotification
{
    if(matchUserArray !=0 && ![matchUserArray isEqual:@"0"])
    {
        self.matchActivityView.hidden =NO;
        if(IS_IPHONE6)
        {
            self.MatchImgviewXposition.constant=50;
        }
        else if (IS_IPHONE6_Plus)
        {
            self.MatchImgviewXposition.constant=70;
        }
        else
        {
            self.MatchImgviewXposition.constant=20;
        }
        self.MatchImgviewYposition.constant=(IS_IPHONE6||IS_IPHONE6_Plus)?170:130;
        NSString *matchprofileImg =[matchUserArray valueForKey:@"image1"];
        if([matchprofileImg isEqualToString:@""] || matchprofileImg ==nil)
        {
            [self.currentUserImg setImage:[UIImage imageNamed:@"profile_noimg"]];
        }
        else
        {
            matchprofileImg= [matchprofileImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            downloadImageFromUrl(matchprofileImg,self.currentUserImg);
            [self.currentUserImg setImage:[UIImage imageNamed:matchprofileImg]];
        }
        
        currentuser=[[NSMutableDictionary alloc]init];
        currentuser =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
        NSString *objCurrentuserImg=[currentuser valueForKey:@"image1_thumb"];
        if([objCurrentuserImg isEqualToString:@""] || objCurrentuserImg ==nil)
        {
            [self.matcheduserImg setImage:[UIImage imageNamed:@"profile_noimg"]];
        }
        else
        {
            objCurrentuserImg= [objCurrentuserImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            downloadImageFromUrl(objCurrentuserImg,self.matcheduserImg);
            
            [self.matcheduserImg setImage:[UIImage imageNamed:objCurrentuserImg]];
        }
        
        
        
        self.currentUserImg .layer.cornerRadius = 60;
        self.currentUserImg .clipsToBounds = YES;
        self.currentUserImg.layer.borderWidth=1;
        [self.currentUserImg.layer setBorderColor:[UIColor redColor].CGColor];
        
        self.matcheduserImg .layer.cornerRadius = 60;
        self.matcheduserImg .clipsToBounds = YES;
        self.matcheduserImg.layer.borderWidth=1;
        [self.matcheduserImg.layer setBorderColor:[UIColor redColor].CGColor];
        
        NSString*objmatchusername =[NSString stringWithFormat:@"You and %@ are a match \n Start Chatting to",[currentuser valueForKey:@"first_name"]];
        self.matchActivitylbl.text =objmatchusername;
    }
    else{
        self.matchActivityView.hidden =YES;
    }

}

-(IBAction)didClickGeneralWalkAlterviewBtn:(id)sender
{
    self.walkAlterview.hidden=YES;
    self.window.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GerenalWalkAlterview
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIImageView * blueCirecleImg;
    UIView * altermsgView;
    
    
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
       
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.window.center.x-80,self.window.center.y,140,60)];
         blueCirecleImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.window.frame.size.width-75,self.window.center.y+120,20,20)];

    }
    else{
        
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.window.center.x-80,self.window.center.y+40,140,60)];
        blueCirecleImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.window.frame.size.width-63,self.window.center.y+153,20,20)];
    }
    

    blueCirecleImg.image=[UIImage imageNamed:@"BlueCirecleimg"];
    blueCirecleImg.userInteractionEnabled=YES;
    [self.window addSubview:blueCirecleImg];

    
    UIImageView * blueTxtImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,140,60)];
    blueTxtImg.userInteractionEnabled=YES;
    blueTxtImg.image=[UIImage imageNamed:@"BlueBgText"];
    [altermsgView addSubview:blueTxtImg];
    UILabel * AlterMsg=[[UILabel alloc]initWithFrame:CGRectMake(0,0,140,60)];
    AlterMsg.text =@"Send a request to any user \n on the list";
    AlterMsg.textColor=[UIColor whiteColor];
    AlterMsg.textAlignment= NSTextAlignmentCenter;
    AlterMsg.numberOfLines=2;
    [AlterMsg setFont:[UIFont fontWithName:@"Patron-Regular" size:10]];
    [altermsgView addSubview:AlterMsg];
    
    
    [self.window addSubview:altermsgView];
    
    UIButton * ClosewindowBtn =[[UIButton alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [ClosewindowBtn addTarget:self action:@selector(didClickGeneralWalkAlterviewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.window addSubview:CommWalkView];
    [self.window addSubview:ClosewindowBtn];
    self.window.hidden=NO;
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor =[UIColor colorWithRed:(53.0/255.0f) green:(53.0/255.0f) blue:(53.0/255.0f) alpha:0.5];
    
    //[self.view addSubview:self.window];
    
}

@end
