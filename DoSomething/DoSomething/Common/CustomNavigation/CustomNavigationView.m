//
//  CustomNavigationView.m
//  Policy 99
//
//  Created by Ocs Developer 6 on 7/24/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.
//

#import "CustomNavigationView.h"

@interface CustomNavigationView ()

@end

@implementation CustomNavigationView
      

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];
    
}


//#pragma mark - Navigation Methods
//- (void)setstatusBarHidden:(BOOL)_hide {
//    [self.statusBarView setHidden:_hide];
//}
//-(void)setnavbgViewHidden:(BOOL)_hide{
//    [self.navView setHidden:_hide];
//}
//
//
//-(void)setlogoutButtonHidden:(BOOL)_hide{
//    [self.logoutButton setHidden:_hide];
//}
//
//-(void)setbackButtonHidden:(BOOL)_hide{
//    [self.backButton setHidden:_hide];
//}
//
//-(void)setmenuButtonHidden:(BOOL)_hide{
//    [self.menuButton setHidden:_hide];
//}
//
//- (void)setlogoButtonHidden:(BOOL)_hide{
//     [self.logoButton setHidden:_hide];
//}


@end
