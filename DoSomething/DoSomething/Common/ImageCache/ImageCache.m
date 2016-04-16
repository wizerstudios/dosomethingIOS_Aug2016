//
//  ImageCache.m
//
//  Copyright (c) 2013 Pierre Marty. All rights reserved.
//

#import "ImageCache.h"
#import "ImageRequest.h"
#import "DSAppCommon.h"

@interface ImageCache () <ImageRequestDelegate>
{
}
@property (nonatomic, strong) NSString * cachePath;
@property (nonatomic, strong) NSOperationQueue * diskOperationQueue;
@property (nonatomic, strong) NSString * baseImageURL;
@end


@implementation ImageCache



+ (ImageCache *)sharedInstance {
	static ImageCache * sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[ImageCache alloc] init];
	});
	return sharedInstance;
}


- (id)init {	
	self = [super init];
	if (self) {
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		self.cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imageCache"];
		self.diskOperationQueue = [[NSOperationQueue alloc] init];
		[self createCacheDirectory];
		NSLog (@"%f", [[UIScreen mainScreen] scale]);
		
        self.baseImageURL = [BASE_URL stringByAppendingString:@"/uploads"];
		
		
	}
	
	return self;
}


- (void)createCacheDirectory {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSError * theError = nil;
	
	// try creating it, even if it already exists
	if (! [fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:YES attributes:nil error:&theError]) {
		NSAssert ((theError.code == NSFileWriteFileExistsError), @"error creating directory");
	}
}

- (void)clearCache {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSError * theError = nil;
	BOOL ok = [fileManager removeItemAtPath:self.cachePath error:&theError];
	if (!ok) {
		NSAssert ((theError.code == NSFileWriteFileExistsError), @"error clearCache");
	}
	[self createCacheDirectory];
}


- (UIImage *)imageFromlocalcache:(NSString *)imageUrlStr imageType:(NSString *)_imgType{
    
    NSString *tempString;
  
    tempString=[NSString stringWithFormat:@"%@",[imageUrlStr lastPathComponent]];
    NSString *imageName = [NSString stringWithFormat:@"%@",tempString];
    
    UIImage* localimage;
    
    if (![imageName isEqualToString:@"(null)"] && ![imageName isEqualToString:@"nil"] && ![tempString isKindOfClass:[NSNull class]]) {
        localimage = [UIImage imageNamed:imageName];
        if (!localimage) {
            NSString * url = [NSString stringWithFormat:@"%@/%@",_imgType,tempString];
            NSData* imagepathdata = [COMMON getContentsFromLocal:url fileType:@"string"];
            localimage = [UIImage imageWithData:imagepathdata];
        }
        
    }

    
	if (!localimage) {
		localimage = [UIImage imageNamed:@""];
	}
	return localimage;
}

#pragma  mark -


@end



