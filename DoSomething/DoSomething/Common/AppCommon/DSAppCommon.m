//
//  DSAppCommon.m
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSAppCommon.h"
#import <sys/xattr.h>
#import <CommonCrypto/CommonCrypto.h>
#import "DSConfig.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAIFields.h"



#ifdef DEBUG

#define BUILD_FOR_DEVPRO                      @"dev"

#else

#define BUILD_FOR_DEVPRO                      @"pro"

#endif

@implementation DSAppCommon
@synthesize locationManager;
DSAppCommon *sharedCommon = nil;

+ (DSAppCommon *)common {
    
    if (!sharedCommon) {
        
        sharedCommon = [[self alloc] init];
    }
    return sharedCommon;
}

- (id)init {
    
    return self;
}

#pragma mark - Get Current Device Info

- (currentDevice)getCurrentDevice
{
    if (([[UIScreen mainScreen] bounds].size.height == 480 && [[UIScreen mainScreen] bounds].size.width == 320) || ([[UIScreen mainScreen] bounds].size.width == 480 && [[UIScreen mainScreen] bounds].size.height == 320)) {
        return iPhone4;
    }
    else if (([[UIScreen mainScreen] bounds].size.height == 568 && [[UIScreen mainScreen] bounds].size.width == 320) || ([[UIScreen mainScreen] bounds].size.width == 568 && [[UIScreen mainScreen] bounds].size.height == 320))
        return iPhone5;
    else if (([[UIScreen mainScreen] bounds].size.height == 667 && [[UIScreen mainScreen] bounds].size.width == 375) || ([[UIScreen mainScreen] bounds].size.width == 667 && [[UIScreen mainScreen] bounds].size.height == 375))
        return iPhone6;
    else if (([[UIScreen mainScreen] bounds].size.height == 736 && [[UIScreen mainScreen] bounds].size.width == 414) || ([[UIScreen mainScreen] bounds].size.width == 736 && [[UIScreen mainScreen] bounds].size.height == 414))
        return iPhone6Plus;
    else if (([[UIScreen mainScreen] bounds].size.height == 768 && [[UIScreen mainScreen] bounds].size.width == 1024) || ([[UIScreen mainScreen] bounds].size.width == 1024 && [[UIScreen mainScreen] bounds].size.height == 768))
        return iPad;
    
    return 0;
}

#pragma mark - Resizeable Font

- (UIFont *)getResizeableFont:(UIFont *)currentFont {
    
    CGFloat sizeScale = 1;
    
    if (IS_IPHONE_DEVICE) {
        
        if ([COMMON getCurrentDevice] == iPhone6Plus)
        {
            sizeScale = 1.3;
        }
        else if ([COMMON getCurrentDevice] == iPhone6)
        {
            sizeScale = 1.2;
        }
    }
   else
   {
       sizeScale = 1.4;
   }
   return [currentFont fontWithSize:(currentFont.pointSize * sizeScale)];
}
#pragma mark Show alert

+(void)showSimpleAlertWithMessage:(NSString *)message{

    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: APP_TITLE
                                                   message: message
                                                  delegate: nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];

}


+(UIAlertController*)alertWithTitle: (NSString *) title withMessage: (NSString*) message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_TITLE message:message preferredStyle: preferredStyle];
    UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"ok action");}];
    [alert addAction:ok];
    return alert;

}
#pragma mark Reachable

-(BOOL) isInternetReachable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        NSLog(@"Data Connected");
        return YES;
    }
    else {
        [self reachabilityNotReachableAlert];
        return NO;
    }
}

-(void)reachabilityNotReachableAlert{
    
    [self DSRemoveLoading];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] message:@"It appears that you have lost network connectivity. Please check your network settings!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
    
}
#pragma mark - Alert Function

- (void) showErrorAlert:(NSString *)strMessage{
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
                                                         message:strMessage
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}
#pragma mark - Get Height of Control

- (CGSize)getControlHeight:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth {
    CGSize maxSize = LabelWidth;
    CGSize dataHeight;
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.paragraphSpacing = 50 * font.lineHeight;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if ([version floatValue]>=7.0) {
        CGRect textRect = [string boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
        
        
        dataHeight = CGSizeMake(textRect.size.width , textRect.size.height+20);
        
    }
    
    return CGSizeMake(dataHeight.width, dataHeight.height);
}

#pragma  mark - Cell Height

- (CGSize)dataSize:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth {
    CGSize maxSize = LabelWidth;
    CGSize dataHeight;
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version floatValue]>=7.0) {
        CGRect textRect = [string boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
        
        dataHeight = CGSizeMake(textRect.size.width , textRect.size.height);
        
    }else{
        dataHeight = [string sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return CGSizeMake(dataHeight.width, dataHeight.height+15);
}

-(NSString *)getCurrentDateTime{
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateformat stringFromDate:[NSDate date]];
    return dateString;
}


#pragma mark - Userdetails

-(void)setUserDetails:(NSMutableDictionary *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableDictionary class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:USERDETAILS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeUserDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDETAILS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary *)getUserDetails
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
   
    return dic;
    
}

- (BOOL) isUserLoggedIn {
    NSDictionary *userDetails = [self getUserDetails];
    if (userDetails != NULL) {
       // [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentLongitude];
       // [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentLatitude];
        return YES;
    }
    return NO;
}

-(NSString *)getSessionID{
    NSString *sessionID = [NSString stringWithFormat:@"%@",[[self getUserDetails]valueForKey:@"SessionId"]];
    NSLog(@"sessionID = %@",sessionID);
    return sessionID;
}

-(NSString *)getUserID{
    NSString *sessionID = [[self getUserDetails]valueForKey:@"user_id"];
    NSLog(@"sessionID = %@",sessionID);
    return sessionID;
}

-(NSString *)getLatitude
{
    NSString *Latitude =[[NSUserDefaults standardUserDefaults]valueForKey:CurrentLatitude];//currentLatitudeCurrentLatitude
    if(Latitude==nil){
        Latitude=@"";
    }
    
    return Latitude;
}
-(NSString *)getLongitude
{
    NSString *Longitude =[[NSUserDefaults standardUserDefaults]valueForKey:CurrentLongitude];
    if(Longitude==nil){
        Longitude=@"";
    }
    return Longitude;
}

#pragma mark User Interaction Loading :

- (void)DSLoadIcon:(UIView *)view
{
    if([COMMON isInternetReachable]) {
        
        [self DSRemoveLoading];

        NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"DoSomething_loading" withExtension:@"gif"];;
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat XPos,YPos;
        XPos = ((screenWidth/2)-20);
        YPos = ((screenHeight/2)-20);
        _gifImageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(XPos,YPos,40,40)];
        
        [_gifImageView setData:imageData];
        [view addSubview:_gifImageView];
    }
}

-(void)DSRemoveLoading
{
    [_gifImageView removeFromSuperview];
}


#pragma mark - checkLocationServicesTurnedOn
- (void) checkLocationServicesTurnedOn:(NSString *)string{
    if(![CLLocationManager locationServicesEnabled] || ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedAlways))
    {
        if([string isEqualToString:@"login"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alertBoxLoginView"object:self userInfo:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"alertBoxHomeView"object:self userInfo:nil];
        }
    }
    else{
        
       if([string isEqualToString:@"login"]){
           [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCurrentLocation"object:self userInfo:nil];
       }
       else{
           [[NSNotificationCenter defaultCenter] postNotificationName:@"homeCurrentLocation"object:self userInfo:nil];
       }
        
    }
    
}

#pragma mark Set Message Count

- (void) setMessageCount:(NSString *)messageCount {
    
    if (messageCount == NULL || [messageCount isEqualToString:@"(null)"]) {
        messageCount = @"";
    }
    else {
        messageCount = [NSString stringWithFormat:@"%ld",(long)[[UIApplication sharedApplication] applicationIconBadgeNumber]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:messageCount forKey:UnreadMsgCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark get user CurrentLocation

- (void)getUserCurrentLocation{
    
    if(!locationManager){
        locationManager                 = [[CLLocationManager alloc] init];
        locationManager.delegate        = self;
        locationManager.distanceFilter  = kCLLocationAccuracyKilometer;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType    = CLActivityTypeAutomotiveNavigation;
    }
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    }

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    currentLatitude         = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.latitude]];
    currentLongitude        = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:newLocation.coordinate.longitude]];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:CurrentLatitude];
    [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:CurrentLongitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [locationManager stopUpdatingLocation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //[self loadLocationUpdateAPI];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location for main view.");
}

//checking
#pragma mark - getUserCurrentLocationData
- (void)getUserCurrentLocationData{

    objWebService = [[DSWebservice alloc]init];
    LocationDict=[[NSMutableDictionary alloc]init];
    LocationDict =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    NSString * strsessionID =[LocationDict valueForKey:@"SessionId"];
    sessionId = strsessionID;
    NSLog(@"strsessionID%@",strsessionID);
    NSLog(@"currentLatitude%@",currentLatitude);
    NSLog(@"currentLongitude%@",currentLongitude);
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    
    if(deviceToken == nil)
        deviceToken = @"";
    
    [objWebService locationUpdate:LocationUpdate_API
                        sessionid:sessionId
                         latitude:currentLatitude
                        longitude:currentLongitude
                      deviceToken:deviceToken
                         pushType:push_type
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"LocationUpdate_API%@",responseObject);
                              
                              
                          } failure:^(AFHTTPRequestOperation *operation, id error) {
                               NSLog(@"LocationUpdateError%@",error);
                              
                          }];
    
}

#pragma - Google Analytics

-(void)TrackerWithName:(NSString *)message
{
//    if ([BUILD_FOR_DEVPRO isEqualToString:@"dev"])
//    {
//        
//    }
//    else
//    {
    if ([COMMON isInternetReachable]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            // May return nil if a tracker has not already been initialized with a
            // property ID.
            id tracker = [[GAI sharedInstance] defaultTracker];
            
            // This screen name value will remain set on the tracker and sent with
            // hits until it is set to a new value or to nil.
            [tracker set:kGAIScreenName
                   value:message];
            
            // Previous V3 SDK versions
            // [tracker send:[[GAIDictionaryBuilder createAppView] build]];
            
            // New SDK versions
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        });
    }
}


#pragma mark - Avoid Cloud store

bool addSkipBackupAttributeToItemAtURL (NSURL* URL)
{
    if (& NSURLIsExcludedFromBackupKey == nil)
    {
        // iOS <= 5.0.1
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else
    {
        // iOS >= 5.1
        NSError *error = nil;
        
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                        
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
}


void downloadImageFromUrl(NSString* urlString, UIImageView * imageview)
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake((imageview.frame.size.width-47)/2, (imageview.frame.size.height-47)/2, 37, 37)];
    
    [loadingView.layer setCornerRadius:5.0];
    
    [loadingView setBackgroundColor:[UIColor clearColor]];
    
    //Enable maskstobound so that corner radius would work.
    
    [loadingView.layer setMasksToBounds:YES];
    
    //Set the corner radius
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityView setFrame:CGRectMake(7, 7, 37, 37)];
    
    [activityView setHidesWhenStopped:YES];
    
    [activityView startAnimating];
    
    [loadingView addSubview:activityView];
    
    [imageview addSubview:loadingView];
    
    NSString *imageFile = [[[NSString stringWithFormat:@"%@",urlString] componentsSeparatedByString:@"/"] lastObject];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileNameToSave = [documentsDirectory stringByAppendingPathComponent:imageFile];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileNameToSave]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfFile:fileNameToSave];
            
            UIImage *img = [UIImage imageWithData:data];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if(img) {
                    
                    imageview.image=img;
                    
                    imageview.contentMode = UIViewContentModeScaleAspectFill;
                    
                    [activityView stopAnimating];
                }
            });
        });
    }
    else {
        
        if ([COMMON isInternetReachable]) {

            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                
                UIImage *img = [UIImage imageWithData:data];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if(img) {
                        
                        imageview.image=img;
                        
                        imageview.contentMode = UIViewContentModeScaleAspectFill;
                        
                        saveContentsToFile(data,imageFile);
                    }
                    [activityView stopAnimating];
                });
            });
        }
    }
}


void saveContentsToFile (id data, NSString* filename) {
    
    NSArray *namesArray = [filename componentsSeparatedByString:@"/"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileNameToSave;
    
    if ([namesArray count]>1) {
        NSString *dirNameToSave=[documentsDirectory stringByAppendingPathComponent:[namesArray objectAtIndex:0]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirNameToSave])
            [[NSFileManager defaultManager] createDirectoryAtPath:dirNameToSave withIntermediateDirectories:YES attributes:nil error:nil];
        
        for (int i=1; i<[namesArray count]-1; i++) {
            
            dirNameToSave = [dirNameToSave stringByAppendingPathComponent:[namesArray objectAtIndex:i]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:dirNameToSave])
                
                [[NSFileManager defaultManager] createDirectoryAtPath:dirNameToSave withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
    }
    
    fileNameToSave = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSLog(@"fileNameToSave = %@",fileNameToSave);
    
    [data writeToFile:fileNameToSave atomically:YES];
    
    // NSLog(@"data = %@",data);
    
    // NSLog(@"url = %@",[NSURL fileURLWithPath:fileNameToSave]);
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:fileNameToSave]);
}

#pragma mark GettingFilesInLocal

-(BOOL) isFileExistsInLocal:(NSString *)fileName fileType:(NSString *) fileType {
    NSFileManager *fileManagerPath = [NSFileManager defaultManager];
    NSArray *pathsValue = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [pathsValue objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    if ([fileManagerPath fileExistsAtPath:filePath isDirectory:NO]) {
        return YES;
    } else {
        return NO;
    }
}

- (id)getContentsFromLocal:(NSString *)fileName fileType:(NSString *)fileType {
    NSArray *pathsValue = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSArray *pathvalue = @"FranceOptique/Resources/";
    NSString *documentsDirectoryPath = [pathsValue objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    //    NSLog(@"FilePath = %@",filePath);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    return data;
    
}

-(void)deleteDocumentPathContents {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    for (NSString *path in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:[documentPath stringByAppendingPathComponent:path] error:nil];
    }
    
    NSString *tempPath = NSTemporaryDirectory();
    for (NSString *path in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempPath error:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:[tempPath stringByAppendingPathComponent:path] error:nil];
    }
}




@end
