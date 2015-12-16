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
#import "DSDetailViewController.h"
#import "CustomAlterview.h"
@interface DSLocationViewController ()<CLLocationManagerDelegate>
{
    CustomAlterview *objCustomAlterview;
    DSWebservice *objWebservice;
    AppDelegate *appDelegate;
    NSString * strsessionID;
    NSString * longitude;
    NSString * laditude;
    BOOL isFilteraction;
    NSString  * currentLatitude, * currentLongitude;
    BOOL isLoadData;
    NSString *profileUserID;
    UILabel * usernotfoundlbl;
}
@property(nonatomic,strong)IBOutlet NSLayoutConstraint *collectionviewxpostion;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint * filterviewxposition;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint *sepratorXposition;
@property (nonatomic,strong)  CLLocationManager       * locationManager;

@property(nonatomic,strong) IBOutlet UIButton *onlineBtn;
@property(nonatomic,strong) IBOutlet UIButton *offlineBtn;
@property(nonatomic,strong) IBOutlet UIButton *statusBothBtn;
@property(nonatomic,strong) IBOutlet UIButton *maleBtn;
@property(nonatomic,strong) IBOutlet UIButton *FemaleBtn;
@property(nonatomic,strong) IBOutlet UIButton *avablebothBtn;

@end

@implementation DSLocationViewController
@synthesize delegate;
@synthesize locationCollectionView,locationManager;
@synthesize profileImages,profileNames,kiloMeterlabel,userID;
- (void)viewDidLoad {
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    
    strsessionID =[dic valueForKey:@"SessionId"];
    longitude    =[dic valueForKey:@"longitude"];
    laditude     =[dic valueForKey:@"latitude"];
    NSLog(@"usersessionID:%@",strsessionID);
    
    objWebservice =[[DSWebservice alloc]init];
    
    
    [super viewDidLoad];
    isLoadData=NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self getUserCurrenLocation];
    [self loadCustomNavigationview];
    UINib *cellNib = [UINib nibWithNibName:@"LocationCollectionViewCell" bundle:nil];
    [self.locationCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LocationCell"];
    
    locationCollectionView.delegate=self;
    locationCollectionView.dataSource=self;
    profileImages =[[NSArray alloc]init];
    profileNames =[[NSArray alloc]init];
    kiloMeterlabel =[[NSArray alloc]init];
    
    
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

    
    
}
-(void)loadCustomNavigationview
{
    CustomNavigationView *customNavigation;
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
    
   usernotfoundlbl=[[UILabel alloc]initWithFrame:CGRectMake(self.locationCollectionView.frame.origin.x,self.locationCollectionView.center.y-30,self.locationCollectionView.frame.size.width,30)];
    usernotfoundlbl.numberOfLines =10;
    
    usernotfoundlbl.textAlignment=NSTextAlignmentCenter;
    usernotfoundlbl.font=Patron_Bold(10);
    usernotfoundlbl.hidden=YES;
    [self.locationCollectionView addSubview:usernotfoundlbl];

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
    [self nearestLocationWebservice];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}


-(void)nearestLocationWebservice
{
    [COMMON LoadIcon:self.view];
       [objWebservice nearestUsers:NearestUsers_API
                         sessionid:strsessionID
                          latitude:currentLatitude
                         longitude:currentLongitude
                     filter_status:@""
                     filter_gender:@""
                   filter_agerange:@""
                   filter_distance:@""
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if([[[responseObject valueForKey:@"nearestusers"]valueForKey:@"status"] isEqualToString:@"success"])
        {
            NSMutableArray * nearestUserdetaile =[[NSMutableArray alloc]init];
            nearestUserdetaile =[[responseObject valueForKey:@"nearestusers"] valueForKey:@"UserList"];
            profileNames     =[nearestUserdetaile valueForKey:@"first_name"];
            kiloMeterlabel   =[nearestUserdetaile valueForKey:@"distance"];
            profileImages    =[nearestUserdetaile valueForKey:@"image1"];
            userID           =[nearestUserdetaile valueForKey:@"user_id"];
            
                    [locationCollectionView reloadData];
                    NSLog(@"%@",nearestUserdetaile);
            
           
             }
             else
             {
                 usernotfoundlbl.hidden=NO;
                 usernotfoundlbl.text  =[[responseObject valueForKey:@"nearestusers"]valueForKey:@"Message"];
             }
        
            [COMMON removeLoading];
        
        
        }
    failure:^(AFHTTPRequestOperation *operation, id error) {
        
        [COMMON removeLoading];
        usernotfoundlbl.hidden=NO;
        usernotfoundlbl.text  =[NSString stringWithFormat:@"%@",error];
        
        
        
    } ];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [profileNames count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LocationCollectionViewCell*locationCellView = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCell" forIndexPath:indexPath];
    if(IS_IPHONE5)
        locationCellView.bounds = CGRectMake(0,0, 100, 180);
    if(IS_IPHONE6)
        locationCellView.bounds = CGRectMake(0,0, 100, 180);
    
    NSString *MyPatternString = [profileImages objectAtIndex:indexPath.row];
    
    locationCellView.nameProfile.text =[profileNames objectAtIndex:indexPath.row];
    locationCellView.kiloMeter.text=[kiloMeterlabel objectAtIndex:indexPath.row];
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
     // LocationCollectionViewCell*SelectCell = (LocationCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    profileUserID=[userID objectAtIndex:indexPath.row];
    NSLog(@"profileUserID%@",profileUserID);
    
    
    [self getUserDetails];
    
    NSLog(@"%ld", (long)indexPath.row);
    
}
-(void)getUserDetails{
    
    [COMMON LoadIcon:self.view];
    [objWebservice getUserDetails:UserDetails_API
                        sessionid:strsessionID
                  profile_user_id:profileUserID
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"responseObject%@",responseObject);
                              
//                              NSMutableDictionary *detailsDict = [[NSMutableDictionary alloc]init];
//                              
//                              detailsDict = [responseObject valueForKey:@"getuserdetails"];
//                              
//                              if([[detailsDict valueForKey:@"status"]isEqualToString:@"success"]){
//                                  
//                                   NSLog(@"profileUse%@",[detailsDict objectForKey:@"userDetails"]);
//                              }
                              
                              if( [responseObject objectForKey:@"getuserdetails"]!=NULL){
                                  NSLog(@"profileUse%@",[[responseObject objectForKey:@"getuserdetails"]objectForKey:@"userDetails"]);
                                  
                                  [self redirectToDetailViewWithDictionary:[[responseObject objectForKey:@"getuserdetails"]objectForKey:@"userDetails"]];
                                  [COMMON removeLoading];
                              }
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              NSLog(@"error%@",error);
                          }];
}
- (void) redirectToDetailViewWithDictionary:(NSMutableDictionary *) detailsDictionary {
    
    DSDetailViewController* detailViewController = [[DSDetailViewController alloc] init];
    detailViewController.userDetailsDict = detailsDictionary;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(IBAction)filterAction:(id)sender
{
    if(isFilteraction==NO)
    {
        self.collectionviewxpostion.constant =-240;
        self.filterviewxposition.constant    = 65;
        self.sepratorXposition.constant      =self.collectionviewxpostion.constant-20;
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.buttonsView.frame=CGRectMake(self.collectionviewxpostion.constant-20,self.sepratorlbl.frame.origin.y+self.sepratorlbl.frame.size.height,self.view.frame.size.width,50);
        isFilteraction=YES;
    }
    else if (isFilteraction==YES)
    {
        self.collectionviewxpostion.constant =10;
        self.filterviewxposition.constant    =self.locationCollectionView.frame.size.width+10;
        self.sepratorXposition.constant      =self.collectionviewxpostion.constant-10;
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.buttonsView.frame=CGRectMake(self.collectionviewxpostion.constant-10,self.sepratorlbl.frame.origin.y+self.sepratorlbl.frame.size.height,self.view.frame.size.width,50);
        isFilteraction=NO;
        
    }
    
}

-(IBAction)StatusButtonAction:(id)sender
{
    if([sender tag] == 301)
    {
        self.onlineBtn.backgroundColor =[UIColor redColor];
        self.offlineBtn.backgroundColor =[UIColor whiteColor];
        self.statusBothBtn.backgroundColor=[UIColor whiteColor];
    }
    else if ([sender tag] == 302)
    {
        self.onlineBtn.backgroundColor =[UIColor whiteColor];
        self.offlineBtn.backgroundColor =[UIColor redColor];
        self.statusBothBtn.backgroundColor=[UIColor whiteColor];
    }
    else if ([sender tag] == 303)
    {
        self.onlineBtn.backgroundColor =[UIColor whiteColor];
        self.offlineBtn.backgroundColor =[UIColor whiteColor];
        self.statusBothBtn.backgroundColor=[UIColor redColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
