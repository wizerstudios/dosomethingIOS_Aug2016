//
//  ChatTableViewCell.m
//  ChatView
//
//  Created by OCSDEV2 on 13/10/15.
//  Copyright (c) 2015 Appsolute. All rights reserved.
//

#import "ChatTableViewCell.h"


@implementation ChatTableViewCell
@synthesize ChatImage,ChatName,Message,Time,profileImageView;
- (void)awakeFromNib
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width /4;
    self.profileImageView.layer.borderWidth = 0.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   [super setSelected:selected animated:animated];
}
@end
