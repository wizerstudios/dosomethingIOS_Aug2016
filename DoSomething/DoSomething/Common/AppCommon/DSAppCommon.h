//
//  DSAppCommon.h
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "DSWebservice.h"
#import "DSConfig.h"
#import <MapKit/MapKit.h>
#import "SCGIFImageView.h"
typedef enum {
    
    iPhone4,
    iPhone5,
    iPhone6,
    iPhone6Plus,
    iPad
}currentDevice ;

@interface DSAppCommon : NSObject <UIActionSheetDelegate,CLLocationManagerDelegate>
{
    
    NSArray *permissions;
    UIView  *loadingView;
    UIActivityIndicatorView *activityView;
    CLLocationManager       *locationManager;
    DSWebservice            * objWebService;
    NSMutableDictionary     *LocationDict;
    NSString *sessionId;
    
    //NSString *latitude;
   // NSString *longitude;
    NSString                *currentLatitude,*currentLongitude;
    
    
}
@property (nonatomic,strong)  CLLocationManager         *  locationManager;
@property (strong, nonatomic) IBOutlet SCGIFImageView * gifImageView;
+(DSAppCommon *) common;

- (void)setUserDetails:(NSMutableDictionary *)_dicInfo;
- (void)removeUserDetails;
- (NSMutableDictionary *)getUserDetails;
//- (NSString *)getUserId;
-(void)TrackerWithName:(NSString *)message;

-(NSString *)getCurrentDateTime;

- (void)DSLoadIcon:(UIView *)view;
- (void)DSLoaderIcon:(UIView *)view;
- (void)DSRemoveLoading;
-(BOOL)isInternetReachable;
- (void) showErrorAlert:(NSString *)strMessage;
- (currentDevice)getCurrentDevice;
- (BOOL) isUserLoggedIn;
- (void)getUserCurrentLocation;
-(NSString *)getSessionID;
-(NSString *)getUserID;
-(NSString *)getLatitude;
-(NSString *)getLongitude;

- (CGSize)dataSize:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth;

- (void) setMessageCount:(NSString *)messageCount;


void downloadImageFromUrl(NSString* urlString, UIImageView * imageview);

// ResizeableFont
- (UIFont *)getResizeableFont:(UIFont *)currentFont;
+(void)showSimpleAlertWithMessage:(NSString *)message;
+(UIAlertController*)alertWithTitle: (NSString *) title withMessage: (NSString*) message preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (CGSize)getControlHeight:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth;

//LocalFileSaving
-(BOOL) isFileExistsInLocal:(NSString *)fileName fileType:(NSString *) fileType;
void saveContentsToFile (id data, NSString* filename);
- (id)getContentsFromLocal:(NSString *)fileName fileType:(NSString *)fileType;
-(void)deleteDocumentPathContents;

@end
extern DSAppCommon *sharedCommon;
#define COMMON (sharedCommon? sharedCommon:[DSAppCommon common])