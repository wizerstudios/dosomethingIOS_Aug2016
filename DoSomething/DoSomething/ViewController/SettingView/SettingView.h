//
//  SettingView.h
//  DoSomething
//
//  Created by Sha on 11/25/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingView : UIViewController<CLLocationManagerDelegate>
{
    
    IBOutlet UILabel * messLbl;
    IBOutlet UILabel *soundLbl;
    IBOutlet UILabel *vibrationLbl;
}

@property (strong,nonatomic) IBOutlet UIScrollView  *settingScroll;

@property (nonatomic ,strong) IBOutlet UIView       * notificationview;

@property (nonatomic,strong)  CLLocationManager       * locationManager;


@end
