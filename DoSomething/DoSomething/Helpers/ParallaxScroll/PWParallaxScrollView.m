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
#import "DSAppCommon.h"
#define enlargeRatio 1.1



typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

static const NSInteger PWInvalidPosition = -1;

@interface PWParallaxScrollView () <UIScrollViewDelegate,CLLocationManagerDelegate,KenBurnsViewDelegate>
{
    int pageFrame;
    
    NSMutableArray * bannerText;
     NSMutableArray *FGimageArray;
    NSArray * pageController;
    UIImageView*pageImageView;
    //NSTimer *nextImageTimer;
    bool is_scroll;
     NSString * scrolldirectionstr;
}

@property (nonatomic, assign) BOOL isLandscape;
@property (nonatomic, assign) BOOL shouldLoop;
@property (nonatomic, assign) CGFloat showImageDuration;
@property (nonatomic, strong) NSTimer *nextImageTimer;

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger backgroundViewIndex;
@property (nonatomic, assign) NSInteger userHoldingDownIndex;

@property (nonatomic, strong) UIScrollView *touchScrollView;

@property (nonatomic, strong) UIScrollView *foregroundScrollView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;

@property (strong, nonatomic) JBKenBurnsView *kenView;

@property (nonatomic, strong) UIButton *tutorialpageOkButton;

@property (nonatomic, strong) UIView *currentBottomView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,strong)  UIPageControl *pageControllBtn;

//@property (nonatomic,strong) DSProfileTableViewController *objSplash;

@property (nonatomic, assign) CGFloat lastContentOffset;
- (void)touchScrollViewTapped:(id)sender;

@end

@implementation PWParallaxScrollView

@synthesize isdifferSpeed,tutorialpageOkButton,pageControllBtn,nextImageTimer;

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
//    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouch:)];
//    [longTap setNumberOfTapsRequired:0]; // Set your own number here
//    [longTap setMinimumPressDuration:0.3];
//    [tapGestureRecognize requireGestureRecognizerToFail:longTap];
    
    [_touchScrollView addGestureRecognizer:tapGestureRecognize];
    //[_touchScrollView addGestureRecognizer:longTap];
    

   
    
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
    
    FGimageArray = [[NSMutableArray alloc] initWithObjects:@"splash_bg",@"bg1",@"bg2",@"bg3",@"bg4",nil];
    
    bannerText=[[NSMutableArray alloc] initWithObjects:@"bgText5",@"bgText1",@"bgText2",@"bgText3",@"bgText4", nil];
    
    pageControllBtn = [[UIPageControl alloc]init];
    
    pageControllBtn.backgroundColor = [UIColor clearColor];
    [pageControllBtn setFrame:CGRectMake(self.center.x-50,self.frame.size.height-100,120,40)];
    pageControllBtn.numberOfPages = 5;
    pageControllBtn.currentPage = _currentIndex;
    
    pageControllBtn.pageIndicatorTintColor = [UIColor whiteColor];
    
    pageControllBtn.currentPageIndicatorTintColor =[UIColor clearColor];
    
    
    [pageControllBtn setCurrentPage:_currentIndex];
    
   
    
    pageImageView =[[UIImageView alloc]init];
   
    
    [self addSubview:_foregroundScrollView];
    [self addSubview:_touchScrollView];
    
    [self addSubview:pageControllBtn];
    [self nextImage:_currentIndex];
    nextImageTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [nextImageTimer fire];

    
    
   
}
-(void)nextImage
{
    if (self.currentIndex == 0) {
       
         [self nextImage:_currentIndex+1];
    }
    else if (self.currentIndex==4)
    {
        _currentIndex=0;
         [self nextImage:_currentIndex];
    }
    else
    {
         _currentIndex ++;
         [self nextImage:_currentIndex];
    }
    
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
- (void) longTouch: (UILongPressGestureRecognizer *)recognizer
{
    
        [self parallaxScrollView:self didRecieveTapAtIndex:self.currentIndex direction:scrolldirectionstr];
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        for(UIView * view in _touchScrollView.subviews)
        {
            if(view.tag == 1600)
            {
                //  [UIView animateWithDuration:0.1 animations:^{
                [view removeFromSuperview];
                // }];
                
            }
        }

       
    }

}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
- (void)parallaxScrollView:(PWParallaxScrollView *)scrollView didRecieveTapAtIndex:(NSInteger)index direction:(NSString *) ScrollDirection
{
    UIView* shadeView = [[UIView alloc]initWithFrame:self.frame];
    shadeView.backgroundColor = [UIColor lightGrayColor];
    shadeView.alpha = .4;
    shadeView.tag=1600;
    _isLandscape=YES;
    
    UIImage *image;
    
    
    if([ScrollDirection isEqualToString:@"ScrollDirectionLeft"]&& index < 4)
    {
        index =index+1;
    }
    else if ([ScrollDirection isEqualToString:@"ScrollDirectionRight"] && index < 0)
    {
        index =index-1;
    }
    
    image =[UIImage imageNamed:FGimageArray[index]];
    
    
    
    UIImageView *imageView = nil;
    UIImageView    * textImageview   =nil;
    
    
    float originX       = -1;
    float originY       = -1;
//    float zoomInX       = -1;
//    float zoomInY       = -1;
//    float moveX         = -1;
//    float moveY         = -1;
    
    float frameWidth    = _isLandscape ? self.bounds.size.width: self.bounds.size.height;
    float frameHeight   = _isLandscape ? self.bounds.size.height: self.bounds.size.width;
    
    float resizeRatio = [self getResizeRatioFromImage:image width:frameWidth height:frameHeight];
    
    // Resize the image.
    float optimusWidth  = (image.size.width * resizeRatio) * enlargeRatio;
    float optimusHeight = (image.size.height * resizeRatio) * enlargeRatio;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,518)];
    imageView.tag=1600;
    
    
    if(index == 0)
    {
        textImageview  =[[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-60,self.center.y-80,145,63)];
    }
    else{
        textImageview  =[[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-100,self.center.y-60,227,67)];
    }
    textImageview.image =[UIImage imageNamed:bannerText[index]];
    [textImageview setBackgroundColor:[UIColor clearColor]];
    textImageview.tag=1600;
    
    
    imageView.backgroundColor = [UIColor greenColor];
    
    
    
    
    CALayer *picLayer    = [CALayer layer];
    picLayer.contents    = (id)image.CGImage;
    picLayer.anchorPoint = CGPointMake(0, 0);
    picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
    picLayer.position    = CGPointMake(originX, originY);
    
    [imageView.layer addSublayer:picLayer];
    
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:1];
    [animation setType:kCATransitionFade];
    // [[self layer] addAnimation:animation forKey:nil];
    
    [shadeView addSubview:imageView];
    // [shadeView addSubview:textImageview];
    [_touchScrollView addSubview:shadeView ];
    [self bringSubviewToFront:_touchScrollView];

}

- (void)touchScrollViewTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(parallaxScrollView:didRecieveTapAtIndex:)])
    {
        [self.delegate parallaxScrollView:self didRecieveTapAtIndex:self.currentIndex];
    }
}

-(void)touchScrollViewTappedswipe:(UISwipeGestureRecognizer*)gesture
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
       
        float pagecontrolxposition;
        pagecontrolxposition =self.currentIndex+22;
        pageControllBtn.currentPageIndicatorTintColor=[UIColor clearColor];
        
        [pageControllBtn setCurrentPage:_currentIndex];
        
        
        if(self.currentIndex==0)
        {
            [pageImageView setFrame:CGRectMake(pagecontrolxposition+self.currentIndex*15,13,14,14)];
            pageImageView.image =[UIImage imageNamed:@"Whitdot_active"];
        }
        else
        {
            [pageImageView setFrame:CGRectMake(pagecontrolxposition+self.currentIndex*15,13,14,14)];
            pageImageView.image =[UIImage imageNamed:@"Whitdot_active"];
        }
        [pageImageView setBackgroundColor:[UIColor clearColor]];
        [self nextImage:self.currentIndex];
        if([self.delegate respondsToSelector:@selector(parallaxScrollView:didChangeIndex:direction:)]){
//            [self.layer removeAllAnimations];
//
//            ScrollDirection scrollDirection;
//           
//            if (self.lastContentOffset > scrollView.contentOffset.x)
//            {
//                scrollDirection = ScrollDirectionRight;
//                scrolldirectionstr=@"ScrollDirectionRight";
//               
//            }
//            else if (self.lastContentOffset < scrollView.contentOffset.x)
//            {
//                scrollDirection = ScrollDirectionLeft;
//                scrolldirectionstr=@"ScrollDirectionLeft";
//            }
//            self.lastContentOffset = scrollView.contentOffset.x;
            [self.delegate parallaxScrollView:self didChangeIndex:self.currentIndex direction:scrolldirectionstr];
           
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(parallaxScrollView:didEndDeceleratingAtIndex:)]){
        [self.delegate parallaxScrollView:self didEndDeceleratingAtIndex:self.currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if([self.delegate respondsToSelector:@selector(parallaxScrollView:didChangeIndex:direction:)]){
//        [self.layer removeAllAnimations];
//        
//        ScrollDirection scrollDirection;
//        
//        if (self.lastContentOffset > scrollView.contentOffset.x)
//        {
//            scrollDirection = ScrollDirectionRight;
//            scrolldirectionstr=@"ScrollDirectionRight";
//            
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.x)
//        {
//            scrollDirection = ScrollDirectionLeft;
//            scrolldirectionstr=@"ScrollDirectionLeft";
//        }
//        self.lastContentOffset = scrollView.contentOffset.x;
//        [self.delegate parallaxScrollView:self didChangeIndex:self.currentIndex direction:scrolldirectionstr];
//        
//    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate){
        if([self.delegate respondsToSelector:@selector(parallaxScrollView:didEndDeceleratingAtIndex:)]){
            [self.delegate parallaxScrollView:self didEndDeceleratingAtIndex:self.currentIndex];
        }
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

#pragma  animation

- (void)nextImage:(NSInteger)index
{
    _isLandscape=YES;
    _shouldLoop =YES;
    UIImage *image;
    _currentIndex =index;
    
    image =[UIImage imageNamed:FGimageArray[index]];
    
    
    
    UIImageView *imageView = nil;
    UIImageView    * textImageview   =nil;
    UIPageControl * pageControll =nil;
    
    float originX       = -1;
    float originY       = -1;
    float zoomInX       = -1;
    float zoomInY       = -1;
    float moveX         = -1;
    float moveY         = -1;
    
    float frameWidth    = _isLandscape ? self.bounds.size.width: self.bounds.size.height;
    float frameHeight   = _isLandscape ? self.bounds.size.height: self.bounds.size.width;
    
    float resizeRatio = [self getResizeRatioFromImage:image width:frameWidth height:frameHeight];
    
    // Resize the image.
    float optimusWidth  = (image.size.width * resizeRatio) * enlargeRatio;
    float optimusHeight = (image.size.height * resizeRatio) * enlargeRatio;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,518)];
   
    if(_currentIndex == 0)
    {
        textImageview  =[[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-60,self.center.y-80,145,63)];
    }
    else{
        textImageview  =[[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-100,self.center.y-60,227,67)];
    }
    textImageview.image =[UIImage imageNamed:bannerText[index]];
    [textImageview setBackgroundColor:[UIColor clearColor]];
    pageControll = [[UIPageControl alloc]init];
    
    pageControll.backgroundColor = [UIColor whiteColor];
    [pageControll setFrame:CGRectMake(self.center.x-50,self.frame.size.height-80,120,40)];
    pageControll.numberOfPages = 5;
    pageControll.currentPage = _currentIndex;
    
    
    float pagecontrolxposition;
    pagecontrolxposition =_currentIndex+22;
    pageControllBtn.pageIndicatorTintColor = [UIColor whiteColor];
    
    pageControllBtn.currentPageIndicatorTintColor =[UIColor clearColor];
    
    
    [pageControllBtn setCurrentPage:_currentIndex];
    
    // UIImageView*pageImageView =[[UIImageView alloc]init];
    if(pageControllBtn.currentPage)
    {
        [pageImageView setFrame:CGRectMake(pagecontrolxposition+_currentIndex*15,13,14,14)];
        pageImageView.image =[UIImage imageNamed:@"Whitdot_active"];
    }
    else
    {
        [pageImageView setFrame:CGRectMake(_currentIndex+22,13,14,14)];
        pageImageView.image =[UIImage imageNamed:@"Whitdot_active"];
    }
    [pageImageView setBackgroundColor:[UIColor clearColor]];
    [pageControllBtn addSubview:pageImageView];
    
    
    imageView.backgroundColor = [UIColor greenColor];
    
    
    // Calcule the maximum move allowed.
    float maxMoveX = optimusWidth - frameWidth;
    float maxMoveY = optimusHeight - frameHeight;
    
    float rotation = (arc4random() % 9) / 100;
    
    switch (arc4random() % 4) {
        case 0:
            originX = 0;
            originY = 0;
            zoomInX = 1.25;
            zoomInY = 1.25;
            moveX   = -maxMoveX;
            moveY   = -maxMoveY;
            break;
            
        case 1:
            originX = 0;
            originY = frameHeight - optimusHeight;
            zoomInX = 1.10;
            zoomInY = 1.10;
            moveX   = -maxMoveX;
            moveY   = maxMoveY;
            break;
            
        case 2:
            originX = frameWidth - optimusWidth;
            originY = 0;
            zoomInX = 1.30;
            zoomInY = 1.30;
            moveX   = maxMoveX;
            moveY   = -maxMoveY;
            break;
            
        case 3:
            originX = frameWidth - optimusWidth;
            originY = frameHeight - optimusHeight;
            zoomInX = 1.20;
            zoomInY = 1.20;
            moveX   = maxMoveX;
            moveY   = maxMoveY;
            break;
            
        default:
            NSLog(@"Unknown random number found in JBKenBurnsView _animate");
            break;
    }
    
    
    CALayer *picLayer    = [CALayer layer];
    picLayer.contents    = (id)image.CGImage;
    picLayer.anchorPoint = CGPointMake(0, 0);
    picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
    picLayer.position    = CGPointMake(originX, originY);
    
    [imageView.layer addSublayer:picLayer];
    
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:1];
    [animation setType:kCATransitionFade];
    // [[self layer] addAnimation:animation forKey:nil];
   
    
    
    [self addSubview:imageView];
    [self addSubview:textImageview];
    [self addSubview:pageControllBtn];
   


    // Generates the animation  //before: UIViewAnimationCurveEaseInOut
        [UIView animateWithDuration:10.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             CGAffineTransform rotate    = CGAffineTransformMakeRotation(rotation);
             CGAffineTransform moveRight = CGAffineTransformMakeTranslation(moveX, moveY);
             CGAffineTransform combo1    = CGAffineTransformConcat(rotate, moveRight);
             CGAffineTransform zoomIn    = CGAffineTransformMakeScale(zoomInX, zoomInY);
             CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
             imageView.transform = transform;
             
             
         } completion:^(BOOL finished) {
            
         }];
    //}
    
}

- (float)getResizeRatioFromImage:(UIImage *)image width:(float)frameWidth height:(float)frameHeight
{
    float resizeRatio   = -1;
    float widthDiff     = -1;
    float heightDiff    = -1;
    if(IS_IPHONE6_Plus)
    {
        frameHeight=frameHeight-69;
    }
    // Wider than screen
    if (image.size.width > frameWidth)
    {
        widthDiff  = image.size.width - frameWidth;
        
        // Higher than screen
        if (image.size.height > frameHeight)
        {
            heightDiff = image.size.height - frameHeight;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameHeight / image.size.height;
            else
                resizeRatio = frameWidth / image.size.width;
        }
        // No higher than screen
        else
        {
            heightDiff = frameHeight - image.size.height;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameWidth / image.size.width;
            else
                resizeRatio = self.bounds.size.height / image.size.height;
        }
    }
    // No wider than screen
    else
    {
        widthDiff  = frameWidth - image.size.width;
        
        // Higher than screen
        if (image.size.height > frameHeight)
        {
            heightDiff = image.size.height - frameHeight;
            
            if (widthDiff > heightDiff)
                resizeRatio = image.size.height / frameHeight;
            else
                resizeRatio = frameWidth / image.size.width;
        }
        // No higher than screen
        else
        {
            heightDiff = frameHeight - image.size.height;
            
            if (widthDiff > heightDiff)
                resizeRatio = frameWidth / image.size.width;
            else
                resizeRatio = frameHeight / image.size.height;
        }
    }
    
    return resizeRatio;
}




@end
