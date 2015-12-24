//
//  DSTermsOfUseView.h
//  DoSomething
//
//  Created by OCS iOS Developer on 07/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSTermsOfUseView : UIView{
    UIImageView *imageView;
    UILabel     *label;
}

@property(nonatomic,weak)  UIImageView *imageviewBackground;
@property(nonatomic,weak)  UIView *viewContainer;
@property(nonatomic,weak)  UIWebView *termsConditionWebView;
@property(nonatomic,weak)  UIButton *closeButton;
@property (strong, nonatomic) NSMutableArray *userDetailsImageArray;
@property (strong, nonatomic) NSString *profileImageStringValue;
@end
