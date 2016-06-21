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


#define enlargeRatio 1.1
#define imageBufer 3

@interface DSHomeViewController ()<PWParallaxScrollViewDataSource, PWParallaxScrollViewDelegate>
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
    //NSInteger Currentindex;
    NSMutableArray * bannerTitleArray;
    
    NSInteger swipeCount;
    UIImageView *frontImageView;
    UIView *alphaView;
    NSArray *myImages;
    
    //newchanges
    int               pgDtViewBottomSpace;
    
    NSInteger         Currentindex;
    
    NSDictionary    * commonDict;
    
    UIButton        * pageControllBtn;
    
    UIView          * pgDtView;
    
    UIButton *blkdot;
    
    BOOL isMyCurrentIndex;


}
@property (strong, nonatomic) IBOutlet PWParallaxScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *homeView;

@property (nonatomic, assign) BOOL isLandscape;

@end
@implementation DSHomeViewController
@synthesize delegate,walkAlterview,walkAlterviewBtn;
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
    
    isMyCurrentIndex=NO;
    self.walkAlterview.hidden =YES;
    [self flashOn:walkAlterviewBtn];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:FirstTimeLocationAlert];
    [[NSUserDefaults standardUserDefaults]synchronize];
   
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [super viewWillAppear:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if(IS_IPHONE6_Plus)
        self.viewHeightConstraint.constant = 688;
    else if(IS_IPHONE6)
        self.viewHeightConstraint.constant = 620;
    else
        self.viewHeightConstraint.constant = 525;//518
    
    
    [self setCommonDict];
    [self initControl];
    [self reloadData];
    
    //[_createAnAccBtn setHidden:YES];
    //[_signInBtn setHidden:YES];

}
-(void)setCommonDict
{

        commonDict = @{
                       @"BGimageArray":@[@"finalSplash",@"finalBg1",@"finalBg2",@"finalBg3",@"finalBg4"],
                       @"centerLogoImageArray":@[@"bglogo",@"",@"",@"",@""
                               ],
                       @"titleArray":@[NSLocalizedString(@"title1", @""),
                                       NSLocalizedString(@"title2", @""),
                                       NSLocalizedString(@"title3", @""),
                                       NSLocalizedString(@"title4", @""),
                                       NSLocalizedString(@"title5", @"")],
                       
                       @"subTitleArray":@[NSLocalizedString(@"subTitle1", @""),
                                      NSLocalizedString(@"subTitle2", @""),
                                      NSLocalizedString(@"subTitle3", @""),
                                      NSLocalizedString(@"subTitle4", @""),
                                      NSLocalizedString(@"subTitle5", @"")]
                       
                       
                       };

    
        if (IS_IPHONE4)
        {
            pgDtViewBottomSpace = 90;//100
        }
        else if (IS_IPHONE5)
        {
            pgDtViewBottomSpace = 110;//120
        }
        else
        {
            pgDtViewBottomSpace = 127;//157
        }
    
    
}


#pragma mark - view's life cycle

- (void)initControl
{
    
     self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:self.view.bounds];
     self.scrollView.isdifferSpeed = YES;
     _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
     [_homeView insertSubview:_scrollView atIndex:0];
    
}


- (void)reloadData
{
    
     _scrollView.delegate = self;
     _scrollView.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [COMMON TrackerWithName:@"Welcome Screen"];
    
    
    frontImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    

    
    [self.view addSubview:frontImageView];
    

    
    [frontImageView setAlpha:0.0f];
    

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
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

#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView
{
        int pgDtViewBottomWidth;
    
        pgDtViewBottomWidth = (int)([[commonDict valueForKey:@"BGimageArray"] count] - 1) * 25;
        
        pgDtView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2) - (pgDtViewBottomWidth/2), SCREEN_HEIGHT - pgDtViewBottomSpace, pgDtViewBottomWidth, 10)];
        
        pgDtView.backgroundColor = [UIColor clearColor];
        
        void (^cornerRadius)(UIButton *) = ^(UIButton * commonButton)
        {
            commonButton.layer.masksToBounds = YES;
            commonButton.layer.cornerRadius  = CGRectGetHeight(commonButton.frame)/2;
        };
        
        
        for(int i=0;i<[[commonDict valueForKey:@"BGimageArray"] count];i++)
        {
            blkdot = [[UIButton alloc]init];
            
            [blkdot setFrame:CGRectMake(i*25, 0, 10, 10)];
            
            [blkdot setTag:i];
            
            blkdot.enabled = NO;
            
          // [blkdot setBackgroundColor:[UIColor whiteColor]];
            
            cornerRadius(blkdot);
            
            [blkdot setImage:[UIImage imageNamed:@"Whitdot_active"] forState:UIControlStateNormal];
            
            [pgDtView addSubview:blkdot];
        }
    if(isMyCurrentIndex!=YES){
        pageControllBtn = [[UIButton alloc]init];
        
        pageControllBtn.backgroundColor = [UIColor whiteColor];
        
        pageControllBtn.enabled = NO;
        
        [pageControllBtn setFrame:CGRectMake(0, 0, 10, 10)];
        
        // [pageControllBtn setImage:[UIImage imageNamed:@"tinyWhiteDot_Hobby"] forState:UIControlStateNormal];
        
        cornerRadius(pageControllBtn);
        
        [pgDtView addSubview:pageControllBtn];
        
        [self.view addSubview: pgDtView];
    }
        return [[commonDict valueForKey:@"BGimageArray"] count];
    
    
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    
     UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[commonDict valueForKey:@"BGimageArray"][index]]];
     imageView.contentMode = UIViewContentModeScaleAspectFill;
     return imageView;
    
    
}
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    @try
    {
        NSInteger centerViewWidth,
        centerViewImageViewHeightandWidth;
        
        centerViewImageViewHeightandWidth   = SCREEN_HEIGHT / 2;
        centerViewWidth                     = SCREEN_HEIGHT;
       
        //backgroundView
        UIView * backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backgroundView.backgroundColor = [UIColor clearColor];
        CGFloat centreWidth= (SCREEN_WIDTH-(SCREEN_WIDTH/2));
        
        UIView * centreView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/2.2,centreWidth, centerViewImageViewHeightandWidth)];
        centreView.backgroundColor = [UIColor lightGrayColor];
       // [backgroundView addSubview:centreView];
        
         //centerViewImageView
        CGFloat imageWidth= (SCREEN_WIDTH-(SCREEN_WIDTH/3));
        UIImageView * centerViewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/3.5,imageWidth, centerViewImageViewHeightandWidth)];
        centerViewImageView.contentMode = UIViewContentModeScaleAspectFit;
        centerViewImageView.image = IMAGE([[commonDict valueForKey:@"centerLogoImageArray"] objectAtIndex:index]);
        
       // [backgroundView addSubview:centerViewImageView];
        
        int logoImageBottomSpace,subTitleLabelSpace;
        if(IS_IPHONE6_Plus||IS_IPHONE6||IS_IPAD){
            logoImageBottomSpace=45;
            subTitleLabelSpace = 50;
        }
        else{
            logoImageBottomSpace=40;
            subTitleLabelSpace = 58;
        }
        
        if(index==0){
            CGFloat logoImageWidth= (SCREEN_WIDTH-(SCREEN_WIDTH/3));
            UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, ((SCREEN_HEIGHT/2)-logoImageBottomSpace),logoImageWidth, 30)];
            logoImageView.contentMode = UIViewContentModeScaleAspectFit;
            logoImageView.image = IMAGE([[commonDict valueForKey:@"centerLogoImageArray"] objectAtIndex:index]);
           // logoImageView.backgroundColor = [UIColor lightGrayColor];
            [backgroundView addSubview:logoImageView];
        }
        
        CGFloat titleLabelWidth= (SCREEN_WIDTH-(SCREEN_WIDTH/4));
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/8, SCREEN_HEIGHT/2.2,titleLabelWidth, 60)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [COMMON getResizeableFont:PATRON_BOLD(18)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = [[commonDict valueForKey:@"titleArray"] objectAtIndex:index];
        //titleLabel.backgroundColor = [UIColor grayColor];
        [backgroundView addSubview:titleLabel];
        
        CGFloat subTitleLabelWidth= (SCREEN_WIDTH-(SCREEN_WIDTH/4));
        UILabel * subTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/8, titleLabel.frame.origin.y+titleLabel.frame.size.height-subTitleLabelSpace,subTitleLabelWidth, 110)];
        subTitle.numberOfLines = 0;
        //[COMMON getResizeableFont:FuturaStd_Book(11)]
        subTitle.font = [COMMON getResizeableFont:PATRON_REG(14)];
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.textColor = [UIColor whiteColor];
        subTitle.text = [[commonDict valueForKey:@"subTitleArray"] objectAtIndex:index];
        //subTitle.backgroundColor = [UIColor lightGrayColor];
        [backgroundView addSubview:subTitle];
        
        return backgroundView;
    }
    @catch (NSException *exception)
    {
       
    }
   
}
#pragma mark - PWParallaxScrollViewDelegate

- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index
{
     [pageControllBtn setFrame:CGRectMake(25*index, 0, 10, 10)];
     pageControllBtn.backgroundColor = [UIColor whiteColor];
     Currentindex = index;
    isMyCurrentIndex=YES;
    
}


- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
{
     Currentindex = index;
     isMyCurrentIndex=YES;
    
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
