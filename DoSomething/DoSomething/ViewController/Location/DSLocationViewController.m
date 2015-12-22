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

#define hobbiesbackcolor = [UIColor colorWithRed: (199.0/255.0) green: (65.0/255.0) blue: (81.0/255.0) alpha: 1.0];

@interface DSLocationViewController ()<CLLocationManagerDelegate>
{
    CustomAlterview *objCustomAlterview;
    DSWebservice *objWebservice;
    AppDelegate *appDelegate;
    
    NSString * longitude;
    NSString * latitude;
    BOOL isFilteraction;
    NSString  * currentLatitude, * currentLongitude;
    BOOL isLoadData;
    NSString *profileUserID;
    UILabel * usernotfoundlbl;
     UIRefreshControl *refreshControl;
    BOOL              isAllPost;
     NSString          *currentloadPage;
    
    NSString * onlineStatus;
    NSString * avalibleGenderStatus;
    LocationCollectionViewCell*locationCellView;
    NSString * filterAge;
    NSString * filterDistance;
    BOOL isLoadWebservice;
     CustomNavigationView *customNavigation;
    
    
}
@property(nonatomic,strong)IBOutlet NSLayoutConstraint * collectionviewxpostion;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint * filterviewxposition;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint * CollectionviewWidth;
@property (nonatomic,strong)  CLLocationManager       *  locationManager;

@property(nonatomic,strong) IBOutlet UIButton *onlineBtn;
@property(nonatomic,strong) IBOutlet UIButton *offlineBtn;
@property(nonatomic,strong) IBOutlet UIButton *statusBothBtn;
@property(nonatomic,strong) IBOutlet UIButton *maleBtn;
@property(nonatomic,strong) IBOutlet UIButton *FemaleBtn;
@property(nonatomic,strong) IBOutlet UIButton *avablebothBtn;


@property(nonatomic,strong) IBOutlet UISwipeGestureRecognizer * locationviewSwipright;

@end

@implementation DSLocationViewController
@synthesize delegate;
@synthesize locationCollectionView,locationManager;
@synthesize profileImages,profileNames,kiloMeterlabel,userID,dosomethingImageArry,commonlocationArray;
- (void)viewDidLoad {
    
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(releaseToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.locationCollectionView addSubview:refreshControl];

    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    latitude     =[dic valueForKey:@"latitude"];
    longitude    =[dic valueForKey:@"longitude"];
    
   
    onlineStatus=@"";
    avalibleGenderStatus=@"";
    objWebservice =[[DSWebservice alloc]init];
    
    
    [super viewDidLoad];
    isLoadData=NO;
    isLoadWebservice=YES;
    
    
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
    [self getUserCurrenLocation];
    [self loadCustomNavigationview];
    UINib *cellNib = [UINib nibWithNibName:@"LocationCollectionViewCell" bundle:nil];
    [self.locationCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LocationCell"];
    
    locationCollectionView.delegate=self;
    locationCollectionView.dataSource=self;
    profileImages =[[NSArray alloc]init];
    profileNames =[[NSArray alloc]init];
    dosomethingImageArry=[[NSMutableArray alloc]init];
    kiloMeterlabel =[[NSArray alloc]init];
    commonlocationArray =[[NSMutableArray alloc]init];
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
        //self.CollectionviewWidth.constant =self.view.frame.size.width+100;
        self.filterviewxposition.constant =self.view.frame.size.width ;
        
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

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.locationCollectionView addGestureRecognizer:swiperight];
    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"dot_Image"] forState:UIControlStateNormal];
    
    
    
    
    
}
-(void)loadCustomNavigationview
{
   
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
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
    
//   usernotfoundlbl=[[UILabel alloc]initWithFrame:CGRectMake(self.locationCollectionView.frame.origin.x,self.locationCollectionView.center.y-30,self.locationCollectionView.frame.size.width,30)];
//    usernotfoundlbl.numberOfLines =10;
//    
//    usernotfoundlbl.textAlignment=NSTextAlignmentCenter;
//    usernotfoundlbl.font=Patron_Bold(10);
//    usernotfoundlbl.hidden=YES;
//    [self.locationCollectionView addSubview:usernotfoundlbl];

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
    
    self.avablebothBtn.layer.cornerRadius =10;
    self.avablebothBtn.layer.masksToBounds = YES;
    self.avablebothBtn.layer.borderWidth =4;
    [self.avablebothBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
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
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"nearByLocationCommonArray"] == 0)
    {
    [self nearestLocationWebservice];
        
    }
    else
    {
        commonlocationArray =[[NSUserDefaults standardUserDefaults]valueForKey:@"nearByLocationCommonArray"];
        [locationCollectionView reloadData];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadLocationUpdateAPI];
        
        
    });
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}

-(void)loadLocationUpdateAPI{
    
    [objWebservice locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              NSLog(@"responseObject = %@",responseObject);
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              
                              [self showAltermessage:[NSString stringWithFormat:@"%@",error]];
                          }];
    
    
}

-(void)nearestLocationWebservice
{
    [COMMON LoadIcon:self.view];
       [objWebservice nearestUsers:NearestUsers_API
                         sessionid:[COMMON getSessionID]
                          latitude:latitude
                         longitude:longitude
                     filter_status:onlineStatus
                     filter_gender:avalibleGenderStatus
                   filter_agerange:(filterAge==nil)?@"":filterAge
                   filter_distance:(filterDistance==nil)?@"":filterDistance
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if([[[responseObject valueForKey:@"nearestusers"]valueForKey:@"status"] isEqualToString:@"success"])
        {
            NSMutableArray * nearestUserdetaile =[[NSMutableArray alloc]init];
            nearestUserdetaile =[[responseObject valueForKey:@"nearestusers"] valueForKey:@"UserList"];
            commonlocationArray =[nearestUserdetaile mutableCopy];
             [[NSUserDefaults standardUserDefaults] setObject:commonlocationArray forKey:@"nearByLocationCommonArray"];
                [locationCollectionView reloadData];
                    NSLog(@"%@",nearestUserdetaile);
            
           
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
             else
             {
                 //usernotfoundlbl.hidden=NO;
                // usernotfoundlbl.text  =[[responseObject valueForKey:@"nearestusers"]valueForKey:@"Message"];
             }
        
            [COMMON removeLoading];
//         }
//         else{
//             isAllPost = YES;
//             [COMMON removeLoading];
//         }
        [refreshControl endRefreshing];
}
    failure:^(AFHTTPRequestOperation *operation, id error) {
        
        [COMMON removeLoading];
        //usernotfoundlbl.hidden=NO;
        //usernotfoundlbl.text  =[NSString stringWithFormat:@"%@",error];
        
        
        
    } ];
}



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
    

    
    NSString *MyPatternString = [[commonlocationArray valueForKey:@"image1"] objectAtIndex:indexPath.row];
    
    locationCellView.nameProfile.text =[[commonlocationArray valueForKey:@"first_name"] objectAtIndex:indexPath.row];
    locationCellView.kiloMeter.text=[[commonlocationArray valueForKey:@"distance"] objectAtIndex:indexPath.row];
    NSString * availableStr =[[commonlocationArray valueForKey:@"available_now"] objectAtIndex:indexPath.row];
    locationCellView.activeNow.text=([availableStr isEqualToString:@"Yes"])?@"NOW":@"";
    locationCellView.activeNow.backgroundColor=([availableStr isEqualToString:@"Yes"])?[UIColor whiteColor]:[UIColor clearColor];
    NSString* reguestStr = [[commonlocationArray valueForKey:@"send_request"] objectAtIndex:indexPath.row];
    
    locationCellView.sendRequest.text = ([reguestStr isEqualToString:@"No"])?@"Send Request":@"Request Sent!";
    
    locationCellView.sendRequest.textColor =([reguestStr isEqualToString:@"No"])?[UIColor whiteColor]:[UIColor lightGrayColor];
    locationCellView.hobbiesImagebackView.backgroundColor =([reguestStr isEqualToString:@"No"])?[UIColor colorWithRed:(218/255.0) green:(40/255.0) blue:(64.0/255.0f) alpha:1.0]:[UIColor whiteColor];
    
   NSMutableArray * dosomethingImageSprateArry =[[commonlocationArray valueForKey:@"dosomething"]objectAtIndex:indexPath.row];
     NSLog(@"indexPath.row=%ld",(long)indexPath.row);
   
   
    dosomethingImageArry =([reguestStr isEqualToString:@"No"])?[dosomethingImageSprateArry valueForKey:@"NearbyImage"]:[dosomethingImageSprateArry valueForKey:@"InactiveImage"];
    
   
    NSString *dosomethingImage1=[dosomethingImageArry objectAtIndex:0];
    NSString *dosomethingImage2=[dosomethingImageArry objectAtIndex:1];
    NSString *dosomethingImage3=[dosomethingImageArry objectAtIndex:2];

    
    [locationCellView.dosomethingImage1 setImageWithURL:[NSURL URLWithString:dosomethingImage1]];
     [locationCellView.dosomethingImage2 setImageWithURL:[NSURL URLWithString:dosomethingImage2]];
     [locationCellView.dosomethingImage3 setImageWithURL:[NSURL URLWithString:dosomethingImage3]];
    
    MyPatternString= [MyPatternString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(MyPatternString == nil || [MyPatternString isEqualToString:@""])
    {
        [locationCellView.imageProfile setImage:[UIImage imageNamed:@"profile_noimg"]];
    }
    else
    {
        downloadImageFromUrl(MyPatternString,locationCellView.imageProfile);
        
        
        [locationCellView.imageProfile setImage:[UIImage imageNamed:MyPatternString]];
   
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
        returnSize = CGSizeMake((self.view.frame.size.width / 3.800f), 160);
    if(IS_IPHONE6_Plus)
        returnSize = CGSizeMake((self.view.frame.size.width / 3.800f), 190);
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
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    profileUserID=[[commonlocationArray valueForKey:@"user_id"] objectAtIndex:indexPath.row];
    NSLog(@"profileUserID%@",profileUserID);
    
    
    [self getUserDetails];
    
    NSLog(@"%ld", (long)indexPath.row);
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"profileNames count=%lu",(unsigned long)commonlocationArray.count);
    if (([commonlocationArray count]-1) == indexPath.row ) {
        
        int x = [currentloadPage intValue];
        
        x ++;
        
        currentloadPage= [NSString stringWithFormat:@"%d",x];
        
        //[self nearestLocationWebservice];
        
    }

}


-(void)getUserDetails{
    
    [COMMON LoadIcon:self.view];
    [objWebservice getUserDetails:UserDetails_API
                        sessionid:[COMMON getSessionID]
                  profile_user_id:profileUserID
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if( [responseObject objectForKey:@"getuserdetails"]!=NULL){
                                                                    
                                  [self redirectToDetailViewWithDictionary:[[responseObject objectForKey:@"getuserdetails"]objectForKey:@"userDetails"]];
                                  [COMMON removeLoading];
                              }
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              NSLog(@"error%@",error);
                          }];
}
- (void) redirectToDetailViewWithDictionary:(NSMutableDictionary *) detailsDictionary {
    
   // DSDetailViewController* detailViewController = [[DSDetailViewController alloc] init];
    DSNearByDetailViewController* detailViewController = [[DSNearByDetailViewController alloc] init];
    detailViewController.userDetailsDict = detailsDictionary;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)didClickRequestSend:(id)sender
{
    id button = sender;
    while (![button isKindOfClass:[UICollectionViewCell class]]) {
        button = [button superview];
    }
    
    NSIndexPath *indexPath;
    
    
    indexPath = [locationCollectionView indexPathForCell:(UICollectionViewCell *)button];
    locationCellView = (LocationCollectionViewCell *) [locationCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
 
     profileUserID=[[commonlocationArray valueForKey:@"user_id"] objectAtIndex:indexPath.row];
        NSLog(@"%@",profileUserID);
    NSString * requestsend=[[commonlocationArray valueForKey:@"send_request"] objectAtIndex:indexPath.row];
    if([requestsend isEqualToString:@"No"])
    {
        [self loadRequestsendWebService];
    }
}
    
-(void)loadRequestsendWebService
{
    [objWebservice sendRequest:SendRequest_API sessionid:[COMMON getSessionID] request_send_user_id:profileUserID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[[responseObject valueForKey:@"sendrequest"]valueForKey:@"status"] isEqualToString:@"success"])
        {
            NSString * resposeMsg =[[responseObject valueForKey:@"sendrequest"]valueForKey:@"Message"];
            [self showAltermessage:resposeMsg];
        }
        [locationCollectionView reloadData];

       
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
         NSLog(@"requestSend RESPONSE=%@",error);
        
    }];
}
    
//    profileUserID=[[commonlocationArray valueForKey:@"user_id"] objectAtIndex:indexPath.row];
//    NSLog(@"profileUserID%@",profileUserID);


-(IBAction)filterAction:(id)sender
{
    if(isFilteraction==NO)
    {
        self.collectionviewxpostion.constant =(IS_IPHONE6 || IS_IPHONE6_Plus)?-300:-250;
        self.CollectionviewWidth.constant    =self.view.frame.size.width;
        self.filterviewxposition.constant    =65;
        [customNavigation.FilterBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [customNavigation.FilterBtn setTitle:@"Apply" forState:UIControlStateNormal];
        [self filterviewPosition];
        isFilteraction=YES;
        [self.locationCollectionView setUserInteractionEnabled:YES];
        [self nearestLocationWebservice];
    }
    else if (isFilteraction==YES)
    {
        self.collectionviewxpostion.constant =10;
        self.CollectionviewWidth.constant    =self.view.frame.size.width-10;
        self.filterviewxposition.constant    = self.CollectionviewWidth.constant+10;
        [customNavigation.FilterBtn setImage:[UIImage imageNamed:@"filerImage"] forState:UIControlStateNormal];
        [customNavigation.FilterBtn setTitle:@"" forState:UIControlStateNormal];
        [self filterviewPosition];
        isFilteraction=NO;
        [self.locationCollectionView setUserInteractionEnabled:YES];
        
    }
    
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
        
    }
    else if ([sender tag] == 302)
    {
        self.onlineBtn.backgroundColor =[UIColor whiteColor];
        self.offlineBtn.backgroundColor =[UIColor redColor];
        self.statusBothBtn.backgroundColor=[UIColor whiteColor];
        onlineStatus =@"0";
        
    }
    else if ([sender tag] == 303)
    {
        self.onlineBtn.backgroundColor =[UIColor whiteColor];
        self.offlineBtn.backgroundColor =[UIColor whiteColor];
        self.statusBothBtn.backgroundColor=[UIColor redColor];
        onlineStatus =@"";
    }
    else if ([sender tag]== 304)
    {
        self.maleBtn.backgroundColor =[UIColor redColor];
        self.FemaleBtn.backgroundColor =[UIColor whiteColor];
        self.avablebothBtn.backgroundColor=[UIColor whiteColor];
         avalibleGenderStatus =@"male";
        
    }
    else if ([sender tag] == 305)
    {
        self.maleBtn.backgroundColor =[UIColor whiteColor];
        self.FemaleBtn.backgroundColor =[UIColor redColor];
        self.avablebothBtn.backgroundColor=[UIColor whiteColor];
        avalibleGenderStatus =@"female";
       
    }
    else if ([sender tag] == 306)
    {
        self.maleBtn.backgroundColor =[UIColor whiteColor];
        self.FemaleBtn.backgroundColor =[UIColor whiteColor];
        self.avablebothBtn.backgroundColor=[UIColor redColor];
        avalibleGenderStatus =@"";
       
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

#pragma mark - UIRefresh Control Delegate

- (void)releaseToRefresh:(UIRefreshControl *)_refreshControl
{
    currentloadPage=@"1";
    [self nearestLocationWebservice];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.collectionviewxpostion.constant =10;
    self.CollectionviewWidth.constant    =self.view.frame.size.width-10;
    self.filterviewxposition.constant    = self.CollectionviewWidth.constant+10;
    [self filterviewPosition];
    isFilteraction=NO;
    [self.locationCollectionView setUserInteractionEnabled:YES];
}

-(IBAction)DidClickClearFilter:(id)sender
{
    self.onlineBtn.backgroundColor =[UIColor whiteColor];
    self.offlineBtn.backgroundColor =[UIColor whiteColor];
    self.statusBothBtn.backgroundColor=[UIColor redColor];
    onlineStatus =@"";
    
    self.maleBtn.backgroundColor =[UIColor whiteColor];
    self.FemaleBtn.backgroundColor =[UIColor whiteColor];
    self.avablebothBtn.backgroundColor=[UIColor redColor];
    avalibleGenderStatus =@"";
    self.ageSlider.value =18;
    self.distanceSlider.value=0;
    
}
- (IBAction)AgeSliderValueChanged:(UISlider *)sender {
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"dot_Image.png"] stretchableImageWithLeftCapWidth:8 topCapHeight: 0];
    [self.ageSlider setMinimumTrackImage:sliderLeftTrackImage forState: UIControlStateNormal];
    filterAge =[NSString stringWithFormat:@"18-%f", [sender value]];
    
    NSLog(@"AgeSliderValueChanged=%@",[NSString stringWithFormat:@"%f", [sender value]]);
}

- (IBAction)distanceSliderValueChanged:(UISlider *)sender {
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"dot_Image.png"] stretchableImageWithLeftCapWidth: 8 topCapHeight: 0];

    [self.distanceSlider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    filterDistance=[NSString stringWithFormat:@"0-%f", [sender value]];
  
    NSLog(@"distanceSliderValueChanged=%@",[NSString stringWithFormat:@"%f", [sender value]]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
