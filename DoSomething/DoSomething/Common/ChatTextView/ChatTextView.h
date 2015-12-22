//
//  ChatTextView.h
//  Social_Events
//
//  Created by Ocsmobi-5 on 18/10/14.
//  Copyright (c) 2014 Social_Events. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTextView : UIView{
    
    
}

@property (strong) IBOutlet id delegate;

@property(strong,nonatomic)  UIButton    *postButton;
@property(strong,nonatomic)  UITextView  *textView;
@property(strong,nonatomic)  UIImageView *backGroundImageView;
@property(strong,nonatomic) UILabel       *placeHolderLabel;
@end
