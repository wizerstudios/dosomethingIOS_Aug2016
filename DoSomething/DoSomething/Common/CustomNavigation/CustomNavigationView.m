//
//  CustomNavigationView.m
//  Policy 99
//
//  Created by Ocs Developer 6 on 7/24/15.
//  Copyright (c) 2015 Ocs Developer 6. All rights reserved.
//

#import "CustomNavigationView.h"

@interface CustomNavigationView ()

@end

@implementation CustomNavigationView
      
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


#pragma mark - Navigation Methods
-(void)setbuttonBackHidden:(BOOL)_hide{
    [self.buttonBack setHidden:_hide];
}

//-(void)setbackButtonHidden:(BOOL)_hide{
//    [self.backButton setHidden:_hide];
//}


@end
