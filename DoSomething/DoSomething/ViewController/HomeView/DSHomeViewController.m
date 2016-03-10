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
#import "PWParallaxScrollView.h"

#define enlargeRatio 1.1
#define imageBufer 3

@interface DSHomeViewController ()<PWParallaxScrollViewDataSource,PWParallaxScrollViewDelegate>
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

}
@property (nonatomic, strong) PWParallaxScrollView *parallaxscrollView;
@property (nonatomic, assign) BOOL isLandscape;

@end
@implementation DSHomeViewController
@synthesize delegate,walkAlterview;
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
    NSString * Firstlogin=[[NSUserDefaults standardUserDefaults]valueForKey:FirstDisplayGeneralAlterView];
    
    if([Firstlogin isEqualToString:@"HomeviewAnimation"])
    {
        self.walkAlterview.hidden =NO;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:FirstDisplayGeneralAlterView];
         [[NSUserDefaults standardUserDefaults] setObject:@"FirstCreatAccount" forKey:FirstCreatAccount];
    }

    self.kenView.delegate = self;
    _scrollViewImage.userInteractionEnabled =YES;
    
     
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    bannerImage= @[[UIImage imageNamed:@"splash_bg"],
                   [UIImage imageNamed:@"bg1"],
                   [UIImage imageNamed:@"bg2"],
                   [UIImage imageNamed:@"bg3"],
                   [UIImage imageNamed:@"bg4"]];
    bannerText  =@[[UIImage imageNamed:@"bgText5"],
                   [UIImage imageNamed:@"bgText1"],
                   [UIImage imageNamed:@"bgText2"],
                   [UIImage imageNamed:@"bgText3"],
                   [UIImage imageNamed:@"bgText4"]];
    pageController =@[@"1",@"2",@"3",@"4",@"5"];
    

    [self initControl];
    [self SetImageArray];
    [self reloadData];
    
}
- (void)viewDidUnload
{
 [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - KenBurnsViewDelegate

- (void)kenBurns:(JBKenBurnsView *)kenBurns didFinishAllImages:(NSArray *)images
{
    NSLog(@"Yay all done!");
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
-(void)viewDidDisappear:(BOOL)animated{
    
}

- (void)initControl
{
    self.parallaxscrollView = [[PWParallaxScrollView alloc] initWithFrame:self.view.bounds];
    
    self.parallaxscrollView.isdifferSpeed = YES;
    
    _parallaxscrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.kenView insertSubview:_parallaxscrollView atIndex:0];
}
-(void)SetImageArray
{
    
    BGimageArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",nil];
    FGimageArray = [[NSMutableArray alloc] initWithObjects:@"splash_bg",@"bg1",@"bg2",@"bg3",@"bg4",nil];
    bannerImageArr=[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"bgText5"],[UIImage imageNamed:@"bgText1"],[UIImage imageNamed:@"bgText2"],[UIImage imageNamed:@"bgText3"],[UIImage imageNamed:@"bgText4"], nil];
    

    
}

- (void)reloadData
{
    _parallaxscrollView.delegate = self;
    _parallaxscrollView.dataSource = self;
}

#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView
{
    return [BGimageArray count];
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BGimageArray[index]]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
   
    return imageView;
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    foregroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-60)];
    
    UIView *labelTitle;
    UIImageView *textImg=[[UIImageView alloc]init];
    
    // CGFloat yPosition = 0;
    
    mainview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,self.view.frame.size.height)];
    [mainview setBackgroundColor:[UIColor clearColor]];
    [foregroundView addSubview:mainview];
    
    if(IS_IPHONE4)
    {
        labelTitle = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-100,self.view.center.y-30,227,67)];
        
    }
    else
    {
        labelTitle = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-100,self.view.center.y-60,227,67)];
               
        
    }
    textImg.frame =(index==0)?CGRectMake(30,0,147,63):CGRectMake(0,0,227,67);
    objImag=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];

    textImg.image=[bannerImageArr objectAtIndex:index];
    [labelTitle addSubview:textImg];
    
    [labelTitle sizeToFit];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [objImag addSubview:labelTitle];
    
    
    objImag.image=[UIImage imageNamed:FGimageArray[index]];
    
    
    
    [mainview addSubview:objImag];
    
    
    return foregroundView;
}

#pragma mark - PWParallaxScrollViewDelegate
    
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index
    {
    }
    
    
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
    {
        
        Currentindex = index;
        
        if (index == [BGimageArray count] - 1) {
            [self createanAccountMethod];
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
}


@end
