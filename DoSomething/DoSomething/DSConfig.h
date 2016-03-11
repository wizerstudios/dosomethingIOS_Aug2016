//
//  DSConfig.h
//  DoSomething
//
//  Created by ocs-mini-7 on 10/9/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

#define screen_width                    [[UIScreen mainScreen] bounds].size.width
//#define  IS_IPAD_DEVICE (([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)?NO:YES)

#define IS_IPHONE_DEVICE                (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?NO:YES)

#define IS_IPHONE4                      (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)

#define IS_IPHONE5                      (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IPHONE6                      (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IPHONE6_Plus                 (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

#define IS_IPAD                         (([[UIScreen mainScreen] bounds].size.height-768)?NO:YES)

// OS Versions
#define IS_GREATER_IOS7                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)

#define IS_GREATER_IOS8                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO)

#define IS_GREATER_IOS9                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)?YES:NO)


#pragma mark - FONTS

#define FontAwesome(_size)              [UIFont fontWithName:@"fontawesome-webfont.ttf" size:_size]

#define FutworaPro_Regular(_size)       [UIFont fontWithName:@"FutworaPro-Regular.otf" size:_size]

#define Patron_Black(_size)             [UIFont fontWithName:@"Patron-Black.ttf" size:_size]

#define Patron_BlackItalic(_size)       [UIFont fontWithName:@"Patron-BlackItalic.ttf" size:_size]

#define Patron_Bold(_size)              [UIFont fontWithName:@"Patron-Bold.ttf" size:_size]

#define Patron_BoldItalic(_size)        [UIFont fontWithName:@"Patron-BoldItalic.ttf" size:_size]

#define Patron_ExtraLight(_size)        [UIFont fontWithName:@"Patron-ExtraLight.ttf" size:_size]

#define Patron_ExtraLightItalic(_size)  [UIFont fontWithName:@"Patron-ExtraLightItalic.ttf" size:_size]

#define Patron_Italic(_size)            [UIFont fontWithName:@"Patron-Italic.ttf" size:_size]

#define Patron_Medium(_size)            [UIFont fontWithName:@"Patron-Medium.ttf" size:_size]

#define Patron_MediumItalic(_size)      [UIFont fontWithName:@"Patron-MediumItalic.ttf" size:_size]

#define Patron_Regular(_size)           [UIFont fontWithName:@"Patron-Regular.ttf" size:_size]

#define Patron_Thin(_size)              [UIFont fontWithName:@"Patron-Thin.ttf" size:_size]

#define Patron_ThinItalic(_size)        [UIFont fontWithName:@"Patron-ThinItalic.ttf" size:_size]

#define PATRON_BOLD(Value)              [UIFont fontWithName:@"Patron-Bold" size:Value]

#define PATRON_REG(Value)               [UIFont fontWithName:@"Patron-Regular" size:Value]

#define appDel  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define APP_TITLE                   @"DoSomething"

#define FILL_DETAILS                @"Please Enter Email and Password"

#define FILL_ALL_DETAILS            @"Please Enter FirstName, LastName , Date Of Birth , Email , Password"

#define INVALID_EMAIL               @"Enter Valid Email"

#define EMAIL_REQUIRED              @"Email Required"

#define PASSWORD_REQUIRED           @"Password Required"


#define FIRSTNAME_REQUIRED          @"FirstName Required"

#define LASTNAME_REQUIRED           @"LastName Required"

#define GENDER_REQUIRED             @"Gender Required"

#define DOB_REQUIRED                @"Date OF Birth Required"

#define timerSeconds                5.0

#define UnreadMsgCount              @"chatunreadmessage"

//API Keys
#define CheckUser_API               @"checkuser"
#define User_Logout_Delete_API      @"useraction"
#define Login_API                   @"signin"
#define Register_API                @"register"
#define ProfileUpdate_API           @"updateprofile"
#define LocationUpdate_API          @"updatelocation"
#define GetHobbies_API              @"gethobbies"
#define DoSomething_API             @"dosomethinglist"
#define UpdateDoSomething_API       @"updatedosomething"
#define NearestUsers_API            @"nearestusers"
#define UserDetails_API             @"getuserdetails"
#define SendRequest_API             @"sendrequest"
#define ChatHistory_API             @"getChatHistory"
#define UserChatHistory_API         @"getUserChatHistory"
#define SendMessage_API             @"sendmessage"
#define BlockUser_API               @"blockUser"
#define DeleteUserChat_API          @"DeleteUserChatHistory"
#define Activity                    @"activity"
#define GetConversation             @"getconversation"
#define DeleteConversation          @"deleteconversation"
#define ForgetPassword_API          @"forgetpassword"

#define Device                      @"iPhone"

#define USERDETAILS                 @"userdetails"

#define DeviceToken                 @"device_Token"

#define HobbiesArray                @"HobbiesArray"

#define matchuserrequestsend        @"sendrequest"

#define CurrentLatitude             @"current_Latitude"

#define CurrentLongitude            @"current_Longitude"

#define OnlineStatus               @"onlinestatus"

#define FirstlogininterestHobbies  @"interestHobbies"

#define FirstloginHomeview         @"Homeview"

#define FirstloginLocationView     @"LocationView"

#define FirstloginChatview         @"ChatView"

#define FirstMatchUser             @"MatchUser"

#define FirstDisplayGeneralAlterView @"AnimationHomeview"

#define FirstCreatAccount           @"FirstCreateAccount"

#define FirstCreateProfile         @"ProfileView"

#define FistSiginprofile          @"SiginProfile"

//#define FirstMatchUser            @"Matchuserlocationview"

#define FirstRegistor            @"RegistorAccount"
