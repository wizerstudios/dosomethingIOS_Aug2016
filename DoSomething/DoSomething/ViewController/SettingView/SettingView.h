//
//  SettingView.h
//  DoSomething
//
//  Created by Sha on 11/25/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController
{
    IBOutlet UIView *alertBgView;
    IBOutlet UILabel *alertMsgLabel;
    IBOutlet UIButton *alertCancelButton;
    IBOutlet UIButton *btnYes;
    IBOutlet UIButton *btnNo;
    IBOutlet UIView *alertMainBgView;
    IBOutlet UILabel * messLbl;
    IBOutlet UILabel *soundLbl;
    IBOutlet UILabel *vibrationLbl;
}

@property (strong,nonatomic) IBOutlet UIScrollView *settingScroll;

@property (nonatomic ,strong) IBOutlet UIView * notificationview;

@property (nonatomic ,strong) IBOutlet UIButton *messSwitchBtn;
@property (nonatomic,strong)  IBOutlet UIButton * SoundSwitchBtn ;
@property(nonatomic,strong) IBOutlet UIButton *vibrationSwitchBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewNewMsg;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSound;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVibration;
@end
