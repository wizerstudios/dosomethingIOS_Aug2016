//
//  ProfileTableViewController.h
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSProfileTableViewCell.h"

@interface DSProfileTableViewController : UIViewController<UINavigationControllerDelegate>
{
 IBOutlet DSProfileTableViewCell *cellProfileImg;
 IBOutlet DSProfileTableViewCell *cellButton;
 IBOutlet DSProfileTableViewCell *cellAddIcon;
 IBOutlet DSProfileTableViewCell *cellTextField;
 IBOutlet DSProfileTableViewCell *cellDatePicker;

}
@property (strong, nonatomic) IBOutlet UITableView *tableviewProfile;

@end
