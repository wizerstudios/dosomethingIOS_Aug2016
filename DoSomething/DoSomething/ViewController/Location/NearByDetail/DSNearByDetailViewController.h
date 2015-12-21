//
//  DSNearByDetailViewController.h
//  DoSomething
//
//  Created by OCS iOS Developer on 21/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSNearByDetailViewController : UIViewController 
{
    UIImageView            *pageImageView;
    NSString               *pull;
    NSString               *scrolldragging;
    float xslider;
    NSInteger jslider;
    BOOL isTapping;
    NSInteger CurrentImage;
    IBOutlet UIPageControl *detailPageControl;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *profileImageScroll;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *genderImageView;
@property (strong, nonatomic) IBOutlet UIPageControl *profilePageControl;
@property (strong, nonatomic) IBOutlet UILabel *nameAgeLabel;

@property (strong, nonatomic) NSMutableDictionary *userDetailsDict;

@end
