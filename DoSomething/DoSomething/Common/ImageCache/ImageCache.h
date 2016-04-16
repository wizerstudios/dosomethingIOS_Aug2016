//
//  ImageCache.h
//
//  Copyright (c) 2013 Pierre Marty. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

+ (ImageCache *)sharedInstance;

- (void)clearCache;

- (UIImage *)imageFromlocalcache:(NSString *)imageUrlStr imageType:(NSString *)_imgType;

@end

