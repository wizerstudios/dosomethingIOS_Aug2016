//
//  LogoImageRequest.h
//
//  Copyright (c) 2013 Pierre Marty. All rights reserved.
//

// envoie une requete, reçoit la réponse et signale que les données sont arrivées. (ou echec)

#import <Foundation/Foundation.h>


@class ImageRequest;

@protocol ImageRequestDelegate
- (void)requestCompleted:(ImageRequest*)request;
@end


@interface ImageRequest : NSObject

@property (nonatomic, readonly) NSString * url;
@property (nonatomic, readonly) NSData * data;
@property (nonatomic, readonly) NSInteger errorCode;
@property (nonatomic, weak) id<ImageRequestDelegate> delegate;

- (id)initWithURL:(NSString*)url;

- (void)send;
- (void)cancelRequest;

@end



