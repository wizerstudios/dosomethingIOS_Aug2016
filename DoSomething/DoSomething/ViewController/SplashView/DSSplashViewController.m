//
//  DSSplashViewController.m
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSSplashViewController.h"
#import "DSSplashScrollView.h"
#import "DSAppCommon.h"
#import "DSConfig.h"
#import "DSLoginViewController.h"

@interface DSSplashViewController () <UIScrollViewDelegate,DSSplashViewController>
{
    IBOutlet UIButton    *signinButton;
    IBOutlet UIButton    *signupButton;
    
    DSSplashScrollView *splashView;
}
@property (nonatomic, assign) NSInteger currentpageIndex;
@end

@implementation DSSplashViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupConstraints];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self setInitialization];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




#pragma mark- Load Initilization

- (void)setInitialization{
    
    [signupButton   setTitle:NSLocalizedString(@"Create an Account", @"") forState:UIControlStateNormal];
    [signupButton.titleLabel setFont:[COMMON getResizeableFont:FutworaPro_Regular(12)]];
    
    [signinButton setTitle:NSLocalizedString(@"Sign In", @"") forState:UIControlStateNormal];
    [signinButton.titleLabel setFont:[COMMON getResizeableFont:FutworaPro_Regular(12)]];
}


#pragma mark - Load Constraints

-(void)setupConstraints {
    
    splashView = [DSSplashScrollView new];
    
    [splashView setSplashDelegate:self];
    
    [splashView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:splashView];
    
    NSArray *hConstrints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[splashView]-0-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(splashView)];
    
    [self.view addConstraints:hConstrints];
    
    
    NSArray *VConstrints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[splashView]-55-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(splashView)];
    
    [self.view addConstraints:VConstrints];    
    
    
    [splashView.layer setBorderColor:[UIColor clearColor].CGColor];
    
    [splashView.layer setBorderWidth:2.0f];
}


@end
