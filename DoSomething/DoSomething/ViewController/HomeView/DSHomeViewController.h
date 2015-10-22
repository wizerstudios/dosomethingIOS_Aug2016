//
//  HelpViewController.h
//  DineIn
//
//  Created by OCS Developer 2 on 16/07/14.
//  Copyright (c) 2014 OCS Developer 2. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HelpViewDelegate <NSObject>
-(IBAction)cancelBtnAction:(id)sender;
@end
@interface DSHomeViewController : UIViewController
{
    
    
    UIImageView                 *infoImage;
    UIView                      *pgDtView;
    UIImageView                 *imageViewActive;
    UIImageView                 *imageViewDot;
    NSUInteger jslider;
    
    float xslider;
    NSInteger                   IndexVal;

    NSMutableArray *bannerImageArr;
   IBOutlet UIButton *scrollpauseBtn;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewImage;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (strong, nonatomic) IBOutlet UIButton *createAnAccBtn;
@property(nonatomic,retain)NSTimer *timer1;
@property (strong, nonatomic) IBOutlet UIPageControl *infoPageControl;
@property(nonatomic,retain)id<HelpViewDelegate> delegate;
@property (nonatomic,retain) NSLayoutConstraint *pagerConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintsCreateAnAccBtnHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintsSignInBtnHeight;

@end
