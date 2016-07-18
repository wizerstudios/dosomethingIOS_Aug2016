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

- (NSString *) getDisplayTime:(NSString *) strDate {
    NSString *displayTime = @"";
    
    if (strDate == NULL || [strDate isEqualToString:@""]) {
        return @"";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDate *formatDate = [[NSDate alloc] init];
    formatDate = [dateFormat dateFromString:strDate];
    
    
    NSDate *currentDate = [[NSDate alloc] init];
    
    NSDateFormatter *dateFormatDay = [[NSDateFormatter alloc] init];
    [dateFormatDay setDateFormat:@"yyyy/MM/dd"];
    NSString *strDateFormatDay  = [dateFormatDay stringFromDate:formatDate];
    NSString *strCurrentDay     = [dateFormatDay stringFromDate:currentDate];
    
    
    if ([strDateFormatDay isEqualToString:strCurrentDay]) {
        
        NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
        [hourFormat setDateFormat:@"hh:mm a"];
        NSString *strHour = [hourFormat stringFromDate:formatDate];
        
        displayTime =[NSString stringWithFormat:@"Today %@",strHour];
        //[NSString stringWithFormat:@"%@ %@ AM",strDate,displayTime];
        
    } else {
        NSDateFormatter *finalDateFormat = [[NSDateFormatter alloc] init];
        [finalDateFormat setDateFormat:@"yyyy/MM/dd hh:mm a"];
        displayTime = [finalDateFormat stringFromDate:formatDate];
    }
    
    //NSLog(@"Final Format for %@ is %@",strDate,displayTime);
    
    return displayTime;
}

-(void)loadMessageView{
    if([chatArray count]){
       sender_bubbleimgView.hidden=NO;
       
        
        NSString *displayTime =  [chatArray valueForKey:@"displaysenttime"];
        self.chatTime.text = displayTime;
        [self messageTextViewNew];

    }
}

#pragma  mark - messageTextViewNew -->NEW CODE
-(void)messageTextViewNew{
    if([[chatArray valueForKey:@"type"] isEqualToString:@"SENDER"]){
        //RIGHT
        sender_msgLbl.text=[chatArray valueForKey:@"Message"];
        sender_bubbleimgView.layer.cornerRadius = 7;
        
        self.chatTime.frame = CGRectMake(self.frame.size.width/2,2,(self.frame.size.width/2)-10,20);
        _chatTime.textAlignment = NSTextAlignmentRight;
        self.chatTime.backgroundColor=[UIColor clearColor];
        
        [sender_msgLbl setTextColor:[UIColor whiteColor]];
        
        NSString *messageStr  = [chatArray valueForKey:@"Message"];
        //UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        
        CGRect rect = [messageStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:sender_msgLbl.font}
                                               context:nil];
        
        
        CGFloat senderHeight =  rect.size.height;
        CGFloat senderWidth = rect.size.width;
       
        CGFloat send_msgLblXPos=_chatTime.frame.origin.x+_chatTime.frame.size.width;
        
        sender_msgLbl.frame = CGRectMake(send_msgLblXPos-60,_chatTime.frame.size.height+5,40,senderHeight+10);
        
        CGRect senderMsgLblFrame = sender_msgLbl.frame;
        
        CGFloat senderMsgLblFrameXPos;
        
        senderMsgLblFrameXPos=(SCREEN_WIDTH-senderWidth);
        
        self.sender_msgLbl.backgroundColor=[UIColor clearColor];
        
        senderMsgLblFrame.origin.x =senderMsgLblFrameXPos-20;//-40;//-20;
            
        senderMsgLblFrame.origin.y =_chatTime.frame.size.height+5;
        
        senderMsgLblFrame.size.width =rect.size.width;
        
        senderMsgLblFrame.size.height =senderHeight+10;
        
        [sender_msgLbl setFrame:senderMsgLblFrame];
       
        [sender_msgLbl sizeToFit];
        sender_msgLbl.textAlignment = NSTextAlignmentLeft;
        sender_msgLbl.numberOfLines = 0;
        
        sender_bubbleimgView.frame = CGRectMake(sender_msgLbl.frame.origin.x-5,(_chatTime.frame.origin.y+_chatTime.frame.size.height)-2,sender_msgLbl.frame.size.width+10,sender_msgLbl.frame.size.height+9);
        
        self.chatTime.textColor=[UIColor lightGrayColor];
    }
    else{
        //LEFT
        NSString *messageStr  = [chatArray valueForKey:@"Message"];
        sender_msgLbl.text=[chatArray valueForKey:@"Message"];
        //windowSize = CGSizeMake(320,440);
        sender_bubbleimgView.backgroundColor = [UIColor whiteColor];
        sender_bubbleimgView.layer.cornerRadius = 7;
        
        self.chatTime.frame = CGRectMake(10,2,self.frame.size.width/2,20);
        _chatTime.textAlignment = NSTextAlignmentLeft;
        self.chatTime.backgroundColor=[UIColor clearColor];
        
        //UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        
        CGRect rect = [messageStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:sender_msgLbl.font}
                                               context:nil];
        CGFloat senderHeight =  rect.size.height;
        
        sender_msgLbl.frame = CGRectMake(15,_chatTime.frame.size.height+5,self.frame.size.width-30,senderHeight+10);
        [sender_msgLbl setTextColor:[UIColor blackColor]];
        sender_msgLbl.numberOfLines = 0;
        [sender_msgLbl sizeToFit];
        sender_msgLbl.textAlignment = NSTextAlignmentLeft;
        
        sender_bubbleimgView.frame = CGRectMake(sender_msgLbl.frame.origin.x-5,(_chatTime.frame.origin.y+_chatTime.frame.size.height)-2,sender_msgLbl.frame.size.width+10,sender_msgLbl.frame.size.height+9);
        
        [self.chatTime setTextColor:[UIColor blackColor]];
        
    }
}


@end
