//
//  CustomNavigationView.h
//  Policy 99
//
//  Created by Ocs Developer 6 on 7/24/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationView : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *buttonBack;

@property (strong, nonatomic) IBOutlet UIImageView *backButtonImg;

@property (strong,nonatomic)  IBOutlet UIButton  * menuBtn;

@property (strong,nonatomic)  IBOutlet UIButton  * saveBtn;

@property (strong,nonatomic)  IBOutlet UIButton  *FilterBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBackBtnYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBackArrowYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintLabelYPos;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintSaveBtnYPos;


@end
