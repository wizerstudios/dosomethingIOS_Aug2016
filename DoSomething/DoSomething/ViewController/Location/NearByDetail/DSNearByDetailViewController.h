//
//  DSNearByDetailViewController.h
//  DoSomething
//
//  Created by OCS iOS Developer on 21/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSNearbyCustomCell.h"

@interface DSNearByDetailViewController : UIViewController 
{
    UIImageView            *pageImageView;
    NSString               *pull;
    NSString               *scrolldragging;
    UIImageView            *profilePic;
    UIView                 *pgDtView;
    UIImageView            *blkdot;
    NSMutableArray         *ImageArray;
    
    float xslider;
    NSInteger jslider;
    BOOL isTapping;
    NSInteger CurrentImage;
    IBOutlet UIPageControl *detailPageControl;
    
    IBOutlet DSNearbyCustomCell *cellAbout;
    IBOutlet DSNearbyCustomCell *cellDosomething;
    IBOutlet DSNearbyCustomCell *cellInterestHobbies;
    IBOutlet DSNearbyCustomCell *cellNearbyProfileImg;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *profileImageScroll;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *genderImageView;
//@property (strong, nonatomic) IBOutlet UIPageControl *profilePageControl;
@property (strong, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (weak, nonatomic) IBOutlet UIView *topViewCell;

@property (strong, nonatomic) NSMutableDictionary *userDetailsDict;


@property (strong, nonatomic) IBOutlet UITableView *nearbyTbl;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * aboutviewHeight;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *nearbyTblHeight;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *nearbyScrollHeight;


@end
