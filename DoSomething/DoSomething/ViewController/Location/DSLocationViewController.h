//
//  DSLocationViewController.h
//  DoSomething
//
//  Created by Ocs-web on 15/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface DSLocationViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UICollectionView *locationCollectionView;
//@property(nonatomic,strong) IBOutlet UILabel *sepratorlbl;
@property (nonatomic,strong) IBOutlet UIView  * filterview;
@property(strong,nonatomic)NSArray *profileImages;
@property(strong,nonatomic)NSArray *profileNames;
@property(nonatomic,retain)NSArray *kiloMeterlabel;
@property(nonatomic,retain)NSArray *userID;
@property (nonatomic,retain) NSMutableArray*dosomethingImageArry;

@property (nonatomic,strong) NSMutableArray * commonlocationArray;
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;

@end
