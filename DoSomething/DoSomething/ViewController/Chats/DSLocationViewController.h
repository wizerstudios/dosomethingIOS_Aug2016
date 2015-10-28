//
//  DSLocationViewController.h
//  DoSomething
//
//  Created by Ocs-web on 15/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLocationViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *locationCollectionView;
@property(strong,nonatomic)NSArray *profileImages;
@property(strong,nonatomic)NSArray *profileNames;
@property(nonatomic,retain)NSArray *kiloMeterlabel;
@end
