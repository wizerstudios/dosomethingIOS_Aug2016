//
//  CustomNavigationView.m
//  Policy 99
//
//  Created by Ocs Developer 6 on 7/24/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.
//

#import "CustomNavigationView.h"
#import "DSConfig.h"

@interface CustomNavigationView ()

@end

@implementation CustomNavigationView
      

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];

    if (IS_IPHONE6 ||IS_IPHONE6_Plus){
    self.layoutConstraintLabelYPos.constant =45;
    self.layoutConstraintBackBtnYPos.constant =39;
    self.layoutConstraintSaveBtnYPos.constant = 42;
    self.layoutConstraintBackArrowYPos.constant=45;
    }
}



@end
