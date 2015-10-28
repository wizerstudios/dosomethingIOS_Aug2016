//
//  HomeCustomCell.m
//  DoSomething
//
//  Created by ocsdev4 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "HomeCustomCell.h"

@implementation HomeCustomCell

@synthesize MenuTittle, MenuImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomeCustomCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
    
}



@end
