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

@interface DSHomeViewController ()
{
    int frameHt;
    int frameWt;
    BOOL imageView;
    BOOL isTimerStop;
}
@end
@implementation DSHomeViewController
@synthesize delegate,timer1;
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
    isTimerStop=NO;
   
    if(IS_IPHONE6_Plus ) {
        frameHt=670;
        frameWt= 414;
        self.layoutConstraintsCreateAnAccBtnHeight.constant =68;
        self.layoutConstraintsSignInBtnHeight.constant =68;
        bannerImageArr=[[NSMutableArray alloc]initWithObjects:@"splashImage_1",@"splashImage_2" ,@"splashImage_3", nil];
        
    }
    
    if(IS_IPHONE6 ) {
        frameHt=609;
        frameWt= 374;
        self.layoutConstraintsCreateAnAccBtnHeight.constant =60;
        self.layoutConstraintsSignInBtnHeight.constant =60;
        bannerImageArr=[[NSMutableArray alloc]initWithObjects:@"splashImage_1",@"splashImage_2" ,@"splashImage_3", nil];

    }
      if(IS_IPHONE5 )
    {
        frameHt=518;
        frameWt=320;
        bannerImageArr=[[NSMutableArray alloc]initWithObjects:@"splashImage_1",@"splashImage_2" ,@"splashImage_3", nil];

    }

    [self loadSlideScroll];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
}
-(void)loadSlideScroll
{
    for( UIView *subView in [self.scrollViewImage subviews]) {
        [subView removeFromSuperview];
    }
    for (int i=0; i<bannerImageArr.count;  i++)
    {
        
        infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(i*frameWt, 0, frameWt, frameHt)];
        infoImage.tag = i+1;
        UIImageView *imageforBanner=[[UIImageView alloc] init];
        imageforBanner.frame=CGRectMake(0, 0, frameWt, frameHt);
        imageforBanner.image=[UIImage imageNamed:[bannerImageArr objectAtIndex:i]];
        [infoImage addSubview:imageforBanner];
        [self.scrollViewImage addSubview:infoImage];
        
        NSLog(@"SLIDESCROLLSUBVIEWS == %@",self.scrollViewImage.subviews);
        
    }
    [self.scrollViewImage setContentSize:CGSizeMake((bannerImageArr.count * frameWt), 100)];
    
    xslider=0;
    pgDtView=[[UIView alloc]init];
    pgDtView.backgroundColor=[UIColor clearColor];
    imageViewActive =[[UIImageView alloc]init];
    
    self.infoPageControl.numberOfPages=bannerImageArr.count;
    
    for(int i=0;i<self.infoPageControl.numberOfPages;i++)
    {
        [imageViewActive setFrame:CGRectMake(0, 0,10, 10)];
        [imageViewActive setImage:[UIImage imageNamed:@"dot_active"]];
        [pgDtView addSubview:imageViewActive];

      
        imageViewDot=[[UIImageView alloc]init];
        [imageViewDot setFrame:CGRectMake(i*13, 0, 10, 10 )];
        [imageViewDot setImage:[UIImage imageNamed:@"dot_Image"]];
        [pgDtView addSubview:imageViewDot];
       
        [self.view addSubview:pgDtView];
        if(IS_IPHONE6_Plus ){
            [pgDtView setFrame:CGRectMake(190, 624, self.infoPageControl.numberOfPages*13, 10)];
            
        }

        if(IS_IPHONE6 ){
            [pgDtView setFrame:CGRectMake(169, 570, self.infoPageControl.numberOfPages*13, 10)];
        }
             if(IS_IPHONE5 )
       {
            [pgDtView setFrame:CGRectMake(142, 484, self.infoPageControl.numberOfPages*13, 10)];
        }
    }
    
    [self timerFunction];
    
    
}
-(void)timerFunction{
    jslider=bannerImageArr.count;
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
}
-(void)nextPage:(NSTimer *)_timer
{
    
    if (isTimerStop==NO) {
        CGRect newRect ;
        if(jslider < bannerImageArr.count){
            xslider += frameWt;
            newRect = CGRectMake(xslider, 0,frameWt,frameHt);
            [imageViewActive setImage:[UIImage imageNamed:@"dot_active"]];
            [self.scrollViewImage scrollRectToVisible:newRect animated:YES];
            [imageViewActive setFrame:CGRectMake(jslider*13, 0, 10, 10)];
            jslider++;
            
        }
        else{
            xslider=0-frameWt;
            jslider=0;
            [self.scrollViewImage setContentOffset:CGPointMake(0, 0)];
            [imageViewActive setFrame:CGRectMake(jslider*13, 0, 10, 10)];
        }

    }
    
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView2
//{
//    isTimerStop=YES;
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView2
{
    jslider = scrollView2.contentOffset.x/frameWt;
    [self.scrollViewImage setNeedsDisplay];
    self.infoPageControl.currentPage=jslider;
    [imageViewActive setFrame:CGRectMake(jslider*13, 0, 10, 10)];
   
}

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
