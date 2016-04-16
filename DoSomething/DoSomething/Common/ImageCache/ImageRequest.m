//
//  ImageRequest.m
//
//  Copyright (c) 2013 Pierre Marty. All rights reserved.
//

#import "ImageRequest.h"


@interface ImageRequest () <NSURLConnectionDelegate>
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSURLConnection * urlConnection;
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, assign) NSInteger errorCode;
@end


@implementation ImageRequest


- (id)initWithURL:(NSString*)url {
	self= [super init];
	if (self) {
		self.url = url;
		self.errorCode = noErr;
	}
	return self;
}

// data property accessor
- (NSData *)data {
	return self.receivedData;
}


- (void)send {
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
	self.receivedData = [NSMutableData data];
	self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)cancelRequest {
	[self.urlConnection cancel];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   [self.receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.urlConnection = nil;
	self.errorCode = error.code;
	if (self.delegate) {
		[self.delegate requestCompleted:self];
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   [self.receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.urlConnection = nil;
	if (self.delegate) {
		[self.delegate requestCompleted:self];
	}
}


@end




