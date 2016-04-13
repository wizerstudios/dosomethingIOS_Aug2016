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
    NSMutableArray * bannerTitleArray;

}
@property (nonatomic, strong) PWParallaxScrollView *parallaxscrollView;
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
    _scrollViewImage.userInteractionEnabled =YES;
    
     
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
    
    bannerTitleArray=[[NSMutableArray alloc] initWithObjects:@"bgText5",@"bgText1",@"bgText2",@"bgText3",@"bgText4", nil];
    
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
    
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index direction:(NSString *)ScrollDirection
    {
        UIView* shadeView = [[UIView alloc]initWithFrame:self.view.frame];
        shadeView.backgroundColor = [UIColor lightGrayColor];
        shadeView.alpha = .4;
        shadeView.tag=1500;
        _isLandscape=YES;
       
        UIImage *image;
        
        
       if([ScrollDirection isEqualToString:@"ScrollDirectionLeft"]&& index < 4)
       {
           index =index+1;
       }
        else if ([ScrollDirection isEqualToString:@"ScrollDirectionRight"] && index < 0)
        {
            index =index-1;
        }
        
      image =[UIImage imageNamed:FGimageArray[index]];
        
        
        
        UIImageView *imageView = nil;
        UIImageView    * textImageview   =nil;
       
        
        float originX       = -1;
        float originY       = -1;
        float zoomInX       = -1;
        float zoomInY       = -1;
        float moveX         = -1;
        float moveY         = -1;
        
        float frameWidth    = _isLandscape ? self.view.bounds.size.width: self.view.bounds.size.height;
        float frameHeight   = _isLandscape ? self.view.bounds.size.height: self.view.bounds.size.width;
        
        float resizeRatio = [self getResizeRatioFromImage:image width:frameWidth height:frameHeight];
        
        // Resize the image.
        float optimusWidth  = (image.size.width * resizeRatio) * enlargeRatio;
        float optimusHeight = (image.size.height * resizeRatio) * enlargeRatio;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,518)];
        imageView.tag=1500;
        
        
        if(index == 0)
        {
            textImageview  =[[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-60,self.view.center.y-80,145,63)];
        }
        else{
            textImageview  =[[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-100,self.view.center.y-60,227,67)];
        }
        textImageview.image =[UIImage imageNamed:bannerTitleArray[index]];
        [textImageview setBackgroundColor:[UIColor clearColor]];
        textImageview.tag=1500;
        
        
        imageView.backgroundColor = [UIColor greenColor];
       
        
        
        // Calcule the maximum move allowed.
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
        picLayer.contents    = (id)image.CGImage;
        picLayer.anchorPoint = CGPointMake(0, 0);
        picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
        picLayer.position    = CGPointMake(originX, originY);
        
        [imageView.layer addSublayer:picLayer];
        
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:1];
        [animation setType:kCATransitionFade];
        // [[self layer] addAnimation:animation forKey:nil];
        
        [shadeView addSubview:imageView];
       // [shadeView addSubview:textImageview];
//
        [UIView animateWithDuration:15.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             CGAffineTransform rotate    = CGAffineTransformMakeRotation(rotation);
             CGAffineTransform moveRight = CGAffineTransformMakeTranslation(moveX, moveY);
             CGAffineTransform combo1    = CGAffineTransformConcat(rotate, moveRight);
             CGAffineTransform zoomIn    = CGAffineTransformMakeScale(zoomInX, zoomInY);
             CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
             imageView.transform = transform;
             
             
         } completion:^(BOOL finished) {
             
         }];
        [scrollView insertSubview:shadeView atIndex:index];
        [scrollView bringSubviewToFront:shadeView];

    }
    
    
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
{
        for(UIView * view in scrollView.subviews)
        {
            if(view.tag == 1500)
            {
              //  [UIView animateWithDuration:0.1 animations:^{
                 [view removeFromSuperview];
           // }];
               
            }
        }
        Currentindex = index;
    
        if (index == [BGimageArray count] - 1) {
            //[self createanAccountMethod];
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

- (float)getResizeRatioFromImage:(UIImage *)image width:(float)frameWidth height:(float)frameHeight
{
    float resizeRatio   = -1;
    float widthDiff     = -1;
    float heightDiff    = -1;
    if(IS_IPHONE6_Plus)
    {
        frameHeight=frameHeight-69;
    }
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


@end
