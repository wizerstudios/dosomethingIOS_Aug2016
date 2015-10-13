//
//  DSSplashScrollView.h
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DSSplashViewController <NSObject>



@end


@interface DSSplashScrollView : UIView


@property (nonatomic, retain) id <DSSplashViewController> splashDelegate;
@end
