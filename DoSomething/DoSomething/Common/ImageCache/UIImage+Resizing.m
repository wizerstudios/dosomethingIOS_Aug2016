//
//  UIImage+Resizing.m
//  FranceOptique
//
//  Created by Alexis Jacquelin on 12/10/13.
//  Copyright (c) 2013 Novactive. All rights reserved.
//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

- (UIImage *)imageScaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
