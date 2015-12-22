//
//  DSChatDetailViewController.h
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/27/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IBActionSheet.h"
#import "ChatTextView.h"

@interface DSChatDetailViewController : UIViewController < UIActionSheetDelegate>

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

@property IBActionSheet *standardIBAS, *customIBAS, *funkyIBAS;

@property(nonatomic,strong)IBOutlet ChatTextView *chatView;
@property (strong, nonatomic) IBOutlet UIButton *funkyIBASButton;
@property UIView *semiTransparentView;

@property UIColor *textColor, *backgroundColor;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIImageView *menuImageview;
@property (strong, nonatomic) IBOutlet UIView *transparentView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (strong,nonatomic) NSMutableDictionary *chatuserDetailsDict;

- (IBAction)pressCancel:(id)sender;
- (IBAction)pressDelete:(id)sender;
- (IBAction)pressBlock:(id)sender;

@end
