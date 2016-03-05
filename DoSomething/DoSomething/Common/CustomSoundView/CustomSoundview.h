//
//  CustomSoundview.h
//  DoSomething
//
//  Created by Sha on 3/3/16.
//  Copyright © 2016 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundTableCell.h"
#import <AudioToolbox/AudioToolbox.h>
@interface CustomSoundview : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *audioFileList;
    NSMutableArray * audioFilelistNew;
    NSMutableArray *combinationArray;
    
    IBOutlet SoundTableCell *soundMenuCell;
}
@property(nonatomic,strong) IBOutlet UIView * soundmenuView;
@property (nonatomic,strong) IBOutlet UITableView * soundmenutableview;
@property (nonatomic ,strong) IBOutlet UIButton * soundMenuCancelBtn;
@property (nonatomic,strong)IBOutlet UIButton *soundmenuOkBtn;
@property (nonatomic,strong)  NSString * selectSoundStr;
@property(nonatomic,strong) NSString* urlString;
@property (nonatomic) SystemSoundID * selectSoundID;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint *soundmenutrailing;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint *soundmenuheight;
@end
