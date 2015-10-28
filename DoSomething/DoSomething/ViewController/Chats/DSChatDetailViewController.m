//
//  DSChatDetailViewController.m
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/27/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSChatDetailViewController.h"

@interface DSChatDetailViewController ()

@end

@implementation DSChatDetailViewController
@synthesize activestring,ProfileName,ProfileImage,activestring1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    ProfileName.text=activestring;
    
    ProfileImage.image =[UIImage imageNamed:activestring1];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"menu_icon.png"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"menu_icon.png"]];
    self.navigationItem.title =@"DOSOMETHING";
    self.navigationItem.leftBarButtonItem.title = @"Log Out";
    
    Message1.text =@" Hey;)";
    Message1.layer.masksToBounds = YES;
    Message1.layer.cornerRadius = 8.0;
    
    Message2.text =@" Wanna meet for a drink?";
    Message2.layer.masksToBounds = YES;
    Message2.layer.cornerRadius = 8.0;
    
    Message3.text =@" oh hi!";
    Message3.layer.masksToBounds = YES;
    Message3.layer.cornerRadius = 8.0;
    
    Time1.text =@"13:20";
    Time2.text =@"13:20";
    Time3.text =@"13:24";
    OnlineLabel.text =@"Online";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (IBAction)showReallyFunkyIBActionSheet:(id)sender
{
    self.funkyIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Block", @"Delete",@"Cancel", nil];
    
    self.funkyIBAS.buttonResponse = IBActionSheetButtonResponseShrinksOnPress;
    [self.funkyIBAS setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:0];
    [self.funkyIBAS setButtonBackgroundColor:[UIColor  colorWithRed:(118/255.0) green:(118/255.0) blue:(118/255.0) alpha:1.0] forButtonAtIndex:0];
    [self.funkyIBAS setFont:[UIFont fontWithName:@"patron-reguler" size:17] forButtonAtIndex:0];
    
    [self.funkyIBAS setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:1];
    [self.funkyIBAS setButtonBackgroundColor:[UIColor colorWithRed:(230/255.0) green:(63/255.0) blue:(82/255.0) alpha:1.0] forButtonAtIndex:1];
    [self.funkyIBAS setFont:[UIFont fontWithName:@"patron-reguler" size:17] forButtonAtIndex:1];
    
    [self.funkyIBAS setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:2];
    [self.funkyIBAS setButtonBackgroundColor:[UIColor whiteColor] forButtonAtIndex:2];
    
    [self.funkyIBAS setFont:[UIFont fontWithName:@"patron-reguler" size:17]forButtonAtIndex:2];
    
    [self.funkyIBAS showInView:self.view];
}

#pragma mark - IBActionSheet/UIActionSheet Delegate Method

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at index: %ld clicked\nIts title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}


- (void)actionSheet:(IBActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Will dismiss with button index %ld", (long)buttonIndex);
}

- (void)actionSheet:(IBActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Dismissed with button index %ld", (long)buttonIndex);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
