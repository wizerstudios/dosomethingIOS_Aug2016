//
//  Webservice.m
//  WebService
//
//  Created by ocs on 20/10/15.
//  Copyright (c) 2015 O Clock Software. All rights reserved.
//

#import "DSWebservice.h"
#import "AFNetworking.h"

static const NSString *ServicePost   = @"POST";
static const NSString *ServiceGet    = @"GET";
static const NSString *ServicePut    = @"PUT";
static const NSString *ServiceDelete = @"DELETE";

static const NSString *ServiceContentJSON = @"application/json";
static const NSString *ServiceContentFORM = @"application/x-www-form-urlencoded";
static NSString       *ServiceMimeType    = @"image/jpeg";

@interface DSWebservice ()
{
    NSString *urlString;
}
@end

@implementation DSWebservice

- (id)init {
    self = [super init];
    if (self) {
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json",@"image/png",nil];
    }
    return self;
}

+ (DSWebservice *)service {
    return [[DSWebservice alloc] init];
}
#pragma mark - get homelist
-(void)HomeviewList:(NSString *)homelist
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure
{
     urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",homelist]];
    NSLog(@"urlString = %@",urlString);
   
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark - POST checkUser

- (void)checkUser:(NSString *)checkUserURL
                email:(NSString *)email
                 type:(NSString *)type
         password:(NSString*)password
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",checkUserURL]];
    
    NSMutableDictionary *checkUserDetails = [[NSMutableDictionary alloc] init];
    
    if(type)               [checkUserDetails    setObject:type             forKey:@"type"];
    if(email)              [checkUserDetails    setObject:email            forKey:@"email"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"checkUserDetails = %@",checkUserDetails);
    
    [self sendRequestWithURLString:urlString
                     andParameters:checkUserDetails
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}


#pragma mark - GET Login

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
         success:(WebserviceRequestSuccessHandler)success
         failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?type=%@&email=%@&password=%@&profileId=%@&dob=%@&profileImage=%@&gender=%@&latitude=%@&longitude=%@&device=%@&deviceid=%@",loginURL,type,email,password,profileId,dob,profileImage,gender,latitude,longitude,device,deviceid]];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

#pragma mark - POST Register

- (void)postRegister:(NSString *)registerURL
                type:(NSString *)type
          first_name:(NSString *)first_name
           last_name:(NSString *)last_name
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
notification_message:(BOOL)isnotification_message
notification_sound  :(BOOL)isnotification_sound
notification_vibration:(BOOL)isnotification_vibration
             success:(WebserviceRequestSuccessHandler)success
             failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",registerURL]];
    
    NSMutableDictionary *registerDetails = [[NSMutableDictionary alloc] init];
    
    if(type)                    [registerDetails    setObject:type                  forKey:@"type"];
    if(first_name)              [registerDetails    setObject:first_name            forKey:@"first_name"];
    if(last_name)               [registerDetails    setObject:last_name             forKey:@"last_name"];
    if(email)                   [registerDetails    setObject:email                 forKey:@"email"];
    if(password)                [registerDetails    setObject:password              forKey:@"password"];
    if(profileId)               [registerDetails    setObject:profileId             forKey:@"profileId"];
    if(dob)                     [registerDetails    setObject:dob                   forKey:@"dob"];
    if(profileImage)            [registerDetails    setObject:profileImage          forKey:@"profileImage"];
    if(gender)                  [registerDetails    setObject:gender                forKey:@"gender"];
    if(latitude)                [registerDetails    setObject:latitude              forKey:@"latitude"];
    if(longitude)               [registerDetails    setObject:longitude             forKey:@"longitude"];
    if(device)                  [registerDetails    setObject:device                forKey:@"device"];
    if(deviceid)                [registerDetails    setObject:deviceid              forKey:@"deviceid"];
    if(isnotification_message)  [registerDetails    setObject:[NSNumber numberWithBool:isnotification_message]  forKey:@"notification_message"];
    if(isnotification_sound)    [registerDetails    setObject:[NSNumber numberWithBool:isnotification_sound]  forKey:@"notification_sound"];
    if(isnotification_vibration)[registerDetails    setObject:[NSNumber numberWithBool:isnotification_vibration]  forKey:@"notification_vibration"];
    
    
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"Register Details = %@",registerDetails);
    
    [self sendRequestWithURLString:urlString
                     andParameters:registerDetails
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

#pragma mark - POST profile update

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
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",profileUpdtURL]];
    
    NSMutableDictionary *profileUpdate = [[NSMutableDictionary alloc] init];

    if(first_name)         [profileUpdate    setObject:first_name                 forKey:@"first_name"];
    if(last_name)          [profileUpdate    setObject:last_name                  forKey:@"last_name"];
    if(dob)                [profileUpdate    setObject:dob                        forKey:@"dob"];
    if(image1)             [profileUpdate    setObject:image1                     forKey:@"image1"];
    if(image2)             [profileUpdate    setObject:image2                     forKey:@"image2"];
    if(image3)             [profileUpdate    setObject:image3                     forKey:@"image3"];
    if(gender)             [profileUpdate    setObject:gender                     forKey:@"gender"];
    if(about)              [profileUpdate    setObject:about                      forKey:@"about"];
    if(hobbies)            [profileUpdate    setObject:hobbies                    forKey:@"hobbies"];
    if(latitude)           [profileUpdate    setObject:latitude                   forKey:@"latitude"];
    if(longitude)          [profileUpdate    setObject:longitude                  forKey:@"longitude"];
    if(notification)       [profileUpdate    setObject:notification               forKey:@"notification"];
    if(sessionid)          [profileUpdate    setObject:sessionid                  forKey:@"sessionid"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"Profile Update = %@",profileUpdate);
    
    [self sendRequestWithURLString:urlString
                     andParameters:profileUpdate
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];


}

#pragma mark - POST Location Update

- (void)locationUpdate:(NSString *)locationUpdtURL
             sessionid:(NSString *)sessionid
              latitude:(NSString *)latitude
             longitude:(NSString *)longitude
               success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure
{
   urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",locationUpdtURL]];
    
    NSMutableDictionary *locationUpdate = [[NSMutableDictionary alloc] init];
    
    if(sessionid)         [locationUpdate    setObject:sessionid                 forKey:@"sessionid"];
    if(latitude)          [locationUpdate    setObject:latitude                  forKey:@"latitude"];
    if(longitude)         [locationUpdate    setObject:longitude                 forKey:@"longitude"];

    NSLog(@"urlString = %@",urlString);
    NSLog(@"Location Update = %@",locationUpdate);
    
    [self sendRequestWithURLString:urlString
                     andParameters:locationUpdate
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];

}

#pragma mark- GET Hobbies

-(void)getHobbies:(NSString *)getHobbiesURL
        sessionid:(NSString *)sessionid
          success:(WebserviceRequestSuccessHandler)success
          failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@",getHobbiesURL,sessionid]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
  }

#pragma mark- GET DoSomething

-(void)dosomething:(NSString *)dosomethingURL
         sessionid:(NSString *)sessionid
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@",dosomethingURL,sessionid]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark - POST updateDoSomething

- (void) updateDosomething:(NSString *)updatedosomethingURL
                 sessionid:(NSString *)sessionid
            dosomething_id:(NSArray *)dosomething_id
            available_now :(NSString *)available_now
                   success:(WebserviceRequestSuccessHandler)success
                   failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",updatedosomethingURL]];
    
    NSMutableDictionary *updateDosomething = [[NSMutableDictionary alloc] init];
    
    if(sessionid)         [updateDosomething    setObject:sessionid                 forKey:@"sessionid"];
    if(dosomething_id)    [updateDosomething    setObject:dosomething_id            forKey:@"dosomething_id"];
    if(available_now)     [updateDosomething    setObject:available_now  forKey:@"available_now"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"UpdateDoSomething = %@",updateDosomething);
    
    [self sendRequestWithURLString:urlString
                     andParameters:updateDosomething
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark- GET NearestUsers

-(void)nearestUsers:(NSString *)nearestUsersURL
          sessionid:(NSString *)sessionid
           latitude:(NSString *)latitude
          longitude:(NSString *)longitude
      filter_status:(NSString *)filter_status
      filter_gender:(NSString *)filter_gender
    filter_agerange:(NSString *)filter_agerange
    filter_distance:(NSString *)filter_distance
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&latitude=%@&longitude=%@&filter_status=%@&filter_gender=%@&filter_agerange=%@&filter_distance=%@",nearestUsersURL,sessionid,latitude,longitude,filter_status,filter_gender,filter_agerange,filter_distance]];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark- GET UserDetails

-(void)getUserDetails:(NSString *)userDetailsURL
            sessionid:(NSString *)sessionid
      profile_user_id:(NSString *)profile_user_id
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure;

{
    
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&profile_user_id=%@",userDetailsURL,sessionid,profile_user_id]];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark POST SendRequest

-(void)sendRequest:(NSString *)sendRequestURL
         sessionid:(NSString *)sessionid
request_send_user_id:(NSString *)request_send_user_id
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",sendRequestURL]];
    
    NSMutableDictionary *sendRequest = [[NSMutableDictionary alloc] init];
    
    if(sessionid)               [sendRequest    setObject:sessionid                 forKey:@"sessionid"];
    if(request_send_user_id)    [sendRequest    setObject:request_send_user_id            forKey:@"request_send_user_id"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"UpdateDoSomething = %@",sendRequest);
    
    [self sendRequestWithURLString:urlString
                     andParameters:sendRequest
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark GET ChatHistory

-(void)getchatHistory:(NSString *)chatHistoryURL
            sessionid:(NSString *)sessionid
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@",chatHistoryURL,sessionid]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark GET UserChatHistory

-(void)userChatHist:(NSString *)userChatURL
          sessionid:(NSString *)sessionid
       chat_user_id:(NSString *)chat_user_id
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&chat_user_id%@",userChatURL,sessionid,chat_user_id]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark POST SendMessage

-(void)sendMessage:(NSString *)sendMessageURL
         sessionid:(NSString *)sessionid
message_send_user_id:(NSString *)message_send_user_id
           message:(NSString *)message
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",sendMessageURL]];
    
    NSMutableDictionary *sendMessg = [[NSMutableDictionary alloc] init];
    
    if(sessionid)               [sendMessg    setObject:sessionid                 forKey:@"sessionid"];
    if(message_send_user_id)    [sendMessg    setObject:message_send_user_id            forKey:@"message_send_user_id"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"SendMessage = %@",sendMessg);
    
    [self sendRequestWithURLString:urlString
                     andParameters:sendMessg
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark GET BlockUser

-(void)blockUser:(NSString *)blockUserURL
       sessionid:(NSString *)sessionid
   block_user_id:(NSString *)block_user_id
         success:(WebserviceRequestSuccessHandler)success
         failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&chat_user_id%@",blockUserURL,sessionid,block_user_id]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
}

#pragma mark GET deleteUserChatHist

-(void)deleteUserChatHist:(NSString *)deleteUserChatURL
                sessionid:(NSString *)sessionid
             chat_user_id:(NSString *)chat_user_id
                  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&chat_user_id%@",deleteUserChatURL,sessionid,chat_user_id]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];

}


#pragma mark - Helpers

- (void)sendRequestWithURLString:(NSString *)url
                   andParameters:(NSDictionary *)parameters
                          method:(const NSString *)method
         completionSucessHandler:(WebserviceRequestSuccessHandler)sucesshandler
        completionFailureHandler:(WebserviceRequestFailureHandler)failurehandler
{
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (method == ServiceGet)
    {
        [self GET:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseDict)
         {
             if (sucesshandler) sucesshandler(operation,responseDict);
         }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (failurehandler) failurehandler(operation, error);
         }];
    }
    else
    {
        [self POST:url parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseDict)
         {
             if (sucesshandler) sucesshandler(operation,responseDict);
         }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (failurehandler) failurehandler(operation,error);
         }];
    }
}


@end
