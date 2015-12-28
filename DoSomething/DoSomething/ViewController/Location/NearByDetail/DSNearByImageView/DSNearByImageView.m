//
//  DSNearByImageView.m
//  DoSomething
//
//  Created by OCS iOS Developer on 26/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "DSNearByImageView.h"
#import "DSAppCommon.h"
#import "DSConfig.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+FontAwesome.h"

@interface DSNearByImageView()<UIWebViewDelegate>
{
    BOOL isUpdateConstraint;
}

@end

@implementation DSNearByImageView
@synthesize userDetailsImageArray,profileImageStringValue;

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
    [imagviewContainerBg setBackgroundColor:[UIColor clearColor]];
    imagviewContainerBg.userInteractionEnabled = YES;
    //  [imagviewContainerBg setAlpha:0.6];
    [self addSubview:imagviewContainerBg];
    [self setImageviewBackground:imagviewContainerBg];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClose:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    
    UIView *viewContainer = [[UIView alloc] init];
    [viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
   // viewContainer.backgroundColor = [UIColor clearColor];
    viewContainer.userInteractionEnabled = YES;
    //  [viewContainer setAlpha:0.6];
     // [viewContainer.layer setBorderWidth:1.0];
    [self addSubview:viewContainer];
    [self setViewContainer:viewContainer];
    
    UIView *termsConditionWebView = [[UIView alloc] init];
    termsConditionWebView.backgroundColor = [UIColor colorWithRed:210.0f/255.0f
                                                   green:210.0f/255.0f
                                                    blue:210.0f/255.0f
                                                   alpha:1.0f];
    [termsConditionWebView setAlpha:0.7];
    termsConditionWebView.userInteractionEnabled = YES;
    termsConditionWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    // [termsConditionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    [self.viewContainer addSubview:termsConditionWebView];
    [self setTermsConditionWebView:termsConditionWebView];
    
    

    
}

-(void)setUpConstraints
{
    
    NSDictionary *viewDictionary = @{@"_imagviewContainerBg":_imageviewBackground,
                                     @"_viewContainer":_viewContainer,
                                     @"_termsConditionWebView":_termsConditionWebView,
                                     };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imagviewContainerBg]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imagviewContainerBg]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    int widthPosition,heightPosition;
    
    if(IS_IPHONE4 )
    {
        widthPosition=320;//300,320
        heightPosition=400;//400
        
    }
    else if(IS_IPHONE5){
        
        widthPosition=320;
        heightPosition=450;
        
    }
    else if(IS_IPHONE6){
        
        widthPosition=400;
        heightPosition=533;
       
    }
    else if(IS_IPHONE6_Plus){
        
        widthPosition=414;
        heightPosition=600;
        
    }
    else{
        
        widthPosition=700;
        heightPosition=700;
    }
    if(IS_IPHONE6||IS_IPHONE6_Plus)
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0421 //98
                                                          constant:0]];
            
        }
    else if(IS_IPHONE5)
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0237 //98 //0.93
                                                          constant:0]];
        
    }
    else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewContainer
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:0.93 //98
                                                          constant:0]];

        
    }
    
        
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
    
    
    
    
    [self getImage];
    
    
}
#pragma mark - getImage
-(void) getImage{
    
    //VIEW PROFILE IMAGE
    if(IS_IPHONE6_Plus)
    {
    viewProfile = [[UIView alloc] initWithFrame:CGRectMake(-25,0,460,450)];//-35,0,500,450
   
    }
    else if(IS_IPHONE6)
    {
        viewProfile = [[UIView alloc] initWithFrame:CGRectMake(-25,0,460,400)];//-35,0,500,450
        
    }
    else{
        viewProfile = [[UIView alloc] initWithFrame:CGRectMake(-35,0,390,360)];
    }
    
   
    //viewProfile.backgroundColor = [UIColor clearColor];
    //[viewProfile.layer setBorderWidth:1.0];
    
    [self.viewContainer addSubview:viewProfile];
    viewProfile.userInteractionEnabled = YES;
    int r1,r2;
    
    if(IS_IPHONE6||IS_IPHONE6_Plus)
    {
        r1=160.0;
        r2=160.0;
    }
    else{
        r1=140.0;
        r2=140.0;
        
    }
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:viewProfile.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(r1, r2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame =viewProfile.bounds;
    maskLayer.path = maskPath.CGPath;
    viewProfile.layer.mask = maskLayer;
  //  viewProfile.layer.cornerRadius = viewProfile.frame.size.height/ 2;
  //  viewProfile.layer.masksToBounds = YES;
   // bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;

    if(IS_IPHONE6_Plus)
    {
        imageView =[[UIImageView alloc] initWithFrame:CGRectMake(25,0,415,450)];//(10,0,500,450)
    }
    else if(IS_IPHONE6)
    {
        imageView =[[UIImageView alloc] initWithFrame:CGRectMake(25,0,415,400)];//(10,0,500,450)
    }
    else{
        imageView =[[UIImageView alloc] initWithFrame:CGRectMake(35,0,325,360)];
    }

   // [imageView.layer setBorderWidth:1.0];
    //-20,0,380,360
    
    if([profileImageStringValue isEqualToString:@""]){
        [imageView setImage:[UIImage imageNamed:@"profile_noimg"]];
    }
    else{
        downloadImageFromUrl(profileImageStringValue, imageView);
        [imageView setImageWithURL:[NSURL URLWithString:profileImageStringValue]];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
     [viewProfile addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    //VIEW PROFILE LABEL
    
    label = [[UILabel alloc] init];
    if(IS_IPHONE6_Plus)
    {
        [label setFrame:CGRectMake(0,470,420,40)];
        
    }
    else if(IS_IPHONE6)
    {
        [label setFrame:CGRectMake(0,420,420,40)];
        
    }
    else if(IS_IPHONE5)
    {
        [label setFrame:CGRectMake(0,365,320,40)];
        
    }
    else{
        [label setFrame:CGRectMake(0,365,320,40)];
    }
    
    label.textColor=[UIColor colorWithRed:218.0f/255.0f
                                    green:40.0f/255.0f
                                     blue:64.0f/255.0f
                                    alpha:1.0f];
   //  label.backgroundColor = [UIColor whiteColor];
    [label setFont:[UIFont fontWithName:@"patron-bold" size:16]];
    [self.viewContainer addSubview:label];
    //label.text= [self getData];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.userInteractionEnabled = YES;
    
    NSString *strUserGender;
    if(IS_IPHONE5)
        
        [label setFont:[UIFont fontWithName:@"FontAwesome" size:16]];
    
    else
        
        [label setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    
    
    if([[userDetailsImageArray valueForKey:@"gender"]isEqualToString:@"Female"]){
        strUserGender= [NSString stringWithFormat:@"%@", @"\uf221"];
        
    }
    else{
        strUserGender = [NSString stringWithFormat:@"%@", @"\uf222"];
    }

    UIFont *awesomeFont = [UIFont fontWithName:@"FontAwesome" size:16];
    NSDictionary *awesomeFontDict = [NSDictionary dictionaryWithObject:awesomeFont forKey:NSFontAttributeName];
    NSMutableAttributedString *awAttrString = [[NSMutableAttributedString alloc] initWithString:strUserGender attributes: awesomeFontDict];
    
    UIFont *patronFont = [UIFont fontWithName:@"patron-bold" size:16];
    NSDictionary *patronFontDict = [NSDictionary dictionaryWithObject:patronFont forKey:NSFontAttributeName];
    NSMutableAttributedString *patAttrString = [[NSMutableAttributedString alloc]initWithString: [self getData] attributes:patronFontDict];
    
    [awAttrString appendAttributedString:patAttrString];
    
    
    label.attributedText = awAttrString;

}

#pragma mark - userAgeName
-(NSString *) getData{
    
    NSString *strUserData=@"";
    
    if ([userDetailsImageArray valueForKey:@"first_name"] != NULL && ![[userDetailsImageArray valueForKey:@"first_name"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@ %@",strUserData,[userDetailsImageArray valueForKey:@"first_name"]];
    }
    if ([userDetailsImageArray valueForKey:@"last_name"] != NULL && ![[userDetailsImageArray valueForKey:@"last_name"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@ %@",strUserData,[userDetailsImageArray valueForKey:@"last_name"]];
    }
    if ([userDetailsImageArray valueForKey:@"age"] != NULL && ![[userDetailsImageArray valueForKey:@"age"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@, %@",strUserData,[userDetailsImageArray valueForKey:@"age"]];
    }
    return strUserData;
    
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