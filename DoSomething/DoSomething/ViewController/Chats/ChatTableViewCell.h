//
//  ChatTableViewCell.h
//  ChatView
//
//  Created by OCSDEV2 on 13/10/15.
//  Copyright (c) 2015 Appsolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ChatImage;
@property (strong, nonatomic) IBOutlet UILabel *ChatName;
@property (strong, nonatomic) IBOutlet UILabel *Message;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic,strong) IBOutlet UILabel *msgCountLabel;

@end
