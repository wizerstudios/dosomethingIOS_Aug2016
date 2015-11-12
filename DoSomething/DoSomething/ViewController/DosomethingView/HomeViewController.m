//
//  HomeViewController.m
//  DoSomething
//
//  Created by ocsdev4 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#define ACTIVE_IMAGE @"ActiveImage"
#define NORMAL_IMAGE @"NormalImage"
#define CAPTION @"Caption"

#import "HomeViewController.h"

#import "CustomNavigationView.h"

#import "DSConfig.h"

#import "HomeCustomCell.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define ITEMS_PAGE_SIZE 4
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@interface HomeViewController ()
{
    AppDelegate *appDelegate;
    BOOL isSelectMenu;
    NSArray *selectedArray;
    int selectedCellCount;
    
    NSMutableArray *selectedItemsArray;
    
    AVAudioPlayer *audioPlayer;

}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
    menuArray = [[NSMutableArray alloc]initWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"running_Inactive.png",NORMAL_IMAGE,@"running_active.png",ACTIVE_IMAGE,@"RUNNING",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"beach_Inactive.png",NORMAL_IMAGE,@"beach_active.png",ACTIVE_IMAGE,@"BEACH",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"cycling_Inactive.png",NORMAL_IMAGE,@"cycling_active.png",ACTIVE_IMAGE,@"CYCLING",CAPTION,nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"movies_Inactive.png",NORMAL_IMAGE,@"movies_active.png",ACTIVE_IMAGE,@"MOVIES",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"alchol_Inactive.png",NORMAL_IMAGE,@"alchol_active.png",ACTIVE_IMAGE,@"ALCOHOL",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"meals_InActive.png",NORMAL_IMAGE,@"meals_active.png",ACTIVE_IMAGE,@"MEALS",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"coffee_Inactive.png",NORMAL_IMAGE,@"coffee_active.png",ACTIVE_IMAGE,@"COFFEE",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"shopping_Inactive.png",NORMAL_IMAGE,@"shopping_active.png",ACTIVE_IMAGE,@"SHOPPING",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"karaoke_Inactive.png",NORMAL_IMAGE,@"karaoke_active.png",ACTIVE_IMAGE,@"KARAOKE",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gym_Inactive.png",NORMAL_IMAGE,@"gym_active.png",ACTIVE_IMAGE,@"GYM",CAPTION, nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"tennis_Inactive.png",NORMAL_IMAGE,@"tennis_active.png",ACTIVE_IMAGE,@"TENNIS",CAPTION, nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"soocer_Inactive",NORMAL_IMAGE,@"soocer_active",ACTIVE_IMAGE,@"SOCCER",CAPTION, nil],
                 nil];
    
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
    [customNavigation.menuBtn setHidden:NO];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
//    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
//    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    selectedArray = [[NSMutableArray alloc]init];
    selectedItemsArray = [[NSMutableArray alloc]init];
    alertBgView.hidden = YES;
    alertMainBgView.hidden = YES;
    
    if(IS_IPHONE5)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_homeCollectionView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:75.0]];
    [self audioplayMethod];
}
-(void)viewWillAppear:(BOOL)animated
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=NO;
    [self setupCollectionView];
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

-(void)loadNavigation{
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    if (IS_IPHONE4 ||IS_IPHONE5)
    {
        customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    }
    else    {
        customNavigation.view.frame = CGRectMake(0,-20,420, 75);
    }
    [customNavigation.menuBtn setHidden:NO];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    //[customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
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
                cell.MenuTittle.text = [data objectForKey:CAPTION];
                cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f) green:(65/255.0f) blue:(81/255.0f) alpha:1.0f];
                NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:ACTIVE_IMAGE]];
                cell.MenuImg.image = [UIImage imageNamed:objstr];
                break;
            }
        }
    }
    else{
        cell.MenuTittle.text = [data objectForKey:CAPTION];
        cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:NORMAL_IMAGE]];
        cell.MenuImg.image = [UIImage imageNamed:objstr];
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
   // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    HomeCustomCell *cell = (HomeCustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *data = [menuArray objectAtIndex:indexPath.row];
    
    
    if([selectedItemsArray count] <= 2)
    {
        
        
        [audioPlayer play];
        
        
        [selectedItemsArray addObject:[data valueForKey:@"Caption"]];
        cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f) green:(65/255.0f) blue:(81/255.0f) alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:ACTIVE_IMAGE]];
        cell.MenuImg.image = [UIImage imageNamed:objstr];
        
    }
    else
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        alertBgView.hidden = NO;
        alertMainBgView.hidden = NO;
        alertCancelButton.hidden = NO;
        btnYes.hidden = YES;
        btnNo.hidden = YES;
        
        alertMsgLabel.text = @"ONLY 3 ACTIVIES\nCAN BE SELECTED";
        alertMsgLabel.textAlignment = NSTextAlignmentCenter;
        alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        alertMsgLabel.numberOfLines = 2;
        alertMsgLabel.textColor = [UIColor whiteColor];
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
        
        if([[data valueForKey:@"Caption"] isEqualToString:strDeselect])
            
        {
            
            [audioPlayer play];

            [selectedItemsArray removeObject:strDeselect];
            
            cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];
            
            NSString * objstr = [NSString stringWithFormat:@"%@",[data valueForKey:NORMAL_IMAGE]];
            
            cell.MenuImg.image = [UIImage imageNamed:objstr];
            
        }
        
    }
    
}



- (void)fetchMoreItems {
    NSLog(@"FETCHING MORE ITEMS ******************");
    
    NSMutableArray *newData = [NSMutableArray array];
    NSInteger pageSize = ITEMS_PAGE_SIZE;
    
    double delayInSeconds =1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (int i = 0; i < newData.count; i++) {
            [menuArray addObject:newData[i]];
        }
        
        [self.homeCollectionView reloadData];
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)pressDosomething:(id)sender {
    
    alertBgView.hidden = NO;
    alertMainBgView.hidden = NO;
    btnYes.hidden = NO;
    btnNo.hidden = NO;
    alertCancelButton.hidden = NO;
    
    alertMsgLabel.text = @"AVAILABLE NOW?";
    alertMsgLabel.textAlignment = NSTextAlignmentCenter;
    alertMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    alertMsgLabel.textColor = [UIColor whiteColor];
}

- (IBAction)alertPressCancel:(id)sender {
    alertBgView.hidden = YES;
    alertMainBgView.hidden = YES;
}

- (IBAction)alertPressYes:(id)sender {
    
    alertBgView.hidden = YES;
    alertMainBgView.hidden = YES;
}

- (IBAction)alertPressNo:(id)sender {
    
    alertBgView.hidden = YES;
    alertMainBgView.hidden = YES;
}
@end
