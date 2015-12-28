//
//  DSInterestAndHobbiesViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSInterestAndHobbiesViewController.h"
#import "DSInterestAndHobbiesCollectionViewCell.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "DSAppCommon.h"
#import "OpenUDID.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"




@interface DSInterestAndHobbiesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray*sectionNameArray;
    
    NSMutableArray * hobbiesArry;
    
    NSMutableArray *interstAndHobbiesArray;
    
    NSArray *sectionArray;
    
    DSWebservice * objWebservice;
    
    NSString                * deviceUdid;
    
    BOOL   iscollectiviewreload;
    
    AppDelegate *appDelegate;
    
    NSMutableDictionary *profileDict;
    
    NSMutableArray *profileHobbyArray;
    

}
@end

@implementation DSInterestAndHobbiesViewController
@synthesize interestAndHobbiesCollectionView, profileDetailsArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadNavigation];
    
    objWebservice =[[DSWebservice alloc]init];
    
    deviceUdid = [OpenUDID value];
    
    profileHobbyArray = [[NSMutableArray alloc]init];
    
    [self.interestAndHobbiesCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.headerReferenceSize = CGSizeMake(self.interestAndHobbiesCollectionView.bounds.size.width,40);
    
    [self.interestAndHobbiesCollectionView setCollectionViewLayout:flowLayout];
    
    [self initializeArray];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(loadInvalidSessionAlert:)
     
                                                 name:@"InvalidSession"
     
                                               object:nil];
    
    profileDict=[[NSMutableDictionary alloc]init];
    
    profileDict =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray] != NULL)
        
        profileHobbyArray = [[[NSUserDefaults standardUserDefaults]valueForKey:HobbiesArray]mutableCopy];
    
    else{
        
        if(profileDict != NULL)
            
            profileHobbyArray = [[profileDict valueForKey:@"hobbieslist"]mutableCopy];
        
    }
    
    
}

-(void)loadNavigation{
    
    self.navigationController.navigationBarHidden=NO;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    
    customNavigation.view.frame = CGRectMake(0,-20, (self.view.frame.size.width), 65);
    
    if (IS_IPHONE5 ){
        
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =68;
        
        self.layoutConstraintCollectionviewYPos.constant =25;
        
        self.layoutConstraintTapLabelYPos.constant =0;
        
    }
    
    if (IS_IPHONE6 ){
        
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
        
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =98;
        
        self.layoutConstraintCollectionviewYPos.constant =65;
        
        self.layoutConstraintTapLabelYPos.constant = 6;
        
    }
    
    if(IS_IPHONE6_Plus)
        
    {
        
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =98;
        
        self.layoutConstraintCollectionviewYPos.constant =65;
        
        self.layoutConstraintTapLabelYPos.constant = 6;
        
    }
    
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    [customNavigation.menuBtn setHidden:YES];
    
    [customNavigation.buttonBack setHidden:NO];
    
    [customNavigation.saveBtn setHidden:NO];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.buttonsView.hidden=YES;
    
    appDelegate.SepratorLbl.hidden=YES;
    
}
-(void)loadHobbiesWebserviceMethod
{
    [objWebservice getHobbies:GetHobbies_API sessionid:deviceUdid success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         NSLog(@"response:%@",responseObject);
         
         hobbiesArry=[[NSMutableArray alloc]init];
         
         sectionNameArray=[[NSMutableArray alloc]init];
         
         NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
         
         NSDictionary *objselectionname=[[NSDictionary alloc]init];
         
         loginDict = [responseObject valueForKey:@"gethobbies"];
         
         objselectionname =[loginDict valueForKey:@"list"];
         
         sectionNameArray  = [objselectionname valueForKey:@"name"];
         
         [[NSUserDefaults standardUserDefaults] setObject:sectionNameArray forKey:@"ListofsectionNameArray"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         hobbiesArry=[objselectionname valueForKey:@"hobbieslist"];
         
         interstAndHobbiesArray=[hobbiesArry mutableCopy];
         
         [COMMON removeLoading];
         
         [interestAndHobbiesCollectionView reloadData];
         
         [self localArray];
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, id error) {
         
         
         NSLog(@"intersesthobbieseror=%@",error);
         
         
     }];
    
}
-(void)localArray
{
    sectionArray =[[NSArray alloc]init];
    sectionArray=[[[NSUserDefaults standardUserDefaults] valueForKey:@"ListofsectionNameArray"] mutableCopy];
    
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

-(void)initializeArray{
    
    UINib *cellNib = [UINib nibWithNibName:@"DSInterestAndHobbiesCollectionViewCell" bundle:nil];
    [self.interestAndHobbiesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell"];
    
    interestAndHobbiesCollectionView.delegate=self;
    interestAndHobbiesCollectionView.dataSource=self;
    
    [COMMON LoadIcon:self.view];
    
    [self loadHobbiesWebserviceMethod];
        
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [interstAndHobbiesArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [interstAndHobbiesArray[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width), 40)];
        }
        
        for (UIView* view in reusableview.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 26, (self.view.frame.size.width), 10)];
    
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =[UIColor colorWithRed:(float)231.0/255 green:(float)90.0/255 blue:(float)102.0/255 alpha:1.0f];
        [label setFont:[UIFont fontWithName:@"Patron-Bold" size:9]];

        
        NSString *cellData = [[sectionArray objectAtIndex:indexPath.section]uppercaseString];
        
        label.text=cellData;
        [reusableview addSubview:label];
        return reusableview;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    
    if( cellCount < 3 )
        
    {
        
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        
        CGFloat totalCellWidth = cellWidth*cellCount;
        
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        
        if( totalCellWidth<contentWidth )
            
        {
            
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            
            return UIEdgeInsetsMake(0, padding, 0, padding);
            
        }
        
    }
    
    if( cellCount > 5 )
        
    {
        
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        
        CGFloat totalCellWidth = cellWidth*cellCount;
        
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        
        if( totalCellWidth>contentWidth )
            
        {
            
            CGFloat padding = (totalCellWidth - contentWidth) / 8.0;
            
            return UIEdgeInsetsMake(0, padding, 0, padding);
            
        }
        
    }
    
    return UIEdgeInsetsZero;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionCellWidth;
    CGFloat finalWidthWithPadding;
    if ( indexPath.section ==1 ) {
        
        if(IS_IPHONE6_Plus)
        {
        int numberOfCellInRow = 6;
        int padding = 1;
        collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
        finalWidthWithPadding = collectionCellWidth - (padding);
        return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
        }
         else if(IS_IPHONE6)
        {
            int numberOfCellInRow = 5;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);

        }
        
             else if(IS_IPHONE5)
        {
            int numberOfCellInRow = 6.5;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
            
        }

    }
    
      if (indexPath.section == 0 || indexPath.section ==3 )
      {
          
          if(IS_IPHONE6_Plus)
          {
              int numberOfCellInRow = 6;
              int padding = 1;
              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
              finalWidthWithPadding = collectionCellWidth - (padding);
              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
          }
          else if(IS_IPHONE6)
          {
              int numberOfCellInRow = 6;
              int padding = 1;
              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
              finalWidthWithPadding = collectionCellWidth - (padding);
              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
              
          }
          else if(IS_IPHONE5)
          {
              int numberOfCellInRow = 6;
              int padding = 2;
              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
              finalWidthWithPadding = collectionCellWidth - (padding);
              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
              
          }

          
      }

    
    if (indexPath.section ==2) {
        
        if(IS_IPHONE6_Plus)
        {
            int numberOfCellInRow =8;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
        }
        else if(IS_IPHONE6)

        {
            int numberOfCellInRow = 7;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
        }
        else if(IS_IPHONE5)
        {
            int numberOfCellInRow = 6;
            int padding = 1;
            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
            finalWidthWithPadding = collectionCellWidth - (padding);
            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
            
        }
        

    }
    return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSInterestAndHobbiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell" forIndexPath:indexPath];
    
    [cell.nameLabel setText:[[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]uppercaseString]];
    
    NSString *image;
    
    NSDictionary *dict = [[interstAndHobbiesArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    if([profileHobbyArray containsObject:dict]){
        
        image = [dict valueForKey:@"image_active"];
        
        [cell.nameLabel setTextColor:[UIColor colorWithRed:(224.0f/255) green:(62.0f/255) blue:(79.0f/255) alpha:1.0f]];
    }
    
    else{
        
        image = [dict valueForKey:@"image"];
        
        [cell.nameLabel setTextColor:[UIColor grayColor]];
    }
    
    image = [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
    
    
    return cell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    dict = [[[interstAndHobbiesArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]mutableCopy];
    
    if([profileHobbyArray containsObject:dict])
        
        [profileHobbyArray removeObject:dict];
    
    else
        [profileHobbyArray addObject:dict];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:profileHobbyArray forKey:HobbiesArray];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [interestAndHobbiesCollectionView reloadData];
    

}


-(void)backAction
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(profileDict!=NULL){
        appDelegate.buttonsView.hidden=NO;
        appDelegate.SepratorLbl.hidden=NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAction
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(profileDict!=NULL){
        appDelegate.buttonsView.hidden=NO;
         appDelegate.SepratorLbl.hidden=NO;
    }
    DSProfileTableViewController *profile = [[DSProfileTableViewController alloc]init];
    profile.placeHolderArray = profileDetailsArray;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
