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


@interface DSLocationViewController ()
{}
@end

@implementation DSLocationViewController
@synthesize delegate;
@synthesize locationCollectionView;
@synthesize profileImages,profileNames,kiloMeterlabel;
- (void)viewDidLoad {
    
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
    
    UINib *cellNib = [UINib nibWithNibName:@"LocationCollectionViewCell" bundle:nil];
    [self.locationCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"LocationCell"];
    
    locationCollectionView.delegate=self;
    locationCollectionView.dataSource=self;
    
    profileNames=[[NSArray alloc]initWithObjects:@"Michelle Chong",@"Zoe Tay ",@"Felicia Chin",@"Yuna",@"TAylor Schilling",@"Gal Gadot", nil];
    profileImages=[[NSArray alloc]initWithObjects:@"chong.png",@"zoe_tay.png",@"felicin.png",@"yuna.png",@"taylor.png",@"Galglot.png", nil];
     kiloMeterlabel=[[NSArray alloc]initWithObjects:@"20km",@"1km",@"200km",@"2km",@"10km",@"1.6km", nil];
  
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.headerReferenceSize = CGSizeMake(locationCollectionView.bounds.size.width, 55);
    [locationCollectionView setCollectionViewLayout:flowLayout1];
    
    if(IS_IPHONE5)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:locationCollectionView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:-20.0]];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [profileNames count];
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
    
    locationCellView.imageProfile.image =[UIImage imageNamed:MyPatternString ];
    locationCellView.nameProfile.text =[profileNames objectAtIndex:indexPath.row];
    locationCellView.kiloMeter.text=[kiloMeterlabel objectAtIndex:indexPath.row];
    
    locationCollectionView.backgroundColor = [UIColor clearColor];
    return locationCellView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize returnSize = CGSizeZero;
    if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        returnSize = CGSizeMake((self.view.frame.size.width / 3.800f), 160);
    if (IS_IPHONE4 ||IS_IPHONE5 )
        returnSize = CGSizeMake((self.view.frame.size.width / 3.300f), 134);
    
    return returnSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 55.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
//   LocationCollectionViewCell*SelectCell = (LocationCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    
//    NSString *MyPatternString = [profileImages objectAtIndex:indexPath.row];
//    
//    SelectCell.imageProfile.image =[UIImage imageNamed:MyPatternString ];
//    SelectCell.sendRequest.text=@"Request Send";
//    SelectCell.sendRequest.textColor=[UIColor darkGrayColor];
//    SelectCell.hobbiesImage.image=[UIImage imageNamed:@"request_send1.png"];
//    SelectCell.activeNow.text=@"NOW";
//    SelectCell.activeNow.backgroundColor=[UIColor whiteColor];
    
//    SelectCell.hobbiesnames.textColor=[UIColor colorWithRed:(float)230.0/255 green:(float)63.0/255 blue:(float)82.0/255 alpha:1.0f];
//
   
}


@end
