//
//  DSChatDetailViewController.m
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/27/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSChatDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"

@interface DSChatDetailViewController ()

@end

@implementation DSChatDetailViewController
@synthesize activestring,ProfileName,ProfileImage,activestring1;
@synthesize chatView,chatuserDetailsDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ProfileName.text= [chatuserDetailsDict valueForKey:@"Name"];
    NSString *profileStr = [NSString stringWithFormat:@"%@",[chatuserDetailsDict valueForKey:@"image1"]];
    downloadImageFromUrl(profileStr, ProfileImage);
    ProfileImage.image = [UIImage imageNamed:profileStr];
    [ProfileImage.layer setCornerRadius:28];
    [ProfileImage.layer setMasksToBounds:YES];
    
    Message1.text =@"   Hey;)";
    Message1.layer.masksToBounds = YES;
    Message1.layer.cornerRadius = 8.0;
    
    Message2.text =@"   Wanna meet for a drink?";
    Message2.layer.masksToBounds = YES;
    Message2.layer.cornerRadius = 8.0;
    
    Message3.text =@"   oh hi!";
    Message3.layer.masksToBounds = YES;
    Message3.layer.cornerRadius = 8.0;
    
    Time1.text =@"13:20";
    Time2.text =@"13:20";
    Time3.text =@"13:24";
    OnlineLabel.text =@"Online";
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);//65
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [customNavigation.saveBtn setHidden:YES];
    
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    //    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    _transparentView.hidden = YES;
    _backgroundView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (IBAction)showReallyFunkyIBActionSheet:(id)sender
{
     _menuImageview.hidden = YES;
    _transparentView.hidden = NO;
    _backgroundView.hidden = NO;
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [chatView.placeHolderLabel setHidden:YES];
    [UIView animateWithDuration:.25f animations:^{
        if(IS_IPHONE4)
            chatView.frame=CGRectMake(0,160,320,65);
        
        else
            chatView.frame=CGRectMake(0,300,320,40);
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:.25f animations:^{
        if(IS_IPHONE4)
            chatView.frame=CGRectMake(0,412,320,65);
        else
            chatView.frame=CGRectMake(0,350,320,65);
    }];
    
}


#pragma mark - All the other junk for the sample project

- (void)viewWillLayoutSubviews {
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        [self setUpForPortrait];
    } else {
        [self setUpForLandscape];
    }
    
    if (self.standardIBAS.visible) {
        [self.standardIBAS rotateToCurrentOrientation];
    }
    if (self.customIBAS.visible) {
        [self.customIBAS rotateToCurrentOrientation];
    }
    if (self.funkyIBAS.visible) {
        [self.funkyIBAS rotateToCurrentOrientation];
    }
}
- (void)setUpForPortrait {
    
    float halfOfWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0;
    float height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    self.semiTransparentView.frame = CGRectMake(0, 0, halfOfWidth * 2.0, height+40);
    self.semiTransparentView.center = CGPointMake(halfOfWidth, height /0);
    
    self.funkyIBASButton.center = CGPointMake(halfOfWidth, (height / 2.0) +120);
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        height -= 0;
    }
}
- (void)setUpForLandscape
{
    float halfOfWidth = CGRectGetHeight([UIScreen mainScreen].bounds) / 2.0;
    float height = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.funkyIBASButton.center = CGPointMake(halfOfWidth, (height / 2.0) + 120);
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        height -= 0;
    }
}

- (void)addBorderToButton:(UIButton *)button
{
    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        button.frame = CGRectMake(CGRectGetMinX(button.frame), CGRectGetMinY(button.frame), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame) + 0);
        return;
    }
    
    button.layer.cornerRadius = 0.0f;
    button.layer.borderWidth = 0.0f;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
}






- (IBAction)pressCancel:(id)sender {
    _transparentView.hidden = YES;
    _backgroundView.hidden = YES;
     _menuImageview.hidden = NO;
}

- (IBAction)pressDelete:(id)sender {
    _transparentView.hidden = YES;
    _backgroundView.hidden = YES;
     _menuImageview.hidden = NO;
}

- (IBAction)pressBlock:(id)sender {
    _transparentView.hidden = YES;
    _backgroundView.hidden = YES;
     _menuImageview.hidden = NO;
}
@end
