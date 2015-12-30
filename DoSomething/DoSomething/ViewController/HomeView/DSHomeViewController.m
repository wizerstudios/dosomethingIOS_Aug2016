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

}
@property (nonatomic, strong) PWParallaxScrollView *parallaxscrollView;
@property (nonatomic, assign) BOOL isLandscape;

@end
@implementation DSHomeViewController
@synthesize delegate;
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
    
    [self.kenView animateWithImages:bannerImage
                         BannerText:bannerText
                        Pagenation :pageController
                 transitionDuration:8
                       initialDelay:0
                               loop:YES
                        isLandscape:YES];
    //[self initControl];
   // [self SetImageArray];
    //[self reloadData];
    
}
- (void)viewDidUnload
{
    [self.kenView stopAnimation];
    [self setKenView:nil];
   // [self initControl];
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
    [kenView setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [kenView layoutIfNeeded];
    if(IS_IPHONE6_Plus)
        self.viewHeightConstraint.constant = 688;
    else if(IS_IPHONE6)
        self.viewHeightConstraint.constant = 620;
    else if(IS_IPHONE4)
        self.viewHeightConstraint.constant = 430;
    
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
    
    BGimageArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",nil];
    FGimageArray = [[NSMutableArray alloc] initWithObjects:@"splash_bg",@"bg1",@"bg2",@"bg3",@"bg4",nil];
    
}

- (void)reloadData
{
    _parallaxscrollView.delegate = self;
    _parallaxscrollView.dataSource = self;
}

#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView
{
    UIView *pgDtView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - (([BGimageArray count] * 30)/2) + 18 ,40, [BGimageArray count] * 20, 15)];
    
    pgDtView.backgroundColor = [UIColor clearColor];
    
    for(int i=0;i<[BGimageArray count];i++){
        
        UIButton *blkdot = [[UIButton alloc]init];
        
        [blkdot setFrame:CGRectMake(i*20, 0, 10, 10)];
        
        [blkdot setTag:i];
        
        [blkdot setBackgroundColor:[UIColor clearColor]];
        
        [blkdot setImage:[UIImage imageNamed:@"tuto_dot_Inactive.png"] forState:UIControlStateNormal];
        
        [pgDtView addSubview:blkdot];
    }
    
//    pageControllBtn = [[UIButton alloc]init];
//    
//    pageControllBtn.backgroundColor = [UIColor clearColor];
//    [pageControllBtn setFrame:CGRectMake(0, 0, 10, 10)];
//    [pageControllBtn setImage:[UIImage imageNamed:@"tuto_dot"] forState:UIControlStateNormal];
//    
//    
//    
//    [pgDtView addSubview:pageControllBtn];
    
    [self.view addSubview: pgDtView];
    
    
    
    return [BGimageArray count];
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BGimageArray[index]]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //[imageView setBackgroundColor:[UIColor redColor]];
    return imageView;
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    foregroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-60)];
    
    UILabel *labelTitle;
    // CGFloat yPosition = 0;
    
    mainview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,self.view.frame.size.height)];
    [mainview setBackgroundColor:[UIColor clearColor]];
    [foregroundView addSubview:mainview];
    
    if(IS_IPHONE4)
    {
       
        objImag=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+50,labelTitle.frame.origin.y+labelTitle.frame.size.height+15,self.view.frame.size.width-105,self.view.frame.size.height-110)];
        
    }
    else
    {
        
        objImag=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,labelTitle.frame.origin.y+labelTitle.frame.size.height,self.view.frame.size.width,self.view.frame.size.height)];
        
        
        
    }
    
    
    objImag.image=[UIImage imageNamed:FGimageArray[index]];
    
    [mainview addSubview:objImag];
    
   
       return foregroundView;
}




#pragma mark - PWParallaxScrollViewDelegate

- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index
{
    
    UIImage * objimage =[UIImage imageNamed:FGimageArray[index]];
    float originX       = -1;
    float originY       = -1;
    float zoomInX       = -1;
    float zoomInY       = -1;
    float moveX         = -1;
    float moveY         = -1;
    
    float frameWidth    = _isLandscape ? self.view.bounds.size.width: self.view.bounds.size.height;
    float frameHeight   = _isLandscape ? self.view.bounds.size.height: self.view.bounds.size.width;
    
    float resizeRatio = [self getResizeRatioFromImage:objimage width:frameWidth height:frameHeight];
    float optimusWidth  = (objimage.size.width * resizeRatio) * enlargeRatio;
    float optimusHeight = (objimage.size.height * resizeRatio) * enlargeRatio;
    float maxMoveX = optimusWidth - frameWidth;
    float maxMoveY = optimusHeight - frameHeight;
    
    float rotation = (arc4random() % 9) / 100;
    
    switch (arc4random() % 4) {
        case 0:
            originX = 0;
            originY = 0;
            zoomInX = 1.25;
            zoomInY = 1.25;
            moveX   = -maxMoveX;
            moveY   = -maxMoveY;
            break;
            
        case 1:
            originX = 0;
            originY = frameHeight - optimusHeight;
            zoomInX = 1.10;
            zoomInY = 1.10;
            moveX   = -maxMoveX;
            moveY   = maxMoveY;
            break;
            
        case 2:
            originX = frameWidth - optimusWidth;
            originY = 0;
            zoomInX = 1.30;
            zoomInY = 1.30;
            moveX   = maxMoveX;
            moveY   = -maxMoveY;
            break;
            
        case 3:
            originX = frameWidth - optimusWidth;
            originY = frameHeight - optimusHeight;
            zoomInX = 1.20;
            zoomInY = 1.20;
            moveX   = maxMoveX;
            moveY   = maxMoveY;
            break;
            
        default:
            NSLog(@"Unknown random number found in JBKenBurnsView _animate");
            break;
    }
    
    
    CALayer *picLayer    = [CALayer layer];
    picLayer.contents    = (id)objimage.CGImage;
    picLayer.anchorPoint = CGPointMake(0, 0);
    picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
    picLayer.position    = CGPointMake(originX, originY);
    
    [foregroundView.layer addSublayer:picLayer];
    
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:1];
    [animation setType:kCATransitionFade];
    [self.view.layer addAnimation:animation forKey:nil];
    
    // Remove the previous view
//    if ([[self subviews] count] > 0)
//    {
//        UIView *oldImageView = [[self subviews] objectAtIndex:0];
//        [oldImageView removeFromSuperview];
//        oldImageView = nil;
//    }
    
    //[self addSubview:mainview];
    //[self addSubview:textImageview];
    //[self addSubview:pageControllBtn];
    
    // Generates the animation  //before: UIViewAnimationCurveEaseInOut
    [UIView animateWithDuration:8 + 5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         CGAffineTransform rotate    = CGAffineTransformMakeRotation(rotation);
         CGAffineTransform moveRight = CGAffineTransformMakeTranslation(moveX, moveY);
         CGAffineTransform combo1    = CGAffineTransformConcat(rotate, moveRight);
         CGAffineTransform zoomIn    = CGAffineTransformMakeScale(zoomInX, zoomInY);
         CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
         foregroundView.transform = transform;
         
     } completion:^(BOOL finished) {}];
    
    //[pageControllBtn setFrame:CGRectMake(20*index, 0, 10, 10)];
    //Currentindex = index;
}
- (float)getResizeRatioFromImage:(UIImage *)image width:(float)frameWidth height:(float)frameHeight
{
    float resizeRatio   = -1;
    float widthDiff     = -1;
    float heightDiff    = -1;
    
    // Wider than screen
    if (image.size.width > frameWidth)
    {
        widthDiff  = image.size.width - frameWidth;
        
        // Higher than screen
        if (image.size.height > frameHeight)
        {
            heightDiff = image.size.height - frameHeight;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameHeight / image.size.height;
            else
                resizeRatio = frameWidth / image.size.width;
        }
        // No higher than screen
        else
        {
            heightDiff = frameHeight - image.size.height;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameWidth / image.size.width;
            else
                resizeRatio = self.view.bounds.size.height / image.size.height;
        }
    }
    // No wider than screen
    else
    {
        widthDiff  = frameWidth - image.size.width;
        
        // Higher than screen
        if (image.size.height > frameHeight)
        {
            heightDiff = image.size.height - frameHeight;
            
            if (widthDiff > heightDiff)
                resizeRatio = image.size.height / frameHeight;
            else
                resizeRatio = frameWidth / image.size.width;
        }
        // No higher than screen
        else
        {
            heightDiff = frameHeight - image.size.height;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameWidth / image.size.width;
            else
                resizeRatio = frameHeight / image.size.height;
        }
    }
    
    return resizeRatio;
}



- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
{
    
    //Currentindex = index;
    
    if (index == [BGimageArray count] - 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"first_launch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //tutoriallastPage=YES;
        
        //flag = 0;
        
    }
    else{
        //tutoriallastPage=NO;
       // flag = 0;
        
    }
    
}




#pragma mark - ButtonAction
- (IBAction)createAnAccount:(id)sender{
    
        DSLoginViewController *DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
        DSLoginView.temp = @"createAnAccount";
        [self.navigationController pushViewController:DSLoginView animated:YES];
}
- (IBAction)Signin:(id)sender{
   
        DSLoginViewController *DSLoginView  = [[DSLoginViewController alloc]initWithNibName:@"DSLoginViewController" bundle:nil];
        DSLoginView.temp = @"Signin";
        [self.navigationController pushViewController:DSLoginView animated:YES];
 }




@end
