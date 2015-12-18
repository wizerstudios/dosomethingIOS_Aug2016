//
//  DSChatsTableViewController.h
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/28/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DSChatsTableViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic,strong)  CLLocationManager       * locationManager;
@property (strong, nonatomic) IBOutlet UITableView *ChatTableView;

@end
