//
//  ChatDetailCustomcell.h
//  DoSomething
//
//  Created by Ocs Developer 6 on 12/26/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatDetailCustomcell : UITableViewCell{
    
    CGSize dataSize;
    CGSize windowSize;
    NSMutableArray *chatArray;
    
}

-(void)getMessageArray:(NSMutableArray *)Array;
@property(nonatomic,strong)IBOutlet UILabel * chatTime;
@property(nonatomic,strong)IBOutlet UILabel *sender_msgLbl;
@property(nonatomic,strong)IBOutlet UIImageView *sender_bubbleimgView;
@end
