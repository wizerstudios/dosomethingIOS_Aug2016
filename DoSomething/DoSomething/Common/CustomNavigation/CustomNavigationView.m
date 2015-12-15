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
    self.menuBtn.hidden    = YES;
    self.buttonBack.hidden = YES;
    self.saveBtn .hidden   = YES;
    //self.backButtonImg.hidden = YES;
    self.FilterBtn.hidden    =YES;
    
    if (IS_IPHONE6 ||IS_IPHONE6_Plus){
    self.layoutConstraintLabelYPos.constant =39;
    self.layoutConstraintBackBtnYPos.constant =33;
    self.layoutConstraintSaveBtnYPos.constant = 39;
    self.layoutConstraintBackArrowYPos.constant=39;
    }
}



@end
