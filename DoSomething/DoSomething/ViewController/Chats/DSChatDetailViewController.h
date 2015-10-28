//
//  DSChatDetailViewController.h
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/27/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "IBActionSheet.h"

@interface DSChatDetailViewController : UIViewController <UIActionSheetDelegate> //<IBActionSheetDelegate, UIActionSheetDelegate>

{
    IBOutlet UILabel *OnlineLabel;
    
    __weak IBOutlet UILabel *Message1;
    __weak IBOutlet UILabel *Message2;
    __weak IBOutlet UILabel *Message3;
    
    __weak IBOutlet UILabel *Time1;
    __weak IBOutlet UILabel *Time2;
    __weak IBOutlet UILabel *Time3;
}

@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *ProfileName;
@property(nonatomic,retain) NSString *activestring;
@property(nonatomic,retain) NSString *activestring1;

//@property IBActionSheet *standardIBAS, *customIBAS, *funkyIBAS;

@property (strong, nonatomic) IBOutlet UIButton *funkyIBASButton;
@property UIView *semiTransparentView;

@property UIColor *textColor, *backgroundColor;

@end
