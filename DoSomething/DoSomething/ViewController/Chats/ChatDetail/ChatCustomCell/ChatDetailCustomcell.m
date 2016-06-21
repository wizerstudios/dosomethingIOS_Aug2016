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
       // [self messageTextSettingOld];
        [self messageTextViewNew];

    }
}
-(void)messageTextViewNew{
    if([[chatArray valueForKey:@"type"] isEqualToString:@"SENDER"]){
        
        sender_msgLbl.text=[chatArray valueForKey:@"Message"];
        windowSize = CGSizeMake(320,440);
        [sender_msgLbl sizeToFit];
        sender_bubbleimgView.layer.cornerRadius = 7;
        
        dataSize = [COMMON getControlHeight:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15.0 withSize:CGSizeMake(self.frame.size.width+10,self.frame.size.height)];
        [self setBackgroundColor:[UIColor blueColor]];
        sender_msgLbl.textAlignment = NSTextAlignmentLeft;
        _chatTime.textAlignment = NSTextAlignmentRight;
        CGFloat send_msgLblXPos=(self.frame.size.width/3);
        sender_msgLbl.frame = CGRectMake(send_msgLblXPos,sender_msgLbl.frame.origin.y+10,(self.frame.size.width-send_msgLblXPos)-10,dataSize.height+10);
        [sender_msgLbl setTextColor:[UIColor whiteColor]];
        sender_msgLbl.numberOfLines = 0;
        self.chatTime.frame = CGRectMake(sender_msgLbl.frame.origin.x+5,sender_msgLbl.frame.origin.y-20,sender_msgLbl.frame.size.width-10,20);
        sender_bubbleimgView.frame = CGRectMake(sender_msgLbl.frame.origin.x-5,_chatTime.frame.origin.y+_chatTime.frame.size.height,sender_msgLbl.frame.size.width+10,sender_msgLbl.frame.size.height+5);
        self.chatTime.textColor=[UIColor lightGrayColor];
    }
    else{
        sender_msgLbl.text=[chatArray valueForKey:@"Message"];
        windowSize = CGSizeMake(320,440);
        sender_bubbleimgView.backgroundColor = [UIColor whiteColor];
        sender_bubbleimgView.layer.cornerRadius = 7;
        
        dataSize = [COMMON getControlHeight:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15.0 withSize:CGSizeMake(self.frame.size.width+10,self.frame.size.height)];
        [self setBackgroundColor:[UIColor blueColor]];
        
        sender_msgLbl.textAlignment = NSTextAlignmentLeft;
        _chatTime.textAlignment = NSTextAlignmentRight;
        CGFloat send_msgLblXPos=10;
        sender_msgLbl.frame = CGRectMake(send_msgLblXPos,sender_msgLbl.frame.origin.y+10,(self.frame.size.width/1.5),dataSize.height+10);
        [sender_msgLbl setTextColor:[UIColor blackColor]];
        sender_msgLbl.numberOfLines = 0;
        
        self.chatTime.frame = CGRectMake(sender_msgLbl.frame.origin.x+5,sender_msgLbl.frame.origin.y-20,sender_msgLbl.frame.size.width-10,20);
        
        sender_bubbleimgView.frame = CGRectMake(sender_msgLbl.frame.origin.x-5,_chatTime.frame.origin.y+_chatTime.frame.size.height,sender_msgLbl.frame.size.width+10,sender_msgLbl.frame.size.height+5);
        
        [self.chatTime setTextColor:[UIColor blackColor]];
        
        
        
    }
}

-(void)messageTextSettingOld{
    if([chatArray count]){
        sender_bubbleimgView.hidden=NO;
        
        
        NSString *displayTime =  [chatArray valueForKey:@"displaysenttime"];
        self.chatTime.text = displayTime;
        
        if([[chatArray valueForKey:@"type"] isEqualToString:@"SENDER"]){
            
            sender_msgLbl.text=[chatArray valueForKey:@"Message"];
            dataSize = [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)];
            int y_Position=10;
            windowSize = CGSizeMake(320,440);
            sender_msgLbl.numberOfLines = 2000;
            // sender_bubbleimgView.image = [[UIImage imageNamed:[NSString stringWithFormat:@""]] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            sender_bubbleimgView.layer.cornerRadius = 7;
            
            
            
            if(IS_IPHONE6_Plus){
                
                sender_msgLbl.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE) + 10+80,
                                                 y_Position + sender_msgLbl.frame.origin.y + 8,
                                                 MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width+10 + BUBBLE_WIDTH_SPACE),
                                                 dataSize.height-10);
                [sender_msgLbl setTextColor:[UIColor whiteColor]];
                
                
                
                
                
                sender_bubbleimgView.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+80,
                                                        y_Position + sender_bubbleimgView.frame.origin.y,
                                                        MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+20,
                                                        dataSize.height+BUBBLE_IMAGE_HEIGHT-10);
                self.chatTime.frame = CGRectMake(windowSize.width-40 - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+dataSize.width+50+80,sender_bubbleimgView.frame.origin.y-30,100,40);
                
                
            }
            else if(IS_IPHONE6){
                
                sender_msgLbl.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE) + 10+50,
                                                 y_Position + sender_msgLbl.frame.origin.y + 8,
                                                 MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width+10 + BUBBLE_WIDTH_SPACE),
                                                 dataSize.height-10);
                [sender_msgLbl setTextColor:[UIColor whiteColor]];
                
                
                sender_bubbleimgView.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+50,
                                                        y_Position + sender_bubbleimgView.frame.origin.y,
                                                        MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+20,
                                                        dataSize.height+BUBBLE_IMAGE_HEIGHT-10);
                self.chatTime.frame = CGRectMake(windowSize.width-30 - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+dataSize.width+50+50,sender_bubbleimgView.frame.origin.y-30,100,40);
                
            }
            else{
                sender_msgLbl.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE) + 10,
                                                 y_Position + sender_msgLbl.frame.origin.y + 8,
                                                 MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width+10 + BUBBLE_WIDTH_SPACE),
                                                 dataSize.height-10);
                [sender_msgLbl setTextColor:[UIColor whiteColor]];
                
                
                
                
                
                
                
                sender_bubbleimgView.frame = CGRectMake(windowSize.width - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE),
                                                        y_Position + sender_bubbleimgView.frame.origin.y,
                                                        MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+20,
                                                        dataSize.height+BUBBLE_IMAGE_HEIGHT-10);
                
                self.chatTime.frame = CGRectMake(windowSize.width-70 - ME_RIGHT_WIDTH_SPACE - MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+dataSize.width+50, sender_bubbleimgView.frame.origin.y-30,150,40);
                
                
            }
            self.chatTime.textColor=[UIColor lightGrayColor];
            
            
        }
        else {
            
            sender_msgLbl.text=[chatArray valueForKey:@"Message"];
            dataSize = [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)];
            int y_Position=10;
            windowSize = CGSizeMake(320,440);
            
            sender_msgLbl.numberOfLines = 2000;
            // sender_bubbleimgView.image = [[UIImage imageNamed:[NSString stringWithFormat:@""]] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
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
            self.chatTime.frame = CGRectMake(MAX(dataSize.width, [COMMON dataSize:sender_msgLbl.text withFontName:@"HelveticaNeue" ofSize:15 withSize:CGSizeMake(195.0, 999.0)].width + BUBBLE_WIDTH_SPACE)+y_Position + sender_bubbleimgView.frame.origin.y-100, sender_bubbleimgView.frame.origin.y-30,150,40);
            
            [self.chatTime setTextColor:[UIColor blackColor]];
            
            
            
        }
        
    }
    
}


@end
