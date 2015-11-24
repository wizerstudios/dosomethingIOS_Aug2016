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
@interface DSHomeViewController ()
{
    int frameHt;
    int frameWt;
    NSArray *bannerImage;
    NSArray * bannerText;
}
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
    _scrollViewImage.userInteractionEnabled = NO;
     
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    bannerImage= @[[UIImage imageNamed:@"splash_bg"],
                   [UIImage imageNamed:@"bg1"],
                   [UIImage imageNamed:@"bg2"],
                   [UIImage imageNamed:@"bg3"],
                   [UIImage imageNamed:@"bg4"]];
    bannerText  =@[[NSString stringWithFormat:@"DOSOMETHING"],
                   [NSString stringWithFormat:@"Shared Moments Do Something that connects you with people"],
                   [NSString stringWithFormat:@"Active lifestyle Do Something that stimulates Your mind and body"],
                   [NSString stringWithFormat:@"New Interactions Do Something that broadens your social network"],
                   [NSString stringWithFormat:@"Unexpected Experiences Do Something that frees you from You comfort zone"]];
    
    [self.kenView animateWithImages:bannerImage
                         BannerText:bannerText
                 transitionDuration:5
                       initialDelay:0
                               loop:YES
                        isLandscape:YES];
    
}
- (void)viewDidUnload
{
    [self.kenView stopAnimation];
    [self setKenView:nil];
    
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
