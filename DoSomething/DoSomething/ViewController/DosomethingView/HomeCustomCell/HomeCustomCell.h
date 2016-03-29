//
//  HomeCustomCell.h
//  DoSomething
//
//  Created by ocsdev4 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UILabel * MenuTittle;

@property (nonatomic,strong) IBOutlet UIImageView * MenuImg;

@property (nonatomic,strong) IBOutlet UIImageView * activeImg;

@property (nonatomic, strong) NSString *imageName;



@end
