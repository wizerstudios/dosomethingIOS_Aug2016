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
#import "ChatDetailCustomcell.h"

@interface DSChatDetailViewController : UIViewController < UIActionSheetDelegate>

{
    IBOutlet UILabel *OnlineLabel;
    
    IBOutlet UITableView *chatTableView;
    
    IBOutlet ChatDetailCustomcell *chatCustomcell;
    
    
}
@property (nonatomic,strong) IBOutlet UIView * topview;
@property (nonatomic ,strong) IBOutlet NSLayoutConstraint * topviewYposition;

@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *ProfileName;

@property IBActionSheet *standardIBAS, *customIBAS, *funkyIBAS;

@property(nonatomic,strong)IBOutlet ChatTextView *chatView;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *chatviewbottom;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * chattableheight;

@property (strong, nonatomic) IBOutlet UIButton *funkyIBASButton;
@property UIView *semiTransparentView;

@property UIColor *textColor, *backgroundColor;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIImageView *menuImageview;
@property (strong, nonatomic) IBOutlet UIView *transparentView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (strong,nonatomic) NSMutableDictionary *chatuserDetailsDict;
@property (strong,nonatomic) NSString *conversionID;

@property (strong)NSTimer *messageTimer;

- (IBAction)pressCancel:(id)sender;
- (IBAction)pressDelete:(id)sender;
- (IBAction)pressBlock:(id)sender;

@end
