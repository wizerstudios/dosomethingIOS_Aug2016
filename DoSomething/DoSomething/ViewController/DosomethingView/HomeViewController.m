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

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    AppDelegate *appDelegate;
    DSWebservice            * objWebService;
    BOOL isSelectMenu;
    NSArray *selectedArray;
    int selectedCellCount;
    
    NSMutableArray *selectedItemsArray;
    NSMutableArray * selectItemImageActiveArray;
    
    AVAudioPlayer *audioPlayer;
    
    NSString                *loginUserSessionID;
    CustomAlterview * objCustomAlterview;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    objWebService = [[DSWebservice alloc]init];
    [COMMON LoadIcon:self.view];
    
    [self loadhomeviewListWebservice];
     //deviceUdid = [OpenUDID value];
    if(IS_IPHONE5)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_homeCollectionView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:75.0]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=NO;
    [self loadnavigationview];
   
     [self setupCollectionView];
    [self audioplayMethod];
    
    
}


-(void)loadhomeviewListWebservice
{
   
     [objWebService HomeviewList:DoSomething_API success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          if(responseObject!=nil)
          {
          NSLog(@"response:%@",responseObject);
          NSMutableDictionary *homeviewlist = [[NSMutableDictionary alloc]init];
          //NSMutableArray* homeListcommArray=[[NSMutableArray alloc]init];
          menuArray=[NSMutableArray alloc];
          homeviewlist = [responseObject valueForKey:@"dosomethinglist"];
          menuArray =[homeviewlist valueForKey:@"list"];
         
              
             [COMMON removeLoading];
             [self.homeCollectionView reloadData];
          }
         
        
     } failure:^(AFHTTPRequestOperation *operation, id error) {
        
     }];
}

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
    //    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    //    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    selectedArray = [[NSMutableArray alloc]init];
    selectedItemsArray = [[NSMutableArray alloc]init];
    
    
     [self CustomAlterviewload];
   // alertBgView.hidden = YES;
    //alertMainBgView.hidden = YES;

}

-(void)CustomAlterviewload
{
    
    objCustomAlterview = [[CustomAlterview alloc] initWithNibName:@"CustomAlterview" bundle:nil];
//    objCustomAlterview.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, CGRectGetWidth(self.view.frame),self.);
    [objCustomAlterview.alertBgView setHidden:YES];
    [objCustomAlterview.alertMainBgView setHidden:YES];
    [objCustomAlterview.view setHidden:YES];
    [objCustomAlterview.alertCancelButton addTarget:self action:@selector(alertPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.btnNo addTarget:self action:@selector(alertPressNo:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomAlterview.btnYes addTarget:self action:@selector(alertPressYes:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:objCustomAlterview.view];
}

-(void)audioplayMethod
{
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"button-16" ofType:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                   [NSURL fileURLWithPath:path] error:NULL];
    [audioPlayer prepareToPlay];
}
-(void)setupCollectionView {
    [self.homeCollectionView registerClass:[HomeCustomCell class] forCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER];
    [self.homeCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //[flowLayout setMinimumInteritemSpacing:10.0f];
   // [flowLayout setMinimumLineSpacing:10.0f];
    //[self.objCollectionView setPagingEnabled:YES];
    [self.homeCollectionView setCollectionViewLayout:flowLayout];
}


#pragma mark collectionview delegate method

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
                cell.MenuTittle.text = [data objectForKey:@"name"];
                cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f) green:(65/255.0f) blue:(81/255.0f) alpha:1.0f];
                NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"ActiveImage"]];
                objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];
                //cell.MenuImg.image = [UIImage imageNamed:objstr];
                break;
            }
        }
    }
    else{
        cell.MenuTittle.text = [data objectForKey:@"name"];
        cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"InactiveImage"]];
        objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];

        //cell.MenuImg.image = [UIImage imageNamed:objstr];
    }
    
    _homeCollectionView.allowsMultipleSelection = YES;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
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
    
    HomeCustomCell *cell = (HomeCustomCell *)[self.homeCollectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    isSelectMenu=YES;
   
    HomeCustomCell *cell = (HomeCustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *data = [menuArray objectAtIndex:indexPath.row];
    
    
    if([selectedItemsArray count] <= 2)
    {
        
        NSString *path = [[NSBundle mainBundle]
                          pathForResource:@"button-16" ofType:@"mp3"];
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                       [NSURL fileURLWithPath:path] error:NULL];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
        
        [selectedItemsArray addObject:[data valueForKey:@"Id"]];
        cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f) green:(65/255.0f) blue:(81/255.0f) alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:@"ActiveImage"]];
        objstr= [objstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.MenuImg setImageWithURL:[NSURL URLWithString:objstr]];

        NSLog(@"selectImage:%@",objstr);
        //cell.MenuImg.image = [UIImage imageNamed:objstr];
        
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
        
        objCustomAlterview.alertMsgLabel.text = @"ONLY 3 ACTIVIES\nCAN BE SELECTED";
        objCustomAlterview.alertMsgLabel.textAlignment = NSTextAlignmentCenter;
        objCustomAlterview.alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        objCustomAlterview.alertMsgLabel.numberOfLines = 2;
        [objCustomAlterview.alertMsgLabel setTextColor:[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f]];
        
      [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
   

}

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

            NSString *path = [[NSBundle mainBundle]
                              pathForResource:@"button-16" ofType:@"mp3"];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                           [NSURL fileURLWithPath:path] error:NULL];
            [audioPlayer prepareToPlay];
            [audioPlayer play];


           [selectedItemsArray removeObject:strDeselect];
           //isdeSelect=YES;

            cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];

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




- (IBAction)pressDosomething:(id)sender {
    
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
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString * strsessionID =[dic valueForKey:@"SessionId"];
    loginUserSessionID=strsessionID;
}

- (IBAction)alertPressCancel:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        
    //    objCustomAlterview.alertBgView.alpha = 0;
        
    //    objCustomAlterview.alertMainBgView.alpha = 0;
              
    } completion:^(BOOL b){
        

       objCustomAlterview. alertBgView.hidden = YES;
        
        objCustomAlterview.alertMainBgView.hidden = YES;
        objCustomAlterview.view .hidden  = YES;
    }];
}

- (IBAction)alertPressYes:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        
   //     objCustomAlterview.alertBgView.alpha = 0;
        
  //      objCustomAlterview.alertMainBgView.alpha = 0;
           }
        completion:^(BOOL b){
        
        objCustomAlterview.alertBgView.hidden = YES;
        
        objCustomAlterview.alertMainBgView.hidden = YES;
            [objCustomAlterview.view setHidden:YES];
        [self loadupdateDosomethingWebService:selectedItemsArray :@"Yes"];
      
    }];
    
}

- (IBAction)alertPressNo:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        
    //    objCustomAlterview.alertBgView.alpha = 0;
        
   //     objCustomAlterview.alertMainBgView.alpha = 0;
        
    } completion:^(BOOL b){
        
        
        objCustomAlterview.alertBgView.hidden = YES;
        
        objCustomAlterview.alertMainBgView.hidden = YES;
        [objCustomAlterview.view setHidden:YES];
        [self loadupdateDosomethingWebService:selectedArray :@"No"];
     
    }];
   
    
}
-(void)loadupdateDosomethingWebService:(NSArray *)selectItemID :(NSString*)selectOption
{
    [objWebService updateDosomething:UpdateDoSomething_API sessionid:loginUserSessionID dosomething_id:selectItemID available_now:selectOption success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString * responseMsg=[[responseObject valueForKey:@"updatedosomething"]valueForKey:@"Message"];
        if(![responseMsg isEqualToString:@""])
        {
           NSLog(@"responseMsg:%@",responseMsg);
            if(IS_GREATER_IOS7)
            {
             [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:responseMsg preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
            }
            else
            {
                [DSAppCommon showSimpleAlertWithMessage:responseMsg];
            }
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
