//
//  DSInterestAndHobbiesViewController.h
//  DoSomething
//
//  Created by OCSDEV2 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSProfileTableViewController.h"

@interface DSInterestAndHobbiesViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *interestAndHobbiesCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintinterestAndHobbiesLabelYPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintCollectionviewYPos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTapLabelYPos;

@property (strong, nonatomic) UIWindow                          *window;

@property (nonatomic, retain) NSMutableArray *profileDetailsArray;

@property (nonatomic,strong) IBOutlet UIView *WalkAlterview;
@end
