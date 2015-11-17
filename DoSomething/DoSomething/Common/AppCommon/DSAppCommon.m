//
//  DSAppCommon.m
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSAppCommon.h"
#import "DSConfig.h"
@implementation DSAppCommon
DSAppCommon *sharedCommon = nil;

+ (DSAppCommon *)common {
    
    if (!sharedCommon) {
        
        sharedCommon = [[self alloc] init];
    }
    return sharedCommon;
}

- (id)init {
    
    return self;
}

#pragma mark - Get Current Device Info

- (currentDevice)getCurrentDevice
{
    if (([[UIScreen mainScreen] bounds].size.height == 480 && [[UIScreen mainScreen] bounds].size.width == 320) || ([[UIScreen mainScreen] bounds].size.width == 480 && [[UIScreen mainScreen] bounds].size.height == 320)) {
        return iPhone4;
    }
    else if (([[UIScreen mainScreen] bounds].size.height == 568 && [[UIScreen mainScreen] bounds].size.width == 320) || ([[UIScreen mainScreen] bounds].size.width == 568 && [[UIScreen mainScreen] bounds].size.height == 320))
        return iPhone5;
    else if (([[UIScreen mainScreen] bounds].size.height == 667 && [[UIScreen mainScreen] bounds].size.width == 375) || ([[UIScreen mainScreen] bounds].size.width == 667 && [[UIScreen mainScreen] bounds].size.height == 375))
        return iPhone6;
    else if (([[UIScreen mainScreen] bounds].size.height == 736 && [[UIScreen mainScreen] bounds].size.width == 414) || ([[UIScreen mainScreen] bounds].size.width == 736 && [[UIScreen mainScreen] bounds].size.height == 414))
        return iPhone6Plus;
    else if (([[UIScreen mainScreen] bounds].size.height == 768 && [[UIScreen mainScreen] bounds].size.width == 1024) || ([[UIScreen mainScreen] bounds].size.width == 1024 && [[UIScreen mainScreen] bounds].size.height == 768))
        return iPad;
    
    return 0;
}

#pragma mark - Resizeable Font

- (UIFont *)getResizeableFont:(UIFont *)currentFont {
    
    CGFloat sizeScale = 1;
    
    if (IS_IPHONE_DEVICE) {
        
        if ([COMMON getCurrentDevice] == iPhone6Plus)
        {
            sizeScale = 1.3;
        }
        else if ([COMMON getCurrentDevice] == iPhone6)
        {
            sizeScale = 1.2;
        }
    }
   else
   {
       sizeScale = 1.4;
   }
   return [currentFont fontWithSize:(currentFont.pointSize * sizeScale)];
}
#pragma mark Show alert

+(void)showSimpleAlertWithMessage:(NSString *)message{
//    UIAlertView *alert = [[UIAlertView  alloc]initWithTitle: APP_TITLE
//                                                   message: message
//                                                  delegate: nil
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles:nil];
//    
//    [alert show];
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_TITLE message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"ok action");}];
//    [alert addAction:ok];
    

}
+(UIAlertController*)alertWithTitle: (NSString *) title withMessage: (NSString*) message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_TITLE message:message preferredStyle: preferredStyle];
    UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"ok action");}];
    [alert addAction:ok];
    return alert;

}

#pragma mark - Userdetails

-(void)setUserDetails:(NSMutableDictionary *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableDictionary class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:USERDETAILS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeUserDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDETAILS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary *)getUserDetails
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    return dic;
    
}

- (BOOL) isUserLoggedIn {
    NSDictionary *userDetails = [self getUserDetails];
    if (userDetails != NULL) {
        return YES;
    }
    return NO;
}


#pragma mark User Interaction Loading :

-(void)LoadIcon:(UIView *)view
{
    [self removeLoading];
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width-37)/2, (view.frame.size.height-37)/2, 37, 37)];
    [loadingView.layer setCornerRadius:5.0];
    
    [loadingView setBackgroundColor:[UIColor blackColor]];
    //Enable maskstobound so that corner radius would work.
    [loadingView.layer setMasksToBounds:YES];
    //Set the corner radius
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView setFrame:CGRectMake(1, 1, 37, 37)];
    [activityView setHidesWhenStopped:YES];
    [activityView startAnimating];
    [loadingView addSubview:activityView];
    [view addSubview:loadingView];
}

-(void)removeLoading{
    [loadingView removeFromSuperview];
}




@end
