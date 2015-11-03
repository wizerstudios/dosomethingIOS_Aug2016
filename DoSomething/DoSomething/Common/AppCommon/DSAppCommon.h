//
//  DSAppCommon.h
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
typedef enum {
    
    iPhone4,
    iPhone5,
    iPhone6,
    iPhone6Plus,
    iPad
}currentDevice ;

@interface DSAppCommon : NSObject
{
    
    NSArray *permissions;
}

+(DSAppCommon *) common;


- (currentDevice)getCurrentDevice;

// ResizeableFont
- (UIFont *)getResizeableFont:(UIFont *)currentFont;
+(void)showSimpleAlertWithMessage:(NSString *)message;

@end
extern DSAppCommon *sharedCommon;
#define COMMON (sharedCommon? sharedCommon:[DSAppCommon common])