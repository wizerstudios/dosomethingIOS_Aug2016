//
//  LocationCollectionViewCell.h
//  DoSomething
//
//  Created by Ocs-web on 16/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCollectionViewCell : UICollectionViewCell
@property(nonatomic,retain)IBOutlet UIImageView *imageProfile;
@property(nonatomic,retain)IBOutlet UILabel *kiloMeter;
@property(nonatomic,retain)IBOutlet UILabel *nameProfile;
@property(nonatomic,retain)IBOutlet UILabel *sendRequest;
@property(nonatomic,retain)IBOutlet UILabel *activeNow;

@property(nonatomic,retain)IBOutlet UIImageView *hobbiesImage;



@end
