//
//  pageControl.m
//  DoSomething
//
//  Created by OCSDEV2 on 14/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "pageControl.h"

@implementation pageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    activeImage = [UIImage imageNamed:@"dot_active"];
    inactiveImage = [UIImage imageNamed:@"dot_Image"];
    
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
