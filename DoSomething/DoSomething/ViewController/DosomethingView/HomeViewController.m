//
//  HomeViewController.m
//  DoSomething
//
//  Created by ocsdev4 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//


#import "HomeViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "HomeCustomCell.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "DSAppCommon.h"
#import "UIImageView+AFNetworking.h"
#import "OpenUDID.h"
#import "CustomAlterview.h"


#define ITEMS_PAGE_SIZE 4
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

#define getLast  @"getlast"
#define Update   @"update"
#define Cancel   @"cancel"

#define Green_Color [UIColor colorWithRed:50.0f/255.0f green:180.0f/255.0f blue:41.0f/255.0f alpha:1.0f]
#define Red_Color   [UIColor colorWithRed:227.0f/255.0f green:64.0f/255.0f blue:81.0f/255.0f alpha:1.0f]
#define Gray_Color  [UIColor colorWithRed:169.0f/255.0f green:169.0f/255.0f blue:169.0f/255.0f alpha:1.0f]


@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    AppDelegate             *appDelegate;
    DSWebservice            * objWebService;
    BOOL                    isSelectMenu;
    NSArray                 *selectedArray;
    int                     selectedCellCount;
    NSMutableArray          *selectedItemsArray;
    NSMutableArray          * selectItemImageActiveArray;
    AVAudioPlayer           *audioPlayer;
    CustomAlterview         * objCustomAlterview;
    NSString                *strselectDosomething;
    
    NSMutableDictionary     *activityMainDict;
    NSMutableArray          *activityImageArray;
    BOOL isInitialLoadingAPI;
    
    float commonWidth, commonHeight;
    float yPos;
    float imageSize;
    float space;
    
    UIImageView *hobbiesImage;
    
    UILabel *titleLabel;
    NSString                * currentLatitude, * currentLongitude;
   
}
@end

@implementation HomeViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    objWebService = [[DSWebservice alloc]init];
    activityMainDict = [[NSMutableDictionary alloc]init];
    activityImageArray = [[NSMutableArray alloc]init];
    
    [activatedView setHidden:YES];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"MenuListArray"]==nil){
        [COMMON LoadIcon:self.view];
        [self loadhomeviewListWebservice];
    }
    else
    {
        menuArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"MenuListArray"] mutableCopy];
        isInitialLoadingAPI = YES;
        [self loadActivityAPI:getLast availableStr:@"" doSomethingId:@""];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getUserCurrenLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadInvalidSessionAlert:)
                                                 name:@"InvalidSession"
                                               object:nil];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=NO;
    appDelegate.SepratorLbl.hidden=NO;
    [self loadnavigationview];
    [self setupCollectionView];
    [self audioplayMethod];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.buttonsView.hidden=NO;
    
    NSString *countStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:UnreadMsgCount]];
    NSLog(@"countStr = %@",countStr);
    if(![countStr isEqualToString:@"0"] && ![countStr isEqualToString:@"(null)"]){
        [appDelegate.badgeCountLabel setHidden:NO];
        [appDelegate.badgeCountLabel setText:countStr];
    }
    else
        [appDelegate.badgeCountLabel setHidden:YES];
}



#pragma mark - loadhomeviewListWebservice
-(void)loadhomeviewListWebservice
{
    if([COMMON isInternetReachable]){
        
        
        [objWebService HomeviewList:DoSomething_API
                            success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if(responseObject!=nil)
             {
                 NSLog(@"response:%@",responseObject);
                 NSMutableDictionary *homeviewlist = [[NSMutableDictionary alloc]init];
                 menuArray=[NSMutableArray alloc];
                 homeviewlist = [responseObject valueForKey:@"dosomethinglist"];
                 menuArray =[homeviewlist valueForKey:@"list"];
                 [[NSUserDefaults standardUserDefaults] setObject:menuArray forKey:@"MenuListArray"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [COMMON removeLoading];
                 [self.homeCollectionView reloadData];
                 isInitialLoadingAPI = YES;
                 [self loadActivityAPI:getLast availableStr:@"" doSomethingId:@""];
             }
         }
                            failure:^(AFHTTPRequestOperation *operation, id error)
         {
         }];
        
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

}
#pragma mark - loadnavigationview
-(void)loadnavigationview
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
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
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    selectedArray = [[NSMutableArray alloc]init];
    selectedItemsArray = [[NSMutableArray alloc]init];
    [self CustomAlterviewload];
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

-(void)showAltermessage:(NSString*)msg
{
    objCustomAlterview.view.hidden =NO;
    objCustomAlterview.alertBgView.hidden = NO;
    objCustomAlterview.alertMainBgView.hidden = NO;
    objCustomAlterview.btnYes.hidden = YES;
    objCustomAlterview.btnNo.hidden = YES;
    objCustomAlterview.alertCancelButton.hidden=NO;
    objCustomAlterview.alertMsgLabel.numberOfLines=5;
    objCustomAlterview.alertMsgLabel.text = msg;
}



#pragma mark - audioplayMethod
-(void)audioplayMethod
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"button-16"
                                                    ofType:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                        error:NULL];
    [audioPlayer prepareToPlay];
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

#pragma mark - setupCollectionView
-(void)setupCollectionView {
    [self.homeCollectionView registerClass:[HomeCustomCell class]
                forCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER];
    [self.homeCollectionView registerClass:[UICollectionViewCell class]
                forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.homeCollectionView setCollectionViewLayout:flowLayout];
}
#pragma mark Collectionview Delegate Method

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [menuArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ItemCell";
    HomeCustomCell *cell = (HomeCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setNeedsDisplay];
    cell.MenuImg = nil;
    cell.MenuTittle = nil;
    if (cell != nil)
    {
        cell.MenuImg = (UIImageView *)[cell viewWithTag:101];
        cell.MenuTittle = (UILabel *)[cell viewWithTag:201];
    }
    NSDictionary *data = [menuArray objectAtIndex:indexPath.row];
    
    if (isSelectMenu)
    {
        for (NSIndexPath *collectionIndexPath in [_homeCollectionView indexPathsForSelectedItems])
        {
            if ([indexPath isEqual:collectionIndexPath])
            {
                cell.MenuTittle.text = [[data objectForKey:@"name"]uppercaseString];
                cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f)
                                                            green:(65/255.0f)
                                                             blue:(81/255.0f)
                                                            alpha:1.0f];
                NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"ActiveImage"]];
                objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];
                break;
            }
        }
    }
    else{
        cell.MenuTittle.text = [[data objectForKey:@"name"]uppercaseString];
        cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f)
                                                    green:(164/255.0f)
                                                     blue:(164/255.0f)
                                                    alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"InactiveImage"]];
        objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];
    }
    _homeCollectionView.allowsMultipleSelection = YES;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if(IS_IPHONE6_Plus)
        return 27.0;
    else if(IS_IPHONE6)
        return 8.0;
    else if(IS_IPHONE5)
        return 7.0;
    else
        return 5.0;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    
    HomeCustomCell *cell = (HomeCustomCell *)[self.homeCollectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER
                                                                                                forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeZero;
    
    if (IS_IPHONE6)
        returnSize = CGSizeMake((self.view.frame.size.width/4.0), 110);
    if(IS_IPHONE6_Plus)
        returnSize = CGSizeMake((self.view.frame.size.width/4.5), 110);
    if (IS_IPHONE4 ||IS_IPHONE5 )
        returnSize = CGSizeMake((self.view.frame.size.width/3.6), 88);
    
    return returnSize;
}
#pragma mark - didSelectItemAtIndexPath
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    isSelectMenu=YES;
   
    HomeCustomCell *cell = (HomeCustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *data = [menuArray objectAtIndex:indexPath.row];
    
    if([selectedItemsArray count] <= 2)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"button-16"
                                                        ofType:@"mp3"];
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                            error:NULL];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        [selectedItemsArray addObject:[data valueForKey:@"Id"]];
        cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f)
                                                    green:(65/255.0f)
                                                     blue:(81/255.0f)
                                                    alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"ActiveImage"]];
        objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];
    }
    else
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        objCustomAlterview.view.hidden =NO;
        objCustomAlterview.alertBgView.hidden = NO;
        objCustomAlterview.alertMainBgView.hidden = NO;
        objCustomAlterview.alertCancelButton.hidden = NO;
        objCustomAlterview.btnYes.hidden = YES;
        objCustomAlterview.btnNo.hidden = YES;
        objCustomAlterview.alertMsgLabel.text = @"ONLY 3 ACTIVITIES\nCAN BE SELECTED";
        objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
        objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        objCustomAlterview.alertMsgLabel.numberOfLines = 2;
        [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f)
                                                                       green:(255/255.0f)
                                                                        blue:(255/255.0f)
                                                                       alpha:1.0f]];
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
}
#pragma mark - didDeselectItemAtIndexPath
-(void)collectionView: (UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCustomCell *cell = (HomeCustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *data = [menuArray objectAtIndex:indexPath.row];
    NSArray *selectArray = [[NSArray alloc]init];
    selectArray = [selectedItemsArray copy];
    for(NSString *strDeselect in selectArray)
    {
        if([[data valueForKey:@"Id"] isEqualToString:strDeselect])

       {
           NSString *path = [[NSBundle mainBundle]pathForResource:@"button-16"
                                                           ofType:@"mp3"];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                                error:NULL];
            [audioPlayer prepareToPlay];
            [audioPlayer play];
           [selectedItemsArray removeObject:strDeselect];
           //isdeSelect=YES;
            cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f)
                                                        green:(164/255.0f)
                                                         blue:(164/255.0f)
                                                        alpha:1.0f];
           NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"InactiveImage"]];
           objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
           [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];
            //cell.MenuImg.image = [UIImage imageNamed:objstr];
       }
    }
}
- (void)fetchMoreItems {
    
    NSLog(@"FETCHING MORE ITEMS ******************");
    NSMutableArray *newData = [NSMutableArray array];
    NSInteger pageSize;
    pageSize= ITEMS_PAGE_SIZE;
    double delayInSeconds =1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (int i = 0; i < newData.count; i++) {
            [menuArray addObject:newData[i]];
        }
        
        [self.homeCollectionView reloadData];
        
    });
}
#pragma mark - pressDosomethingAction
- (IBAction)pressDosomething:(id)sender {
    if([sender tag] == 1000){
       // [bottombutton setUserInteractionEnabled:NO];
       [self loadActivityAPI:Cancel availableStr:@"" doSomethingId:@""];
    }else{
        if([selectedItemsArray count] == 3){
            objCustomAlterview.view .hidden  = NO;
            objCustomAlterview.alertBgView.hidden = NO;
            objCustomAlterview.alertMainBgView.hidden = NO;
            objCustomAlterview.btnYes.hidden = NO;
            objCustomAlterview.btnNo.hidden = NO;
            objCustomAlterview.alertCancelButton.hidden = NO;
            objCustomAlterview.alertMsgLabel.text = @"AVAILABLE NOW?";
            objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
            objCustomAlterview. alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
            objCustomAlterview.alertMsgLabel.textColor = [UIColor whiteColor];
           // isInitialLoadingAPI = NO;
            //[self loadActivityAPI:getLast availableStr:@"" doSomethingId:@""];
        }
        else{
            [self showAltermessage:@"3 ACTIVITIES\nSHOULD BE SELECTED "];
        }
    }
    
}
- (IBAction)alertPressCancel:(id)sender {
    objCustomAlterview. alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    objCustomAlterview.view .hidden  = YES;

}
- (IBAction)alertPressYes:(id)sender {
    objCustomAlterview.alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    [objCustomAlterview.view setHidden:YES];
    strselectDosomething = [selectedItemsArray componentsJoinedByString:@","];
    [self loadActivityAPI:Update availableStr:@"Yes" doSomethingId:strselectDosomething];
    //[self loadupdateDosomethingWebService:strselectDosomething:@"Yes"];

}
- (IBAction)alertPressNo:(id)sender {
    objCustomAlterview.alertBgView.hidden = YES;
    objCustomAlterview.alertMainBgView.hidden = YES;
    [objCustomAlterview.view setHidden:YES];
    strselectDosomething = [selectedItemsArray componentsJoinedByString:@","];
    [self loadActivityAPI:Update availableStr:@"No" doSomethingId:strselectDosomething];
    //[self loadupdateDosomethingWebService:strselectDosomething :@"No"];
}
#pragma mark - loadupdateDosomethingWebService

-(void)loadLocationUpdateAPI{
    
    if([COMMON isInternetReachable]){
        
        
        [objWebService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                              success:^(AFHTTPRequestOperation *operation, id responseObject){
                                  NSLog(@"responseObject = %@",responseObject);
                                  if([[responseObject valueForKey:@"status"]isEqualToString:@"success"]){
                                      [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:CurrentLatitude];
                                      [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:CurrentLongitude];
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, id error) {
                                  
                                  [self showAltermessage:[NSString stringWithFormat:@"%@",error]];
                              }];
        

        
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

    
}

-(void)loadActivityAPI:(NSString *)_activityNameStr availableStr:(NSString *)_availableStr doSomethingId:(NSString *)_dosomethingId{
    
    if([COMMON isInternetReachable]){
        
        [objWebService getActivity:Activity activityName:_activityNameStr sessionId:[COMMON getSessionID] availableNow:_availableStr doSomethingId:_dosomethingId
                           success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"response object = %@",responseObject);
             
             activityMainDict = [responseObject valueForKey:@"activity"];
             NSString *msgString = [activityMainDict valueForKey:@"Message"];
             
             if([msgString isEqualToString:@"Activity Canelled successfully"]){
                 // [self showAltermessage:msgString];
                 [activatedView setHidden:YES];
                 [self.homeCollectionView setAlpha:1];
                 [self.homeCollectionView setUserInteractionEnabled:YES];
                 [activityImageArray removeAllObjects];
                 isSelectMenu = NO;
                 [selectedItemsArray removeAllObjects];
                 [self.homeCollectionView reloadData];
                 [bottombutton setTag:1001];
                 [bottombutton setTitle:@"Let's Do Something!" forState:UIControlStateNormal];
             }
             else{
                 id activityList = [activityMainDict valueForKey:@"activityList"];
                 
                 NSLog(@"activityList = %@",activityList);
                 
                 if([activityList isKindOfClass:[NSArray class]]){
                     NSLog(@"activity list");
                     activityImageArray = [activityList mutableCopy];
                     NSString *availStr = [activityMainDict valueForKey:@"Available"];
                     [self displayActivityView:availStr];
                     
                 }
                 else{
                     //                 if(isInitialLoadingAPI == NO){
                     //                     objCustomAlterview.view .hidden  = NO;
                     //                     objCustomAlterview.alertBgView.hidden = NO;
                     //                     objCustomAlterview.alertMainBgView.hidden = NO;
                     //                     objCustomAlterview.btnYes.hidden = NO;
                     //                     objCustomAlterview.btnNo.hidden = NO;
                     //                     objCustomAlterview.alertCancelButton.hidden = NO;
                     //                     objCustomAlterview.alertMsgLabel.text = @"AVAILABLE NOW?";
                     //                     objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
                     //                     objCustomAlterview. alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
                     //                     objCustomAlterview.alertMsgLabel.textColor = [UIColor whiteColor];
                     //
                     //                 }
                     
                     [bottombutton setTitle:@"Let's Do Something!" forState:UIControlStateNormal];
                     
                 }
             }
             
         }
                           failure:^(AFHTTPRequestOperation *operation, id error) {
                               
                               
                               // [self showAltermessage:[NSString stringWithFormat:@"%@",error]];
                           }];

    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

    
   }

-(void)displayActivityView:(NSString *)_availStr{
    
    
    for( UIImageView *subView in [activatedView subviews])
    {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
        
    }
    for(UILabel *label in [activatedView subviews]){
        if ([label isKindOfClass:[UILabel class]]&& label.tag !=100) {
            [label removeFromSuperview];
        }
    }
    
    [activatedView setHidden:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.homeCollectionView setAlpha:0.085];
    [self.homeCollectionView setUserInteractionEnabled:NO];
    [bottombutton setTag:1000];
    [bottombutton setTitle:@"Cancel All Activities ?" forState:UIControlStateNormal];
    
    NSString *timeStr = [activityMainDict valueForKey:@"LastActivity"];
    timeStr = [NSString stringWithFormat:@"    Last Selected:\n%@",timeStr];
    
    
    [timeLabel setText:timeStr];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    timeLabel.numberOfLines = 3;
    nowButton.hidden=YES;
    anyTimeButton.hidden =YES;
   // if([_availStr isEqualToString:@"No"]){
       // [nowButton setBackgroundColor:Green_Color];
        //[anyTimeButton setBackgroundColor:Gray_Color];
       // [anyTimeButton setUserInteractionEnabled:NO];
   // }
    //else{
        //[nowButton setBackgroundColor:Gray_Color];
       // [anyTimeButton setBackgroundColor:Red_Color];
       // [nowButton setUserInteractionEnabled:NO];
  //  }
    
    [self loadActivityImageView];
    
}

-(IBAction)nowAction:(id)sender{
   // [nowButton setBackgroundColor:Gray_Color];
   // [anyTimeButton setBackgroundColor:Red_Color];
   // [nowButton setUserInteractionEnabled:NO];
   // [anyTimeButton setUserInteractionEnabled:YES];
   
    strselectDosomething = [selectedItemsArray componentsJoinedByString:@","];
    [self loadActivityAPI:Update availableStr:@"Yes" doSomethingId:strselectDosomething];
    
}
-(IBAction)anyTimeAction:(id)sender{
    //[nowButton setBackgroundColor:Green_Color];
    //[anyTimeButton setBackgroundColor:Gray_Color];
    //[anyTimeButton setUserInteractionEnabled:NO];
    //[nowButton setUserInteractionEnabled:YES];
   // strselectDosomething = [selectedItemsArray componentsJoinedByString:@","];
    [self loadActivityAPI:Update availableStr:@"No" doSomethingId:strselectDosomething];
}


-(void)loadActivityImageView{
    
    
        imageSize =50;
        commonWidth=19.5;
    

        space = imageSize / 2;
        commonHeight = imageSize+15;
        int imageXPos = 0;
        int textXPos = 0;
        if(IS_IPHONE6_Plus){
             yPos = 300;
            imageXPos = 50;
            textXPos = 40;
            commonWidth=75;
        }
        else if (IS_IPHONE6){
            yPos = 230;
            imageXPos = 35;
            textXPos = 25;
            commonWidth=75;
        }
        else{
            yPos = 152;
            imageXPos = 35;
            textXPos = 25;
            commonWidth=55;
        }
       
       for (int i =0; i <[activityImageArray count]; i++) {
            hobbiesImage = [[UIImageView alloc]init];
            titleLabel = [[UILabel alloc]init];
            hobbiesImage.frame = CGRectMake((i*(commonWidth + imageSize))+ imageXPos, yPos, imageSize, imageSize);
            NSString *activityStr =[[[activityImageArray objectAtIndex:i]valueForKey:@"name"]uppercaseString];
        
            NSString *image =[[activityImageArray objectAtIndex:i]valueForKey:@"ActiveImage"];
            image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [hobbiesImage setImageWithURL:[NSURL URLWithString:image]];
               
            titleLabel.frame = CGRectMake((i*(commonWidth + imageSize))+textXPos, yPos + imageSize+5, imageSize + 20, 15);
            [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10]];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = Red_Color;
              
            titleLabel.text = activityStr;
            
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [activatedView addSubview:hobbiesImage];
            [activatedView addSubview:titleLabel];
             NSString *Id = [[activityImageArray objectAtIndex:i]valueForKey:@"Id"];
             [selectedItemsArray addObject:Id];
          
      }
   
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
    [appDelegate.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon.png"] forState:UIControlStateNormal];

}


@end
