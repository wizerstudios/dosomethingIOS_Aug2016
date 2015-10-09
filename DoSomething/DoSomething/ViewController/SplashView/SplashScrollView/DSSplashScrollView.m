//
//  DSSplashScrollView.m
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSSplashScrollView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"


@interface DSSplashScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIPageControl *pager;

@property (nonatomic, assign) BOOL hasSetupConstraints;

@property (nonatomic, weak) NSTimer *scrollTimer;

@property (nonatomic, assign, getter = isScrollTimerPaused) BOOL scrollTimerPaused;

@property (nonatomic, strong) UIView *firstPage;

@property (nonatomic, strong) UIView *secondPage;

@property (nonatomic, strong) UIView *thirdPage;

@property (nonatomic, strong) UIView *fourthPage;

@property (nonatomic,retain) NSLayoutConstraint *pagerConstraint;

@end

@implementation DSSplashScrollView
@synthesize splashDelegate;

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        [self setTranslatesAutoresizingMaskIntoConstraints: NO];
        
        [self setupViews];
        
        
    }
    return self;
}

#pragma mark - Load Automatic Scrolling Between the Splash Screens

- (void) scrollPages: (NSTimer *) timer
{
    CGFloat currentOffset = [[self scrollView] contentOffset].x;
    
    CGFloat pageWidth = CGRectGetWidth([[self scrollView] bounds]);
    
    NSUInteger currentPage = (NSUInteger) (currentOffset / pageWidth);
    
    currentPage++;
    
    currentPage %= 4;
    
    if (currentPage == 0)
    {
        [[self pager] setCurrentPage: 1];
        
        [CATransaction flush];
        
        [NSThread sleepForTimeInterval: .025];
    }
    
    [[self pager] setCurrentPage: (NSInteger) currentPage];
    
    [[self scrollView] setContentOffset: CGPointMake(currentPage * pageWidth, 0) animated: YES];
    
    if (currentPage < 3) {
        
        self.pagerConstraint.constant = 0;
        
        if([[self splashDelegate] respondsToSelector:@selector(setShowAction)])
            [[self splashDelegate] setShowAction];
    }
    else
    {
        
        if ([[self scrollTimer] isValid])
        {
            [[self scrollTimer] invalidate];
            
            [self setScrollTimer: nil];
        }
        
        self.pagerConstraint.constant = 30;
        
        if([[self splashDelegate] respondsToSelector:@selector(setHiddenAction)])
            [[self splashDelegate] setHiddenAction];
    }
    
    [self layoutIfNeeded];
}

#pragma Create the First Three splash Screens

- (UIView *) pageWithImageName: (NSString *) imageName
{
    UIView *pageView = [[UIView alloc] init];
    
    [pageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    UIImage *splashImg = [UIImage imageNamed: imageName];
    
    
    UIImageView *splashImages = [[UIImageView alloc] init];
    
    [splashImages setContentMode: UIViewContentModeScaleAspectFit];
    
    [splashImages setImage: splashImg];
    
    [splashImages setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [splashImages.layer setBorderColor:[UIColor clearColor].CGColor];
    
    [splashImages.layer setBorderWidth:2.0f];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:splashImages
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:splashImages
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0.0f];
    
    [splashImages addConstraint:constraint];
   
    [pageView addSubview: splashImages];
    
 
    NSDictionary *viewsDictionary = @{@"_splashImages" : splashImages};
    
    NSDictionary *metricsDictionary;
    
    if (IS_IPHONE4) {
        
        metricsDictionary = @{@"splashImagesTopMargin":@(0)};
    }
    else if (IS_IPHONE6_Plus)
    {
        metricsDictionary = @{@"splashImagesTopMargin":@(0)};
    }
    else if (IS_IPHONE6)
    {
        metricsDictionary = @{@"splashImagesTopMargin":@(0)};
    }
    else
    {
        metricsDictionary = @{@"splashImagesTopMargin":@(0)};
    }
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[_splashImages]-0-|"
                                                                           options: NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                           metrics: metricsDictionary
                                                                             views: viewsDictionary];
    
    [pageView addConstraints: verticalConstraints];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[_splashImages]-0-|"
                                                                           options: NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                           metrics: metricsDictionary
                                                                             views: viewsDictionary];
     [pageView addConstraints: horizontalConstraints];
    
    
    
    [pageView.layer setBorderColor:[UIColor clearColor].CGColor];
    
    [pageView.layer setBorderWidth:5.0f];
    
    [pageView setBackgroundColor:[UIColor clearColor]];
    
    return pageView;
}


#pragma mark - Load Four Tutorial screens

- (UIView *) firstPage
{
    return [self pageWithImageName: @"Splash1.jpg" ];
}

- (UIView *) secondPage
{
    return [self pageWithImageName: @"Splash2.jpg"];
}

- (UIView *) thirdPage
{
    return [self pageWithImageName:@"splash.png" ];
}
-(UIView *) fourthPage
{
    return [self pageWithImageName:@"Splash1.jpg"];
}


#pragma mark - PAUSE Scrolling

- (void) pauseScrollingTimer
{
    if (![[self scrollTimer] isValid])
        return;
    
    [self setScrollTimerPaused: YES];
    
    [[self scrollTimer] invalidate];
    
    [self setScrollTimer: nil];
}

#pragma mark - RESUME Scrolling

- (void) resumeScrollingTimer
{
    if (![self isScrollTimerPaused])
        return;
    
    NSTimer *scrollTimer = [NSTimer scheduledTimerWithTimeInterval: 5
                                                            target: self
                                                          selector: @selector(scrollPages:)
                                                          userInfo: nil
                                                           repeats: YES];
    
    [scrollTimer setTolerance: 1];
    
    [self setScrollTimer: scrollTimer];
    
    [self setScrollTimerPaused: NO];
}

#pragma mark - Page Control Change Action

- (void) pagerDidChangeValue
{
    if ([[self scrollTimer] isValid])
    {
        [self setScrollTimerPaused: NO];
        
        [[self scrollTimer] invalidate];
        
        [self setScrollTimer: nil];
    }
    
    NSUInteger newPage = (NSUInteger) [[self pager] currentPage];
    
    CGFloat newOffset = newPage * CGRectGetWidth([[self scrollView] bounds]);
    
    if (newOffset == [[self scrollView] contentOffset].x)
        return;
    
    [[self scrollView] setContentOffset: CGPointMake(newOffset, 0) animated: YES];
}

#pragma mark - Set Views

- (void) setupViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    [scrollView setShowsHorizontalScrollIndicator: NO];
    
    [scrollView setPagingEnabled: YES];
    
    [scrollView setDelegate: self];
    
    [scrollView setClipsToBounds: NO];
    
    [scrollView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    UIView *firstPage = [self firstPage];
    
    UIView *secondPage = [self secondPage];
    
    UIView *thirdPage = [self thirdPage];
    
    UIView *fourthPage = [self fourthPage];
    
    [scrollView addSubview: firstPage];
    
    [scrollView addSubview: secondPage];
    
    [scrollView addSubview: thirdPage];
    
    [scrollView addSubview: fourthPage];
    
    [scrollView.layer setBorderColor:[UIColor clearColor].CGColor];
    
    [scrollView.layer setBorderWidth:2.0f];
    
    [scrollView setBackgroundColor:[UIColor clearColor]];
    
    
    
    NSDictionary *scrollViewViews = @{@"_firstPage" : firstPage,
                                      @"_secondPage" : secondPage,
                                      @"_thirdPage" : thirdPage,
                                      @"_fourthPage" : fourthPage,
                                      @"scrollView" : scrollView};
    
    NSDictionary *metricsDictionary = nil;
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[_firstPage(==scrollView)][_secondPage(==scrollView)][_thirdPage(==scrollView)][_fourthPage(==scrollView)]|"
                                                                             options: NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                             metrics: metricsDictionary
                                                                               views: scrollViewViews];
    
    [scrollView addConstraints: horizontalConstraints];
    
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[_firstPage]|"
                                                                           options: 0
                                                                           metrics: metricsDictionary
                                                                             views: scrollViewViews];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:firstPage
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:secondPage
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:thirdPage
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:fourthPage
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    
    [scrollView addConstraints: verticalConstraints];
    
    
    UIPageControl *pager = [[UIPageControl alloc] init];
    
    [pager setNumberOfPages: 4];
    
    [pager addTarget: self action: @selector(pagerDidChangeValue) forControlEvents: UIControlEventValueChanged];
    
    [pager setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self addSubview: scrollView];
    
    [self addSubview: pager];
    
    [self setScrollView: scrollView];
    
    [self setPager: pager];
    
    [self setFirstPage: firstPage];
    
    [self setSecondPage: secondPage];
    
    [self setThirdPage: thirdPage];
    
    [self setFourthPage:fourthPage];
}

#pragma mark - Set Constraints scroll view and Page Controller

- (void) setupConstraints
{
    NSDictionary *viewsDictionary = @{@"_scrollView" : [self scrollView],
                                      @"_pager" : [self pager]};
    
    NSDictionary *metricsDictionary = nil;
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[_scrollView]|"
                                                                             options: 0
                                                                             metrics: metricsDictionary
                                                                               views: viewsDictionary];
    
    [self addConstraints: horizontalConstraints];
    
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[_scrollView]|"
                                                                           options: 0
                                                                           metrics: metricsDictionary
                                                                             views: viewsDictionary];
    
    [self addConstraints: verticalConstraints];
    
    
    NSArray *pagerHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[_pager]|"
                                                                                  options: 0
                                                                                  metrics: metricsDictionary
                                                                                    views: viewsDictionary];
    
    [self addConstraints: pagerHorizontalConstraints];
    
    self.pagerConstraint = [NSLayoutConstraint constraintWithItem:self.pager
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.scrollView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0];
    
    [self addConstraint:self.pagerConstraint];
}

#pragma mark - UpdateConstraints

- (void) updateConstraints
{
    if (![self hasSetupConstraints])
    {
        [self setupConstraints];
        
        [self setHasSetupConstraints: YES];
    }
    [super updateConstraints];
}

#pragma mark - UIScrollView Delegates

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
    if (![scrollView isDragging])
        return;
    
    if ([[self scrollTimer] isValid])
    {
        [[self scrollTimer] invalidate];
        
        [self setScrollTimer: nil];
    }
    
    CGFloat pageWidth = CGRectGetWidth([scrollView bounds]);
    
    CGFloat offset = [scrollView contentOffset].x;
    
    NSUInteger currentPage = (NSUInteger) round((offset/pageWidth));
    
    [[self pager] setCurrentPage: currentPage];
    
    if (currentPage < 4) {
        
        self.pagerConstraint.constant = 0;
        
        if([[self splashDelegate] respondsToSelector:@selector(setShowAction)])
            [[self splashDelegate] setShowAction];
    }
    else
    {
        
        if ([[self scrollTimer] isValid])
        {
            [[self scrollTimer] invalidate];
            
            [self setScrollTimer: nil];
        }
        
        self.pagerConstraint.constant = 0;//(40)
        
        if([[self splashDelegate] respondsToSelector:@selector(setHiddenAction)])
            [[self splashDelegate] setHiddenAction];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - UIButton Actions

//- (void)compteBtnAction:(id)sender
//{
//    if([[self splashDelegate] respondsToSelector:@selector(showConnexionView)])
//        [[self splashDelegate] showInscriptionView];
//}
//
//- (void)connexionBtnAction:(id)sender
//{
//    if([[self splashDelegate] respondsToSelector:@selector(showConnexionView)])
//        [[self splashDelegate] showConnexionView];
//}


@end
