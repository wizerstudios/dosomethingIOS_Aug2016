//
//  ChatTextView.m
//  Social_Events
//
//  Created by Ocsmobi-5 on 18/10/14.
//  Copyright (c) 2014 Social_Events. All rights reserved.
//

#import "ChatTextView.h"

@implementation ChatTextView
@synthesize textView,postButton,delegate,backGroundImageView,placeHolderLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void) awakeFromNib {
   
    [self composeView];
}

- (void) composeView{
    
    backGroundImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height+10)];
    
    backGroundImageView.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    
    [self addSubview:backGroundImageView];
    
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, 260, 40)];
    
//    textView.layer.cornerRadius = 5;
//    
//    textView.layer.borderWidth = 1;
//    
//    textView.layer.borderColor = [UIColor colorWithRed:202.0f/255.0f green:207.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor;
    
    textView.delegate = delegate;
    
    textView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:textView];
    
    
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0, 0.0,textView.frame.size.width - 10.0, 34.0)];
    
    [placeHolderLabel setText:@"Message"];
    
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    
    placeHolderLabel.font= [UIFont systemFontOfSize:14];
    
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    
    [textView addSubview:placeHolderLabel];
    
    
    postButton = [[UIButton alloc]initWithFrame:CGRectMake(270,8, 50, 30)];
    
    postButton.layer.cornerRadius = 6;
    
    postButton.clipsToBounds = YES;
    
    postButton.titleLabel.font= [UIFont systemFontOfSize:14];
    
    [postButton setTitleColor:[UIColor colorWithRed:120.0f/255.0f green:127.0f/255.0f blue:137.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [postButton setTitle:@"Send" forState:UIControlStateNormal];
    
    [self addSubview:postButton];
    
    
}

@end
