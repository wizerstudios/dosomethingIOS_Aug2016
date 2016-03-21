//
//  HelpViewController.h
//  DineIn
//
//  Created by OCS Developer 2 on 16/07/14.
//  Copyright (c) 2014 OCS Developer 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBKenBurnsView.h"
@protocol HelpViewDelegate <NSObject>
-(IBAction)cancelBtnAction:(id)sender;
@end
@interface DSHomeViewController : UIViewController <KenBurnsViewDelegate>
{
    NSMutableArray *bannerImageArr;
    IBOutlet UIButton *scrollpauseBtn;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewImage;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (strong, nonatomic) IBOutlet UIButton *createAnAccBtn;
@property (strong, nonatomic) IBOutlet UIPageControl *infoPageControl;
@property(nonatomic,retain)id<HelpViewDelegate> delegate;
@property (nonatomic,retain) NSLayoutConstraint *pagerConstraint;
//@property (nonatomic) CGFloat scrollPointsPerSecond;
@property (strong, nonatomic) IBOutlet JBKenBurnsView *kenView;
@property  IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (nonatomic,strong) IBOutlet UIView * walkAlterview;

@property (nonatomic,strong) IBOutlet UIButton * walkAlterviewBtn;

@end
