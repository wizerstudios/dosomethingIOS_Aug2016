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
    BOOL isDownloadactiveImg;

}
@end

@implementation DSInterestAndHobbiesViewController
@synthesize interestAndHobbiesCollectionView, profileDetailsArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self loadNavigation];
    self.WalkAlterview.hidden =YES;
   
    NSString * Firstlogin=[[NSUserDefaults standardUserDefaults]valueForKey:FirstlogininterestHobbies];
    
    if([Firstlogin isEqualToString:@"YES"])
    {
        [self GerenalWalkAlterview];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:FirstlogininterestHobbies];
    }

   
    
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
    
    
//    if (IS_IPHONE5 ){
//        
//        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =68;
//        
//        self.layoutConstraintCollectionviewYPos.constant =25;
//        
//        self.layoutConstraintTapLabelYPos.constant =0;
//        
//    }
    
    if (IS_IPHONE6 ){
        
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
        
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =98;
        
        self.layoutConstraintCollectionviewYPos.constant =65;
        
        self.layoutConstraintTapLabelYPos.constant = 6;
        
    }
    
    else if(IS_IPHONE6_Plus)
        
    {
        
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =98;
        
        self.layoutConstraintCollectionviewYPos.constant =65;
        
        self.layoutConstraintTapLabelYPos.constant = 6;
        
    }
   else {
        
        self.layoutConstraintinterestAndHobbiesLabelYPos.constant =68;
        
        self.layoutConstraintCollectionviewYPos.constant =25;
        
        self.layoutConstraintTapLabelYPos.constant =0;
        
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
    
    if([COMMON isInternetReachable]){
        
        [COMMON LoadIcon:self.view];
        
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
             
             [[NSUserDefaults standardUserDefaults] setObject:hobbiesArry forKey:@"ListofinterestArray"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             interstAndHobbiesArray=[hobbiesArry mutableCopy];
             
             [COMMON removeLoading];
             
             [interestAndHobbiesCollectionView reloadData];
             
             [self localArray];
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, id error) {
             
             
             NSLog(@"intersesthobbieseror=%@",error);
             
             
         }];

        
        
    }
    else{
        
        [COMMON showErrorAlert:@"Check Your Internet connection"];
        
    }

    
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
    sectionArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ListofsectionNameArray"] mutableCopy];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ListofinterestArray"]==nil){
        
        [COMMON LoadIcon:self.view];
        isDownloadactiveImg=YES;
        [self loadHobbiesWebserviceMethod];
        
        
        
    }
    else{
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"]==nil)
        {
             isDownloadactiveImg=NO;
            interstAndHobbiesArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"ListofinterestArray"] mutableCopy];
            // interestArray=interstAndHobbiesArray;
        }
        
         //[interestAndHobbiesCollectionView reloadData];
    }

    //[self loadHobbiesWebserviceMethod];
        
    
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
        
//             else if(IS_IPHONE5)
//        {
//            int numberOfCellInRow = 6.5;
//            int padding = 1;
//            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
//            finalWidthWithPadding = collectionCellWidth - (padding);
//            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
//            
//        }
             else
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
//          else if(IS_IPHONE5)
//          {
//              int numberOfCellInRow = 6;
//              int padding = 2;
//              collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
//              finalWidthWithPadding = collectionCellWidth - (padding);
//              return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
//              
//          }
          else
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
//        else if(IS_IPHONE5)
//        {
//            int numberOfCellInRow = 6;
//            int padding = 1;
//            collectionCellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
//            finalWidthWithPadding = collectionCellWidth - (padding);
//            return CGSizeMake(finalWidthWithPadding , finalWidthWithPadding);
//            
//        }
        else
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
        if( isDownloadactiveImg==YES)
        {
            image = [dict valueForKey:@"image"];
            
            downloadImageFromUrl(image, cell.interestAndHobbiesImageView);
           // [cell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
        }

        image = [dict valueForKey:@"image_active"];
        
        [cell.nameLabel setTextColor:[UIColor colorWithRed:(224.0f/255) green:(62.0f/255) blue:(79.0f/255) alpha:1.0f]];
    }
    
    else{
        
        if( isDownloadactiveImg==YES)
        {
             image = [dict valueForKey:@"image_active"];
            downloadImageFromUrl(image, cell.interestAndHobbiesImageView);
            //[cell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
        }
        image = [dict valueForKey:@"image"];
        
        [cell.nameLabel setTextColor:[UIColor grayColor]];
    }
    
//    downloadImageFromUrl(image, cell.interestAndHobbiesImageView);
//    [cell.interestAndHobbiesImageView setImageWithURL:[NSURL URLWithString:image]];
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
     [CATransaction begin];
     [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionAnimationDuration];
    [interestAndHobbiesCollectionView reloadItemsAtIndexPaths:@[indexPath]];

     [CATransaction commit];
  
    
     
    //[interestAndHobbiesCollectionView reloadData];
    

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

-(IBAction)didClickGeneralWalkAlterviewBtn:(id)sender
{
    self.WalkAlterview.hidden=YES;
    self.window.hidden=YES;
}
-(void)GerenalWalkAlterview
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIImageView * blueCirecleImg;
    UILabel * Savelbl;
    UIView * altermsgView;
    
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
    {
          blueCirecleImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-10,25,45,45)];
        Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-5,30,35,35)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-50,self.view.frame.origin.y+70,160,60)];

    }
    else
    {
           blueCirecleImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-65,15,45,45)];
        Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60,20,35,35)];
        altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-70,self.view.frame.origin.y+60,160,60)];

    }
    blueCirecleImg.image=[UIImage imageNamed:@"BlueCirecleimg"];
    blueCirecleImg.userInteractionEnabled=YES;
    [self.window addSubview:blueCirecleImg];
    
   //Savelbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60,20,35,35)];
    Savelbl.text =@"Save";
    Savelbl.textColor=[UIColor whiteColor];
    Savelbl.textAlignment= NSTextAlignmentCenter;
    Savelbl.numberOfLines=2;
    [Savelbl setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [self.window addSubview:Savelbl];

    
    
//    altermsgView= [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-70,self.view.frame.origin.y+60,160,60)];
    
    
    UIImageView * blueTxtImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,160,60)];
    blueTxtImg.userInteractionEnabled=YES;
    blueTxtImg.image=[UIImage imageNamed:@"BlueBgText"];
    [altermsgView addSubview:blueTxtImg];
    UILabel * AlterMsg=[[UILabel alloc]initWithFrame:CGRectMake(0,0,160,60)];
    AlterMsg.text =@"Select your interest and \n ”Save” the selection";
    AlterMsg.textColor=[UIColor whiteColor];
    AlterMsg.textAlignment= NSTextAlignmentCenter;
    AlterMsg.numberOfLines=2;
    [AlterMsg setFont:[UIFont fontWithName:@"Patron-Regular" size:12]];
    [altermsgView addSubview:AlterMsg];
    
    
    [self.window addSubview:altermsgView];
    
    UIButton * ClosewindowBtn =[[UIButton alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [ClosewindowBtn addTarget:self action:@selector(didClickGeneralWalkAlterviewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
   
    [self.window addSubview:ClosewindowBtn];
    self.window.hidden=NO;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor =[UIColor colorWithRed:(53.0/255.0f) green:(53.0/255.0f) blue:(53.0/255.0f) alpha:0.5];
    

}


@end
