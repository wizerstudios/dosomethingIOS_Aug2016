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
    NSString                *loginUserSessionID;
    CustomAlterview         * objCustomAlterview;
    NSString                *strselectDosomething;
    
    NSMutableDictionary     *activityMainDict;
    BOOL isInitialLoadingAPI;
   
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    objWebService = [[DSWebservice alloc]init];
    activityMainDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString * strsessionID =[dic valueForKey:@"SessionId"];
    loginUserSessionID=strsessionID;
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=NO;
     appDelegate.SepratorLbl.hidden=NO;
    [self loadnavigationview];
    [self setupCollectionView];
    [self audioplayMethod];
}


#pragma mark - loadhomeviewListWebservice
-(void)loadhomeviewListWebservice
{
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
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                        }];
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
        [bottombutton setUserInteractionEnabled:NO];
       // [self loadActivityAPI:Cancel availableStr:@"" doSomethingId:@""];
    }else{
        if([selectedItemsArray count] == 3){
            isInitialLoadingAPI = NO;
            [self loadActivityAPI:getLast availableStr:@"" doSomethingId:@""];
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
    strselectDosomething = [selectedArray componentsJoinedByString:@","];
    [self loadActivityAPI:Update availableStr:@"No" doSomethingId:strselectDosomething];
    //[self loadupdateDosomethingWebService:strselectDosomething :@"No"];
}
#pragma mark - loadupdateDosomethingWebService
-(void)loadupdateDosomethingWebService:(NSString *)selectItemID :(NSString*)selectOption
{
    [objWebService updateDosomething:UpdateDoSomething_API
                           sessionid:loginUserSessionID
                      dosomething_id:strselectDosomething
                       available_now:selectOption
                             success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString * responseMsg=[[responseObject valueForKey:@"updatedosomething"]valueForKey:@"Message"];
        
        if(![responseMsg isEqualToString:@""])
        {
           NSLog(@"responseMsg:%@",responseMsg);
          [self showAltermessage:responseMsg];
                
    
        }
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
        
        [self showAltermessage:[NSString stringWithFormat:@"%@",error]];
                             }];
}

-(void)loadActivityAPI:(NSString *)_activityNameStr availableStr:(NSString *)_availableStr doSomethingId:(NSString *)_dosomethingId{
    
    [objWebService getActivity:Activity activityName:_activityNameStr sessionId:loginUserSessionID availableNow:_availableStr doSomethingId:_dosomethingId
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"response object = %@",responseObject);
         activityMainDict = [responseObject valueForKey:@"activity"];
        
         id activityList = [activityMainDict valueForKey:@"activityList"];
         
         NSLog(@"activityList = %@",activityList);
         
         if([activityList isKindOfClass:[NSArray class]]){
             NSLog(@"activity list");
             NSString *availStr = [activityMainDict valueForKey:@"Available"];
             [self displayActivityView:availStr];
            
         }
         else{
             if(isInitialLoadingAPI == NO){
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

             }
             
             [bottombutton setTitle:@"Let's Do Something!" forState:UIControlStateNormal];
             
         }
         

     }
       failure:^(AFHTTPRequestOperation *operation, id error) {
           
           
           [self showAltermessage:[NSString stringWithFormat:@"%@",error]];
       }];
}

-(void)displayActivityView:(NSString *)_availStr{
    
    [activatedView setHidden:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.homeCollectionView setAlpha:0.1];
    [self.homeCollectionView setUserInteractionEnabled:NO];
    [bottombutton setTag:1000];
    [bottombutton setTitle:@"Cancel All Activities ?" forState:UIControlStateNormal];
    
    [timeLabel setText:@"Available Since\n\nfew mins Ago"];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    timeLabel.numberOfLines = 3;

    if([_availStr isEqualToString:@"No"]){
        [nowButton setBackgroundColor:Green_Color];
        [anyTimeButton setBackgroundColor:Gray_Color];
    }
    else{
        [nowButton setBackgroundColor:Gray_Color];
        [anyTimeButton setBackgroundColor:Red_Color];
    }
   
    
    
}

@end
