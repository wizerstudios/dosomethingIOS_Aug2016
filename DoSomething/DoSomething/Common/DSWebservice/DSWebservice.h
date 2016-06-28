//
//  Webservice.h
//  WebService
//
//  Created by ocs on 20/10/15.
//  Copyright (c) 2015 O Clock Software. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

typedef void (^WebserviceRequestSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);

typedef void (^WebserviceRequestFailureHandler)(AFHTTPRequestOperation  *operation, id error);

typedef void (^WebserviceRequestXMLSuccessHandler)(AFHTTPRequestOperation  *operation);
typedef void (^WebserviceRequestXMLFailureHandler)(AFHTTPRequestOperation  *operation, NSError *error);

//DEVELOPMENT URL
//#define BASE_URL @"http://indiawebcoders.com/mobileapps/dosomething/"

//PRODUCTION URL
#define BASE_URL @"http://mobileapp.dosomethingapp.com/"


#ifdef DEBUG
    #define push_type   @"dev"
#else
    #define push_type   @"pro"
#endif

#define URL_FOR_RESOURCE(RESOURCE) [NSString stringWithFormat:@"%@%@",BASE_URL,RESOURCE]

@interface DSWebservice : AFHTTPRequestOperationManager

+ (DSWebservice *)service;

//Homeviewlist Api

- (void)HomeviewList:(NSString *)homelist
          success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;

// Check User FB Email API
- (void)checkUserFBEmail:(NSString *)checkUserURL
                   email:(NSString *)email
                    type:(NSString *)type
                 success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;
// Check User Email API
- (void)checkUser:(NSString *)checkUserURL
            email:(NSString *)email
             type:(NSString *)type
         password:(NSString*)password
       first_name:(NSString*)first_name
        last_name:(NSString*)last_name
              dob:(NSString*)dob
           gender:(NSString*)gender
     profileImage:(NSString *)profileImage
         override:(NSString *)overrideStr
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;

// User Logout Delete API
- (void)logoutDeleteUser:(NSString *)logoutDeleteURL
               sessionId:(NSString *)sessionI
                      op:(NSString *)op
                 success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;


//GET Login API

- (void)getLogin:(NSString *)loginURL
            type:(NSString *)type
           email:(NSString *)email
        password:(NSString *)password
       profileId:(NSString *)profileId
             dob:(NSString *)dob
    profileImage:(NSString *)profileImage
          gender:(NSString *)gender
        latitude:(NSString *)latitude
       longitude:(NSString *)longitude
          device:(NSString *)device
        deviceid:(NSString *)deviceid
        pushType:(NSString *)pushType
         success:(WebserviceRequestSuccessHandler)success
         failure:(WebserviceRequestFailureHandler)failure;

//POST Register API

- (void)postRegister:(NSString *)registerURL
                type:(NSString *)type
          first_name:(NSString *)first_name
           last_name:(NSString *)last_name
               email:(NSString *)email
            password:(NSString *)password
           profileId:(NSString *)profileId
                 dob:(NSString *)dob
       profileImage1:(UIImage *)profileImage1
       profileImage2:(UIImage *)profileImage2
       profileImage3:(UIImage *)profileImage3
    IntersertHobbies:(NSString *)interestHobbies
               About:(NSString *)about
              gender:(NSString *)gender
            latitude:(NSString *)latitude
           longitude:(NSString *)longitude
              device:(NSString *)device
            deviceid:(NSString *)deviceid
      fbprofileImage:(NSString *)fbProfile
notification_message:(NSString *)isnotification_message
notification_sound:(NSString *)isnotification_sound
           isMatch:(NSString*)isMatch
               sound:(NSString *)selectSound
            pushType:(NSString *)pushType
            fbimage :(NSString *)fbimage
            success:(WebserviceRequestSuccessHandler)success
             failure:(WebserviceRequestFailureHandler)failure;

//Profile Update API

- (void)profileUpdate:(NSString *)profileUpdtURL
           first_name:(NSString *)first_name
            last_name:(NSString *)last_name
                  dob:(NSString *)dob
             password:(NSString *)password
        profileImage1:(UIImage *)profileImage1
        profileImage2:(UIImage *)profileImage2
        profileImage3:(UIImage *)profileImage3
               gender:(NSString *)gender
                about:(NSString *)about
              hobbies:(NSString *)hobbies
             latitude:(NSString *)latitude
            longitude:(NSString *)longitude
         notification:(NSString *)notification
            sessionid:(NSString *)sessionid
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;


//Location Update API

- (void)locationUpdate:(NSString *)locationUpdtURL
             sessionid:(NSString *)sessionid
              latitude:(NSString *)latitude
             longitude:(NSString *)longitude
           deviceToken:(NSString *)deviceToken
              pushType:(NSString *)pushType
               success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure;

//Get Hobbies API

-(void)getHobbies:(NSString *)getHobbiesURL
        sessionid:(NSString *)sessionid
          success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;

//DoSomething API

-(void)dosomething:(NSString *)dosomethingURL
        sessionid:(NSString *)sessionid
          success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;

//updateDoSomething API

-(void)updateDosomething:(NSString *)updatedosomethingURL
               sessionid:(NSString *)sessionid
           dosomething_id:(NSString *)dosomething_id
           available_now:(NSString *)available_now
                 success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;

//GET NearestUsers API

-(void)nearestUsers:(NSString *)nearestUsersURL
          sessionid:(NSString *)sessionid
           latitude:(NSString *)latitude
          longitude:(NSString *)longitude
      filter_status:(NSString *)filter_status
      filter_gender:(NSString *)filter_gender
   filter_available:(NSString *)filter_available
    filter_agerange:(NSString *)filter_agerange
    filter_distance:(NSString *)filter_distance
               page:(NSString *)currentpage
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure;

//Get UserDetails API

-(void)getUserDetails:(NSString *)userDetailsURL
            sessionid:(NSString *)sessionid
      profile_user_id:(NSString *)profile_user_id
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;

//POST SendRequest API

-(void)sendRequest:(NSString *)sendRequestURL
            sessionid:(NSString *)sessionid
      request_send_user_id:(NSString *)request_send_user_id
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure;

//POST CancelRequest API

-(void)cancelRequest:(NSString *)sendRequestURL
         sessionid:(NSString *)sessionid
request_send_user_id:(NSString *)request_send_user_id
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure;

//Get ChatHistory API

-(void)getchatHistory:(NSString *)chatHistoryURL
        sessionid:(NSString *)sessionid
          success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;

//Get UserChatHistory API

-(void)userChatHist:(NSString *)userChatURL
         sessionid:(NSString *)sessionid
           dateTime:(NSString *)dateTime
       //chat_user_id:(NSString *)chat_user_id
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure;

//POST SendMessage API

-(void)sendMessage:(NSString *)sendMessageURL
          sessionid:(NSString *)sessionid
message_send_user_id:(NSString *)message_send_user_id
           message:(NSString *)message
   conversation_id:(NSString *)conversationId
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure;

//Get BlockUser API

-(void)blockUser:(NSString *)blockUserURL
                sessionid:(NSString *)sessionid
             block_user_id:(NSString *)block_user_id
                  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure;

//Get DeleteUserChatHistory API

-(void)deleteUserChatHist:(NSString *)deleteUserChatURL
          sessionid:(NSString *)sessionid
       chat_user_id:(NSString *)chat_user_id
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure;

//GetActivity
-(void)getActivity:(NSString *)getActivity
      activityName:(NSString *)activityName
         sessionId:(NSString *)sessionID
      availableNow:(NSString *)available_now
     doSomethingId:(NSString *)dosomethingID
    success:(WebserviceRequestSuccessHandler)success
    failure:(WebserviceRequestFailureHandler)failure;

//ForgotPassword_API
-(void)forgetPasswordRequest:(NSString *)forgotPasswordRequestURL
                       email:(NSString *)email
                     success:(WebserviceRequestSuccessHandler)success
                     failure:(WebserviceRequestFailureHandler)failure;



//Update Notification API

-(void)updateNotification:(NSString *)notificationUpdate
                sessionID:(NSString *)sessionId
               messageStr:(NSString *)messageStr
                 soundstr:(NSString *)soundStr
                    match:(NSString *)domatch
                    sound:(NSString *)soundType
                  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure;

// Chat Conversation

-(void)getConversation:(NSString *)getConversation
             sessionID:(NSString *)sessionID
        conversationId:(NSString *)conversationId
              dateTime:(NSString *)dateTime
               success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure;

-(void)cancelRequest;

-(void)getMatchuserrequestSend:(NSString *)matchuserrequest
                     sessionid:(NSString *)sessionid
               requestsenduser:(NSString *)resquestsenduserid
                    chartstart:(NSString *)chatstart
                       success:(WebserviceRequestSuccessHandler)success
                       failure:(WebserviceRequestFailureHandler)failure;

// OnlineStatus
-(void)getOnlinstatus:(NSString *)onlineStatus
            sessionID:(NSString *)sessionID
               status:(NSString *)status
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;


-(void)getDeleteprofileImage:(NSString *)deleteprofileImage
                   sessionID:(NSString *)sessionid
                   Fieldimage:(NSString *)fieldimage
                     success:(WebserviceRequestSuccessHandler)success
                     failure:(WebserviceRequestFailureHandler)failure;


-(void)getCheckrequeststatus:(NSString *) checkrequest
          requestsenduserid :(NSString *) requestsenduserid
                   sessionID:(NSString *) sessionid
                     success:(WebserviceRequestSuccessHandler)success
                     failure:(WebserviceRequestFailureHandler)failure;
@end
