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

#define ITEMS_PAGE_SIZE 4
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@interface HomeViewController ()
{
    AppDelegate *appDelegate;
    BOOL isSelectMenu;
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
                 [NSDictionary dictionaryWithObjectsAndKeys:@"karaoke_Inactive.png",NORMAL_IMAGE,@"karaoke_active.png",ACTIVE_IMAGE,@"KERAOKE",CAPTION, nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gym_Inactive.png",NORMAL_IMAGE,@"gym_active.png",ACTIVE_IMAGE,@"GYM",CAPTION, nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"tennis_Inactive.png",NORMAL_IMAGE,@"tennis_active.png",ACTIVE_IMAGE,@"TENNIS",CAPTION, nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"movies_Inactive.png",NORMAL_IMAGE,@"movies_active.png",ACTIVE_IMAGE,@"SOCCER",CAPTION, nil],
                 nil];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@" "] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem.title = @"Log Out";
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCollectionView];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.buttonsView.hidden=NO;
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


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < menuArray.count) {
        
        if(indexPath.item == (menuArray.count - ITEMS_PAGE_SIZE + 1)){
            [self fetchMoreItems];
        }
        
        return [self itemCellForIndexPath:indexPath];
    } else {
        [self fetchMoreItems];
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    
    HomeCustomCell *cell = (HomeCustomCell *)[self.homeCollectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    NSDictionary *Dic = [menuArray objectAtIndex:indexPath.row];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.backgroundColor=[UIColor colorWithRed:(232/255.0f) green:(232/255.0f) blue:(232/255.0f) alpha:1.0f];
   
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"selected_menu"] == indexPath.row)
    {
        if(isSelectMenu==YES)
        {
        cell.MenuTittle.textColor = [UIColor colorWithRed:(199/255.0f) green:(65/255.0f) blue:(81/255.0f) alpha:1.0f];
        NSString * objstr = [NSString stringWithFormat:@"%@",[Dic valueForKey:ACTIVE_IMAGE]];
        cell.MenuImg.image = [UIImage imageNamed:objstr];
        }
        else{
            cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];
            
            NSString * objstr = [NSString stringWithFormat:@"%@",[Dic valueForKey:NORMAL_IMAGE]];
            cell.MenuImg.image = [UIImage imageNamed:objstr];

        }
       //[cell.icon_btn setImage:[UIImage imageNamed:[Dic valueForKey:ACTIVE_IMAGE]] forState:UIControlStateNormal];
    }
    else
    {
        cell.MenuTittle.textColor = [UIColor colorWithRed:(164/255.0f) green:(164/255.0f) blue:(164/255.0f) alpha:1.0f];
        
        NSString * objstr = [NSString stringWithFormat:@"%@",[Dic valueForKey:NORMAL_IMAGE]];
        cell.MenuImg.image = [UIImage imageNamed:objstr];
    }
        
    cell.MenuTittle.text = [Dic valueForKey:CAPTION];
    
   // [cell setBackgroundColor:[UIColor colorWithRed:(232/255.0f) green:(232/255.0f) blue:(232/255.0f) alpha:1.0f]];

    
    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    
    HomeCustomCell *cell = (HomeCustomCell *)[self.homeCollectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeZero;
    
    returnSize = CGSizeMake((self.view.frame.size.width/4.0), 110);
    
    return returnSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectImage=[menuArray objectAtIndex:indexPath.row];
    isSelectMenu=YES;
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"selected_menu"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //[self didCreateImagepopupview:selectImage];
    
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



@end
