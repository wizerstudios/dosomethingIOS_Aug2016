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
    IBOutlet UIView *alertBgView;
    IBOutlet UILabel *alertMsgLabel;
    IBOutlet UIButton *alertCancelButton;
    IBOutlet UIButton *btnYes;
    IBOutlet UIButton *btnNo;
    IBOutlet UIView *alertMainBgView;
}
@property(nonatomic,strong) IBOutlet UICollectionView * homeCollectionView;
- (IBAction)pressDosomething:(id)sender;
- (IBAction)alertPressCancel:(id)sender;
- (IBAction)alertPressYes:(id)sender;
- (IBAction)alertPressNo:(id)sender;

@end
