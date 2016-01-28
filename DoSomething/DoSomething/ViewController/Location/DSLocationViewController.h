//
//  DSLocationViewController.h
//  DoSomething
//
//  Created by Ocs-web on 15/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NMRangeSlider.h"

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

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender;


@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider1;
@property (weak, nonatomic) IBOutlet UILabel *agelowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageupperLabel;
- (IBAction)ageSliderChanged:(NMRangeSlider*)sender;


@property(nonatomic,strong)IBOutlet UIView * matchActivityView;

@property (nonatomic,strong) IBOutlet UILabel * matchActivitylbl;
@property (nonatomic,strong) IBOutlet UIButton *matchactivityBtn;
@property (nonatomic,strong) IBOutlet UIImageView * currentUserImg;
@property (nonatomic,strong) IBOutlet UIImageView *matcheduserImg;
@end
