//
//  HelpViewController.m
//  DineIn
//
//  Created by OCS Developer 2 on 16/07/14.
//  Copyright (c) 2014 OCS Developer 2. All rights reserved.
//

#import "DSHomeViewController.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "DSLoginViewController.h"
#import "DAAutoScroll.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
//#import "PWParallaxScrollView.h"

#define enlargeRatio 1.1
#define imageBufer 3

@interface DSHomeViewController ()
{
    int frameHt;
    int frameWt;
    NSArray *bannerImage;
    NSArray * bannerText;
    NSArray * pageController;
     AppDelegate *appDelegate;
    
    NSMutableArray *BGimageArray;
    NSMutableArray *FGimageArray;
    UIImageView *foregroundView;
    UIView * mainview;
    UIImageView * objImag;
      NSInteger Currentindex;
    NSMutableArray * bannerTitleArray;
    
    NSInteger swipeCount;
    UIImageView *frontImageView;
    UIView *alphaView;
    NSArray *myImages;

}
//@property (nonatomic, strong) PWParallaxScrollView *parallaxscrollView;
@property (nonatomic, assign) BOOL isLandscape;

@end
@implementation DSHomeViewController
@synthesize delegate,walkAlterview,walkAlterviewBtn;
@synthesize kenView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.walkAlterview.hidden =YES;
    [self flashOn:walkAlterviewBtn];

    self.kenView.delegate = self;
    _scrollViewImage.userInteractionEnabled = YES;
    
    swipeCount = 0;
    
    //........towards right Gesture recogniser for swiping.....//
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
    
    //........towards left Gesture recogniser for swiping.....//
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];

    if(IS_IPHONE6_Plus)
        self.viewHeightConstraint.constant = 688;
    else if(IS_IPHONE6)
        self.viewHeightConstraint.constant = 620;
    else
        self.viewHeightConstraint.constant = 518;

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [COMMON TrackerWithName:@"Welcome Screen"];
    
    bannerImage= @[[UIImage imageNamed:@"splash_bg"],
                   [UIImage imageNamed:@"bg1"],
                   [UIImage imageNamed:@"bg2"],
                   [UIImage imageNamed:@"bg3"],
                   [UIImage imageNamed:@"bg4"]];
    bannerText  = @[[UIImage imageNamed:@"bgText5"],
                   [UIImage imageNamed:@"bgText1"],
                   [UIImage imageNamed:@"bgText2"],
                   [UIImage imageNamed:@"bgText3"],
                   [UIImage imageNamed:@"bgText4"]];
    pageController =@[@"1",@"2",@"3",@"4",@"5"];
    
    [self.kenView animateWithImages:bannerImage
                         BannerText:bannerText
                         Pagenation:pageController
                 transitionDuration:7
                       initialDelay:0
                               loop:YES
                        isLandscape:YES];
    
    frontImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
//    alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view addSubview:frontImageView];
    
//    [self.view addSubview:alphaView];
    
    [frontImageView setAlpha:0.0f];
    
//    [alphaView setBackgroundColor:[UIColor whiteColor]];
//    alphaView.alpha = 0;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - KenBurnsViewDelegate

- (void)kenBurns:(JBKenBurnsView *)kenBurns didShowImage:(UIImage *)image atIndex:(NSUInteger)index
{
    
}

- (void)kenBurns:(JBKenBurnsView *)kenBurns didFinishAllImages:(NSArray *)images
{
    
}


#pragma mark - Gesture Methods

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (swipeCount >= 0) {
        if (swipeCount == 0) {
            swipeCount = 4;
        }
        else {
            swipeCount--;
        }
        [frontImageView setImage:[myImages objectAtIndex:swipeCount]];
        
        CATransition *transition = nil;
        transition = [CATransition animation];
        transition.duration = 2;//kAnimationDuration
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromRight;
        transition.delegate = self;
        [frontImageView.layer addAnimation:transition forKey:nil];
        
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            [alphaView setAlpha:0.6f];
            [frontImageView setAlpha:0.6f];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                [alphaView setAlpha:0.0f];
                [frontImageView setAlpha:0.0f];
            } completion:nil];
            
            [self.kenView previousImage];
        }];
    }
    else {
    }
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
     if (swipeCount <= 4) {
        if (swipeCount == 4) {
            swipeCount = 0;
        }
        else {
            swipeCount++;
        }
        [frontImageView setImage:[myImages objectAtIndex:swipeCount]];
        
        CATransition *transition = nil;
        transition = [CATransition animation];
        transition.duration = 2;//kAnimationDuration
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        transition.delegate = self;
        [frontImageView.layer addAnimation:transition forKey:nil];
        
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            [alphaView setAlpha:0.6f];
            [frontImageView setAlpha:0.6f];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                [alphaView setAlpha:0.f];
                [frontImageView setAlpha:0.0f];
                
            } completion:nil];
            [self.kenView nextImage];
            
        }];
        
    }
    else {
    }
}

#pragma mark - ButtonAction

-(void)createanAccountMethod
{
    DSLoginViewController *DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
    DSLoginView.temp = @"createAnAccount";
    [self.navigationController pushViewController:DSLoginView animated:YES];
    
}


- (IBAction)createAnAccount:(id)sender{
    
    [self createanAccountMethod];
}
- (IBAction)Signin:(id)sender{
   
        DSLoginViewController *DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
        DSLoginView.temp = @"Signin";
        [self.navigationController pushViewController:DSLoginView animated:YES];
 }

-(IBAction)didClickGeneralWalkAlterview:(id)sender
{
    self.walkAlterview.hidden=YES;
     [self flashOff:walkAlterviewBtn];
    DSLoginViewController *DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
    DSLoginView.temp = @"createAnAccount";
    [self.navigationController pushViewController:DSLoginView animated:YES];
}

- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .05;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}

@end
