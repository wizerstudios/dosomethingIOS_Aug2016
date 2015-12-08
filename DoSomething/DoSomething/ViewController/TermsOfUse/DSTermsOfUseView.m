//
//  DSTermsOfUseView.m
//  DoSomething
//
//  Created by OCS iOS Developer on 07/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "DSTermsOfUseView.h"
#import "DSAppCommon.h"
#import "DSConfig.h"

@interface DSTermsOfUseView()<UIWebViewDelegate,UIScrollViewDelegate>
{
    BOOL isUpdateConstraint;
}

@end

@implementation DSTermsOfUseView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self configureElements];
    }
    
    return self;
}


#pragma mark - configure elements

-(void)singleTapClose:(UITapGestureRecognizer *)gesture{
    [self removeGestureRecognizer:gesture];
    [self removeFromSuperview];
    
}

-(void)configureElements{
    UIImageView *imagviewContainerBg = [[UIImageView alloc] init];
    [imagviewContainerBg setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imagviewContainerBg setBackgroundColor:[UIColor whiteColor]];
    [imagviewContainerBg setAlpha:0.6];
    [self addSubview:imagviewContainerBg];
    [self setImageviewBackground:imagviewContainerBg];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClose:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    
    UIView *viewContainer = [[UIView alloc] init];
    [viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewContainer setBackgroundColor:[UIColor whiteColor]];
    [viewContainer.layer setBorderWidth:1.0];
    [viewContainer.layer setBorderColor:[[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f] CGColor]];
    [self addSubview:viewContainer];
    [self setViewContainer:viewContainer];
    
    UIWebView *termsConditionWebView = [[UIWebView alloc] init ];
    termsConditionWebView.backgroundColor = [UIColor whiteColor];
    termsConditionWebView.scalesPageToFit = YES;
    termsConditionWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    termsConditionWebView.delegate = self;
    
    
   // [termsConditionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    [self.viewContainer addSubview:termsConditionWebView];
    [self setTermsConditionWebView:termsConditionWebView];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_button"]
                           forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    [self.viewContainer addSubview:closeButton];
    [self setCloseButton:closeButton];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(50,10,180,20)];
    label.textColor=[UIColor blackColor];
    [label setFont:[UIFont fontWithName:@"patron-regular" size:10]];
    [self.viewContainer addSubview:label];
    label.text= @"TERMS OF USE AND PRIVACY POLICY";
    
}

-(void)setUpConstraints
{
    
    NSDictionary *viewDictionary = @{@"_imagviewContainerBg":_imageviewBackground,
                                     @"_viewContainer":_viewContainer,
                                     @"_termsConditionWebView":_termsConditionWebView,
                                     @"_closeButton":_closeButton};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imagviewContainerBg]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imagviewContainerBg]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    int widthPosition,heightPosition;
    
    if(IS_IPHONE4|| IS_IPHONE5 ||IS_IPHONE6 ||IS_IPHONE6_Plus)
    {
        widthPosition=300;
        heightPosition=400;
    }
    else{
        
        widthPosition=700;
        heightPosition=700;
    }
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:0.98
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:widthPosition]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:heightPosition]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_termsConditionWebView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewDictionary]];
    
    
    
    [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_termsConditionWebView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewDictionary]];
    
    
    if(IS_IPHONE4|| IS_IPHONE5 ||IS_IPHONE6 ||IS_IPHONE6_Plus)
    {
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-275-[_closeButton(==20)]-10-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewDictionary]];
    }
    else
    {
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-670-[_closeButton(==20)]-10-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewDictionary]];
    }
    
    [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_closeButton(==20)]-500-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewDictionary]];
    
}

-(void)updateConstraints{
    [super updateConstraints];
    if (!isUpdateConstraint) {
        [self setUpConstraints];
        isUpdateConstraint = YES;
    }
}

+(BOOL)requiresConstraintBasedLayout{
    return YES;
}

@end
