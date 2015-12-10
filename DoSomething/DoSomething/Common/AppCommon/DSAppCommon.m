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
@implementation DSAppCommon
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
        
        
        dataHeight = CGSizeMake(textRect.size.width , textRect.size.height);
        
    }
    
    return CGSizeMake(dataHeight.width, dataHeight.height+10);
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
        return YES;
    }
    return NO;
}



#pragma mark User Interaction Loading :

-(void)LoadIcon:(UIView *)view
{
    [self removeLoading];
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width)/2.3, (view.frame.size.height-37)/2.3, 37, 37)];
    [loadingView.layer setCornerRadius:5.0];
    
    [loadingView setBackgroundColor:[UIColor blackColor]];
    //Enable maskstobound so that corner radius would work.
    [loadingView.layer setMasksToBounds:YES];
    //Set the corner radius
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView setFrame:CGRectMake(1, 1, 37, 37)];
    [activityView setHidesWhenStopped:YES];
    [activityView startAnimating];
    [loadingView addSubview:activityView];
    [view addSubview:loadingView];
}

-(void)removeLoading{
    [loadingView removeFromSuperview];
}

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
    
    //NSLog(@"fileNameToSave = %@",fileNameToSave);
    
    [data writeToFile:fileNameToSave atomically:YES];
    
    // NSLog(@"data = %@",data);
    
    // NSLog(@"url = %@",[NSURL fileURLWithPath:fileNameToSave]);
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:fileNameToSave]);
}




@end
