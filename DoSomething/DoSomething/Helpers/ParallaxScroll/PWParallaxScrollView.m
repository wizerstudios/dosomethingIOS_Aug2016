//
//  PWParallaxScrollView.m
//  PWParallaxScrollView
//
//  Created by wpsteak on 13/6/16.
//  Copyright (c) 2013年 wpsteak. All rights reserved.
//

#import "PWParallaxScrollView.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

static const NSInteger PWInvalidPosition = -1;

@interface PWParallaxScrollView () <UIScrollViewDelegate,CLLocationManagerDelegate>
{
    int pageFrame;
    
    NSInteger lastindex;
    CLLocationManager * locationManager;
    BOOL islocationManagerEnable;
}

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger backgroundViewIndex;
@property (nonatomic, assign) NSInteger userHoldingDownIndex;

@property (nonatomic, strong) UIScrollView *touchScrollView;
@property (nonatomic, strong) UIScrollView *foregroundScrollView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;

@property (nonatomic, strong) UIButton *tutorialpageOkButton;

@property (nonatomic, strong) UIView *currentBottomView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic,strong) DSProfileTableViewController *objSplash;

- (void)touchScrollViewTapped:(id)sender;

@end

@implementation PWParallaxScrollView

@synthesize isdifferSpeed,tutorialpageOkButton;

#pragma mark

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initControl];
      
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }
    return self;
}

- (void)setDataSource:(id<PWParallaxScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setForegroundScreenEdgeInsets:(UIEdgeInsets)foregroundScrollViewEdgeInsets
{
    _foregroundScreenEdgeInsets = foregroundScrollViewEdgeInsets;
    [_foregroundScrollView setFrame:UIEdgeInsetsInsetRect(self.bounds, _foregroundScreenEdgeInsets)];
}

- (void)initControl
{
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    
    pageFrame = 1;
    
    self.touchScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _touchScrollView.delegate = self;
    _touchScrollView.pagingEnabled = YES;
    _touchScrollView.bounces = NO;
    _touchScrollView.backgroundColor = [UIColor clearColor];
    _touchScrollView.contentOffset = CGPointMake(0, 0);
    _touchScrollView.multipleTouchEnabled = YES;
    [_touchScrollView setShowsHorizontalScrollIndicator:NO];
    [_touchScrollView setShowsVerticalScrollIndicator:NO];
    _touchScrollView.bounces = NO;
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollViewTapped:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_touchScrollView addGestureRecognizer:tapGestureRecognize];
    
    self.foregroundScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //_foregroundScrollView.scrollEnabled = NO;
    _foregroundScrollView.clipsToBounds = NO;
    _foregroundScrollView.backgroundColor = [UIColor clearColor];
    _foregroundScrollView.contentOffset = CGPointMake(0, 0);
    [_foregroundScrollView setShowsHorizontalScrollIndicator:NO];
    [_foregroundScrollView setShowsVerticalScrollIndicator:NO];
    _foregroundScrollView.bounces = NO;
    
    self.backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //_backgroundScrollView.pagingEnabled = NO;
    _backgroundScrollView.backgroundColor = [UIColor clearColor];
    _backgroundScrollView.contentOffset = CGPointMake(0, 0);
    [_backgroundScrollView setShowsHorizontalScrollIndicator:NO];
    [_backgroundScrollView setShowsVerticalScrollIndicator:NO];
    _backgroundScrollView.bounces = NO;
    
    
//    UIImageView * bgImage =[[UIImageView alloc]initWithFrame:self.bounds];
//    bgImage.image=[UIImage imageNamed:@"profile_noimg"];
    
    
    tutorialpageOkButton=[[UIButton alloc]initWithFrame:CGRectMake(88,40,125,125)];
    
    [tutorialpageOkButton setTitle:@"OK" forState:UIControlStateNormal];
    
    [tutorialpageOkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    tutorialpageOkButton.titleLabel.font = [UIFont systemFontOfSize:10];
    
    //[tutorialpageOkButton setBackgroundColor:[UIColor colorWithRed:93.0/255 green:102.0/255 blue:122.0/255 alpha:1.0f]];
    
    //[[tutorialpageOkButton layer] setBorderWidth:1.3f];
    
    //[tutorialpageOkButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    tutorialpageOkButton.layer.cornerRadius = 7; // this value vary as per your desire
    
    tutorialpageOkButton.clipsToBounds = YES;
    
    UIImage *btnImage = [UIImage imageNamed:@"profile_noimg"];
    [tutorialpageOkButton setImage:btnImage forState:UIControlStateNormal];
    [tutorialpageOkButton addTarget:self action:@selector(didClickOkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    

     //[self addSubview:bgImage];
    [self addSubview:_backgroundScrollView];
    [self addSubview:_foregroundScrollView];
    [self addSubview:_touchScrollView];
    [self addSubview:tutorialpageOkButton];
   
}

#pragma mark - public method

- (void)moveToIndex:(NSInteger)index
{
    CGFloat newOffsetX = index * CGRectGetWidth(_touchScrollView.frame);
    [_touchScrollView scrollRectToVisible:CGRectMake(newOffsetX, 0, CGRectGetWidth(_touchScrollView.frame), CGRectGetHeight(_touchScrollView.frame)) animated:YES];
}

- (void)prevItem
{
    if (self.currentIndex > 0) {
        [self moveToIndex:self.currentIndex - 1];
    }
}

- (void)nextItem
{
    if (self.currentIndex < _numberOfItems - 1) {
        [self moveToIndex:self.currentIndex + 1];
    }
}

- (void)reloadData
{
    self.backgroundViewIndex = 0;
    self.userHoldingDownIndex = 0;
    self.numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) * _numberOfItems, CGRectGetHeight(self.frame))];
    contentView.backgroundColor = [UIColor clearColor];
    
    [_backgroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_backgroundScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_backgroundScrollView addSubview:contentView];
    [_backgroundScrollView setContentSize:contentView.frame.size];
    
    [_foregroundScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_foregroundScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_foregroundScrollView setContentSize:CGSizeMake(CGRectGetWidth(_foregroundScrollView.frame) * _numberOfItems, CGRectGetHeight(_foregroundScrollView.frame))];
    
    [_touchScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_touchScrollView setContentSize:contentView.frame.size];
    
    [self loadBackgroundViewAtIndex:0];
    
    for (NSInteger i = 0; i < _numberOfItems; i++) {
        [self loadForegroundViewAtIndex:i];
    }
}

#pragma mark - private method
- (void)touchScrollViewTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(parallaxScrollView:didRecieveTapAtIndex:)])
    {
        [self.delegate parallaxScrollView:self didRecieveTapAtIndex:self.currentIndex];
    }
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _numberOfItems) {
        return nil;
    }
    
    if (![self.dataSource respondsToSelector:@selector(foregroundViewAtIndex:scrollView:)]) {
        return nil;
    }
    
    UIView *view = [self.dataSource foregroundViewAtIndex:index scrollView:self];
    
    CGRect newFrame = view.frame;
    newFrame.origin.x += index * CGRectGetWidth(_foregroundScrollView.frame);
    if (isdifferSpeed) {
        if (newFrame.origin.x >= _foregroundScrollView.frame.size.width) {
            newFrame.origin.x = newFrame.origin.x + (_foregroundScrollView.frame.size.width * pageFrame);
            pageFrame++;
        }
    }
    
    [view setFrame:newFrame];
    [view setTag:index];
    
    
    return view;
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _numberOfItems) {
        return nil;
    }
    
    UIView *view = [self.dataSource backgroundViewAtIndex:index scrollView:self];
    [view setFrame:CGRectMake(index * CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [view setTag:index];
    
    
    return view;
}

- (void)loadForegroundViewAtIndex:(NSInteger)index
{
    UIView *newParallaxView = [self foregroundViewAtIndex:index];
    UIButton * ok_btn=[[UIButton alloc]initWithFrame:CGRectMake(200,50,35,40)];
    [ok_btn setTitle:@"OK" forState:UIControlStateNormal];
   // [_foregroundScrollView addSubview:ok_btn];
    
    [_foregroundScrollView addSubview:newParallaxView];
}

- (void)loadBackgroundViewAtIndex:(NSInteger)index
{
    [[_backgroundScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *newTopView = [self backgroundViewAtIndex:index];
    

   [_backgroundScrollView addSubview:newTopView];
}

- (void)determineBackgroundView:(float)offsetX
{
    CGFloat newCenterX = 0;
    NSInteger newBackgroundViewIndex = 0;
    NSInteger midPoint = CGRectGetWidth(self.frame) * _userHoldingDownIndex;
    
    if (offsetX < midPoint) {
        //moving from left to right
        
        newCenterX = (CGRectGetWidth(self.frame) * _userHoldingDownIndex - offsetX) / 2;
        newBackgroundViewIndex = _userHoldingDownIndex - 1;
    }
    else if (offsetX > midPoint) {
        //moving from right to left
        
        CGFloat leftSplitWidth = CGRectGetWidth(self.frame) * (_userHoldingDownIndex + 1) - offsetX;
        CGFloat rightSplitWidth = CGRectGetWidth(self.frame) - leftSplitWidth;
        
        newCenterX = rightSplitWidth / 2 + leftSplitWidth;
        newBackgroundViewIndex = _userHoldingDownIndex + 1;
    }
    else {
        newCenterX = CGRectGetWidth(self.frame) / 2 ;
        newBackgroundViewIndex = _backgroundViewIndex;
    }
    
    BOOL backgroundViewIndexChanged = (newBackgroundViewIndex == _backgroundViewIndex) ? NO : YES;
    self.backgroundViewIndex = newBackgroundViewIndex;
    
    if (_userHoldingDownIndex >= 0 && _userHoldingDownIndex <= _numberOfItems) {
        if (backgroundViewIndexChanged) {
            [_currentBottomView removeFromSuperview];
            self.currentBottomView = nil;
            
            UIView *newBottomView = [self backgroundViewAtIndex:_backgroundViewIndex];
            self.currentBottomView = newBottomView;
            [self insertSubview:self.currentBottomView atIndex:0];
        }
    }
    
    CGPoint center = CGPointMake(newCenterX, CGRectGetHeight(self.frame) / 2);
    self.currentBottomView.center = center;
}

- (NSInteger)backgroundViewIndexFromOffset:(CGPoint)offset
{
    NSInteger index = (offset.x / CGRectGetWidth(self.frame));
    
    if (index >= _numberOfItems || index < 0) {
        index = PWInvalidPosition;
    }
    
    return index;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_backgroundScrollView setContentOffset:scrollView.contentOffset];
    
    CGFloat factor = _foregroundScrollView.contentSize.width / scrollView.contentSize.width;
    if (isdifferSpeed)
        [_foregroundScrollView setContentOffset:CGPointMake(factor * scrollView.contentOffset.x * 2, 0)];
    else
        [_foregroundScrollView setContentOffset:CGPointMake(factor * scrollView.contentOffset.x, 0)];
    
    CGFloat offsetX = scrollView.contentOffset.x;
    [self determineBackgroundView:offsetX];
    
    CGRect visibleRect;
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
    
    CGRect userPenRect;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    userPenRect.origin = CGPointMake(width * self.userHoldingDownIndex, 0);
    userPenRect.size = scrollView.bounds.size;
    
    if (!CGRectIntersectsRect(visibleRect, userPenRect)) {
        if (CGRectGetMinX(visibleRect) - CGRectGetMinX(userPenRect) > 0) {
            self.userHoldingDownIndex = _userHoldingDownIndex + 1;
        }
        else {
            self.userHoldingDownIndex = _userHoldingDownIndex - 1;
        }
        
        [self loadBackgroundViewAtIndex:_userHoldingDownIndex];
    }
    
    CGFloat newCrrentIndex = round(1.0f * scrollView.contentOffset.x / CGRectGetWidth(self.frame));
    
    if(_currentIndex != newCrrentIndex) {
        self.currentIndex = newCrrentIndex;
        
        if([self.delegate respondsToSelector:@selector(parallaxScrollView:didChangeIndex:)]){
            [self.delegate parallaxScrollView:self didChangeIndex:self.currentIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(parallaxScrollView:didEndDeceleratingAtIndex:)]){
        [self.delegate parallaxScrollView:self didEndDeceleratingAtIndex:self.currentIndex];
    }
}

#pragma mark hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in _foregroundScrollView.subviews) {
        CGPoint convertedPoint = [self convertPoint:point toView:subview];
        UIView *result = [subview hitTest:convertedPoint withEvent:event];
        
        if ([result isKindOfClass:[UIButton class]]){
            return result;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)didscrollIndex:(NSInteger)index
{
    
    CGFloat newOffsetX = index * CGRectGetWidth(_touchScrollView.frame);
    [_touchScrollView scrollRectToVisible:CGRectMake(newOffsetX, 0, CGRectGetWidth(_touchScrollView.frame), CGRectGetHeight(_touchScrollView.frame)) animated:YES];
    
}

-(IBAction)didClickOkButtonAction:(id)sender
{
    lastindex=self.currentIndex;
    if(lastindex==3)
    {
         if([CLLocationManager locationServicesEnabled])
         {
             [self locationmanagerMethod];
         }
        else
        {
            UIAlertView * geoalterview=[[UIAlertView alloc]initWithTitle:@"Geolocalisation" message:@"Chronoscènes vous propose tous les spectacles qui ont lieu autour de vous en fonction de votre position. Veuillez activer la géolocalisation dans vos paramètres > confidentialité > service de localisation > Chronoscènes afin de pouvoir utiliser l'application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [geoalterview show];
 
        }
        
    }
    else
    {
    [self didscrollIndex:3];
        [self reloadData];
    }
}

-(void)locationmanagerMethod
{
    if(islocationManagerEnable == YES)
    {

        islocationManagerEnable = YES;
      
    }
    else

    {
        if(!locationManager){
            
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            
            locationManager.distanceFilter  = kCLLocationAccuracyKilometer;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
         // locationManager.activityType    = CLActivityTypeAutomotiveNavigation;
             islocationManagerEnable = NO;
        }
        else{
            
        }
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            
            [locationManager requestAlwaysAuthorization];
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            
            [locationManager requestWhenInUseAuthorization];
        
        [locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
     if([CLLocationManager locationServicesEnabled]){
          NSLog(@"Location Services Enabled");
          [self.delegate didAllowgeolocation:YES];
          // [(AppDelegate *)[[UIApplication sharedApplication] delegate]loadmainview:nil];
     }
    else
    {
       
    }

   
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView * geoalterview=[[UIAlertView alloc]initWithTitle:@"Geolocalisation" message:@"Chronoscènes vous propose tous les spectacles qui ont lieu autour de vous en fonction de votre position. Veuillez activer la géolocalisation dans vos paramètres > confidentialité > service de localisation > Chronoscènes afin de pouvoir utiliser l'application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [geoalterview show];
        }
        else
        {
           // [(AppDelegate *)[[UIApplication sharedApplication] delegate]loadmainview:nil];

        }

        
            }
    
    else{
        UIAlertView * geoalterview=[[UIAlertView alloc]initWithTitle:@"Geolocalisation" message:@"Chronoscènes vous propose tous les spectacles qui ont lieu autour de vous en fonction de votre position. Veuillez activer la géolocalisation dans vos paramètres > confidentialité > service de localisation > Chronoscènes afin de pouvoir utiliser l'application." delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Autoriser", nil];
        [geoalterview show];
     
        }
 
    
        NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
    }
    
    
    [manager stopUpdatingLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
    else if (buttonIndex==1)
    {
        if([CLLocationManager locationServicesEnabled])
        {
                CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            
                if (status == kCLAuthorizationStatusNotDetermined)
                {
            
                }
                else{
                    //[(AppDelegate *)[[UIApplication sharedApplication] delegate]loadmainview:nil];
                }
        }
        else
        {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}
@end
