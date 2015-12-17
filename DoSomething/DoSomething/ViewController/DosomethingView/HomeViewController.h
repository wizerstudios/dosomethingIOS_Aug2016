//
//  HomeViewController.h
//  DoSomething
//
//  Created by ocsdev4 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    NSMutableArray * menuArray;
    IBOutlet UIView *activatedView;
    IBOutlet UIButton *bottombutton,*nowButton,*anyTimeButton;
    IBOutlet UILabel *timeLabel;
}
@property(nonatomic,strong) IBOutlet UICollectionView * homeCollectionView;
- (IBAction)pressDosomething:(id)sender;


@end
