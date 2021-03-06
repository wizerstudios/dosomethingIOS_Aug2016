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

//Demo URL
#define BASE_URL @"http://indiawebcoders.com/mobileapps/dosomething/"

#define URL_FOR_RESOURCE(RESOURCE) [NSString stringWithFormat:@"%@%@",BASE_URL,RESOURCE]

@interface DSWebservice : AFHTTPRequestOperationManager

+ (DSWebservice *)service;

//GET Login API

- (void)getLogin:(NSString *)loginURL
            type:(NSString *)type
           email:(NSString *)email
        password:(NSString *)password
       profileId:(NSString *)profileId
             dob:(NSString *)dob
    profileImage:(UIImage *)profileImage
          gender:(NSString *)gender
        latitude:(NSString *)latitude
       longitude:(NSString *)longitude
          device:(NSString *)device
        deviceid:(NSString *)deviceid
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
        profileImage:(UIImage *)profileImage
              gender:(NSString *)gender
            latitude:(NSString *)latitude
           longitude:(NSString *)longitude
              device:(NSString *)device
            deviceid:(NSString *)deviceid
            success:(WebserviceRequestSuccessHandler)success
             failure:(WebserviceRequestFailureHandler)failure;

//Profile Update API

- (void)profileUpdate:(NSString *)profileUpdtURL
           first_name:(NSString *)first_name
            last_name:(NSString *)last_name
                  dob:(NSString *)dob
               image1:(UIImage *)image1
               image2:(UIImage *)image2
               image3:(UIImage *)image3
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
                 success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure;

//GET NearestUsers API

-(void)nearestUsers:(NSString *)nearestUsersURL
          sessionid:(NSString *)sessionid
           latitude:(NSString *)latitude
          longitude:(NSString *)longitude
      filter_status:(NSString *)filter_status
      filter_gender:(NSString *)filter_gender
    filter_agerange:(NSString *)filter_agerange
    filter_distance:(NSString *)filter_distance
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

//Get ChatHistory API

-(void)getchatHistory:(NSString *)chatHistoryURL
        sessionid:(NSString *)sessionid
          success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure;

//Get UserChatHistory API

-(void)userChatHist:(NSString *)userChatURL
         sessionid:(NSString *)sessionid
       chat_user_id:(NSString *)chat_user_id
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure;

//POST SendMessage API

-(void)sendMessage:(NSString *)sendMessageURL
          sessionid:(NSString *)sessionid
message_send_user_id:(NSString *)message_send_user_id
           message:(NSString *)message
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

@end
