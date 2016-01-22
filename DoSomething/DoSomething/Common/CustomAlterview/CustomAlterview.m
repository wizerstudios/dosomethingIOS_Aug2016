//
//  CustomAlterview.m
//  DoSomething
//
//  Created by Sha on 11/30/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "CustomAlterview.h"
#import "DSAppCommon.h"
@interface CustomAlterview ()


@end

@implementation CustomAlterview
@synthesize alertMainBgView,alertBgView,alertCancelButton,alertMsgLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];
    alertBgView.hidden =YES;
    alertMainBgView.hidden =YES;
    [self.view setHidden:YES];
    if(IS_IPHONE6)
    {
        self.mainalterviewheight.constant=-100;
    }
    else if(IS_IPHONE6_Plus)
    {
        self.mainalterviewheight.constant=-180;
    }
    else
    {
        self.mainalterviewheight.constant=0;
    }
    
    
}

- (IBAction)alertPressCancel:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        
       // alertBgView.alpha = 0;
        
     //   alertMainBgView.alpha = 0;
        
    } completion:^(BOOL b){
        
        
        alertBgView.hidden = YES;
        
        alertMainBgView.hidden = YES;
        self.view.hidden=YES;
    }];
}

- (IBAction)alertPressYes:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
       /// alertBgView.alpha = 0;
        
     //   alertMainBgView.alpha = 0;
    }
                     completion:^(BOOL b){
                         
                         alertBgView.hidden = YES;
                         
                         alertMainBgView.hidden = YES;
                         self.view.hidden =YES;
                        
                         
                     }];
    
}

- (IBAction)alertPressNo:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        
     //   alertBgView.alpha = 0;
        
    //    alertMainBgView.alpha = 0;
        
    } completion:^(BOOL b){
        
        
        alertBgView.hidden = YES;
        
        alertMainBgView.hidden = YES;
        self.view .hidden =YES;
         
        
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
