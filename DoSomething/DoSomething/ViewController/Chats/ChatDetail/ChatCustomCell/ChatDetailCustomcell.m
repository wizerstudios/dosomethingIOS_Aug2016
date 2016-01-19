//
//  ChatDetailCustomcell.m
//  DoSomething
//
//  Created by Ocs Developer 6 on 12/26/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "ChatDetailCustomcell.h"
#import "DSChatDetailViewController.h"
#import "DSAppCommon.h"

#define CONTENT_WIDTH           200.f
#define CONTENT_START           0.f
#define BUBBLE_IMAGE_HEIGHT     10.f
#define BUBBLE_WIDTH            250.f
#define BUBBLE_WIDTH_SPACE      70.f
#define CELL_HEIGHT             CONTENT_START+15.f
#define ME_RIGHT_WIDTH_SPACE    25.0f


@implementation ChatDetailCustomcell
@synthesize sender_bubbleimgView,sender_msgLbl;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect{
    
    [self loadMessageView];
  
}
-(void)getMessageArray:(NSMutableArray *)msgArray
{
    chatArray=[msgArray mutableCopy];
    sender_bubbleimgView.hidden  = YES;
    [self loadMessageView];
    
}

-(void)loadMessageView{
    if([chatArray count]){
       sender_bubbleimgView.hidden=NO;
       
        if([[chatArray valueForKey:@"type"] isEqualToString:@"SENDER"]){
            
            sender_msgLbl.text=[chatArray valueForKey:@"Message"];
            dataSize = [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)];
            int y_Position=10;
            windowSize = CGSizeMake(320,440);
            sender_msgLbl.numberOfLines = 2000;
            sender_bubbleimgView.image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            sender_bubbleimgView.layer.cornerRadius = 7;
            
            sender_msgLbl.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE) + 10,
                                             y_Position + sender_msgLbl.frame.origin.y + 8,
                                             MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width+10 + BUBBLE_WIDTH_SPACE),
                                             dataSize.height-10);
            [sender_msgLbl setTextColor:[UIColor whiteColor]];
            NSString *timeStr = [chatArray valueForKey:@"senttime"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            
            NSDate *date = [dateFormat dateFromString:timeStr];
            
            [dateFormat setDateFormat:@"hh:mm"];
            
            timeStr = [dateFormat stringFromDate:date];
            
            
            self.chatTime.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+dataSize.width+50,dataSize.height+BUBBLE_IMAGE_HEIGHT-20,40,40);
            
             self.chatTime.text = timeStr;

            
            sender_bubbleimgView.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE),
                                                    y_Position + sender_bubbleimgView.frame.origin.y,
                                                    MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+20,
                                                    dataSize.height+BUBBLE_IMAGE_HEIGHT-10);
            
            
            
        }
        else {
            
            sender_msgLbl.text=[chatArray valueForKey:@"Message"];
            dataSize = [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)];
            int y_Position=10;
            windowSize = CGSizeMake(320,440);
            
            sender_msgLbl.numberOfLines = 2000;
            sender_bubbleimgView.image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            sender_bubbleimgView.backgroundColor = [UIColor whiteColor];
            sender_bubbleimgView.layer.cornerRadius = 7;


            sender_msgLbl.frame = CGRectMake(20 ,
                                             y_Position + sender_msgLbl.frame.origin.y+8,
                                             MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width+10 + BUBBLE_WIDTH_SPACE),
                                             dataSize.height-10);
            [sender_msgLbl setTextColor:[UIColor blackColor]];
            
            sender_bubbleimgView.frame = CGRectMake(10,
                                                    y_Position + sender_bubbleimgView.frame.origin.y,
                                                    MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+y_Position + sender_bubbleimgView.frame.origin.y,
                                                    dataSize.height+BUBBLE_IMAGE_HEIGHT-10);
            
            
            
        }
        
    }
    
}


@end
