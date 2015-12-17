//
//  DSDetailViewController.h
//  DoSomething
//
//  Created by OCS iOS Developer on 15/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSDetailViewController : UIViewController <UIScrollViewDelegate>
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


@property (strong, nonatomic) IBOutlet UIView *detailPageMainView;
@property (strong, nonatomic) IBOutlet UIScrollView *detailPageMainScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *profileImageScroll;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UITextView *aboutTextBox;
@property (strong, nonatomic) NSMutableDictionary *userDetailsDict;
@property (strong, nonatomic) IBOutlet UIView *genderView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;

@property (strong, nonatomic) IBOutlet UILabel *thingsLabel;

@property (strong, nonatomic) IBOutlet UILabel *myinterestsLabel;
@property (strong, nonatomic) IBOutlet UIView *aboutView;

@property (strong, nonatomic) IBOutlet UIView *thingsView;
@property (strong, nonatomic) IBOutlet UIView *fullView;

@end
