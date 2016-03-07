//
//  Webservice.m
//  WebService
//
//  Created by ocs on 20/10/15.
//  Copyright (c) 2015 O Clock Software. All rights reserved.
//

#import "DSWebservice.h"
#import "AFNetworking.h"
#import "DSConfig.h"
#import "HomeViewController.h"
#import "DSAppCommon.h"

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
       first_name:(NSString*)first_name
        last_name:(NSString*)last_name
              dob:(NSString*)dob
           gender:(NSString*)gender
     profileImage:(NSString *)profileImage
              success:(WebserviceRequestSuccessHandler)success
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",checkUserURL]];
    
    NSMutableDictionary *checkUserDetails = [[NSMutableDictionary alloc] init];
    
    if(type)               [checkUserDetails    setObject:type             forKey:@"type"];
    if(email)              [checkUserDetails    setObject:email            forKey:@"email"];
    if(first_name)         [checkUserDetails    setObject:first_name       forKey:@"first_name"];
    if(last_name)          [checkUserDetails    setObject:last_name        forKey:@"last_name"];
    if(dob)                [checkUserDetails    setObject:dob              forKey:@"dob"];
    if(gender)             [checkUserDetails    setObject:gender           forKey:@"gender"];
    if(profileImage)       [checkUserDetails    setObject:profileImage     forKey:@"profileImage"];

    
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"checkUserDetails = %@",checkUserDetails);
    
    [self sendRequestWithURLString:urlString
                     andParameters:checkUserDetails
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}
#pragma mark - POST LogoutDeleteUser

- (void)logoutDeleteUser:(NSString *)logoutDeleteURL
               sessionId:(NSString *)sessionId
                      op:(NSString *)op
                 success:(WebserviceRequestSuccessHandler)success
                 failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",logoutDeleteURL]];
    
    NSMutableDictionary *userLogoutDelete = [[NSMutableDictionary alloc] init];
    
    if(sessionId)       [userLogoutDelete    setObject:sessionId     forKey:@"sessionid"];
    if(op)              [userLogoutDelete    setObject:op            forKey:@"op"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"userlogout = %@",userLogoutDelete);
    
    [self sendRequestWithURLString:urlString
                     andParameters:userLogoutDelete
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
        pushType:(NSString *)pushType
         success:(WebserviceRequestSuccessHandler)success
         failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?type=%@&email=%@&password=%@&profileId=%@&dob=%@&profileImage=%@&gender=%@&latitude=%@&longitude=%@&device=%@&deviceid=%@&push_type=%@",loginURL,type,email,password,profileId,dob,profileImage,gender,latitude,longitude,device,deviceid,pushType]];
    
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
notification_sound  :(NSString *)isnotification_sound
             isMatch:(NSString *)isMatch
               sound:(NSString *)selectSound
            pushType:(NSString *)pushType
            fbimage :(NSString *)fbimage
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
    if(gender)                  [registerDetails    setObject:gender                forKey:@"gender"];
    if(interestHobbies)         [registerDetails    setObject:interestHobbies       forKey:@"hobbies"];
    if(about)                   [registerDetails    setObject:about                 forKey:@"about"];
                                [registerDetails    setObject:latitude              forKey:@"latitude"];
                                [registerDetails    setObject:longitude             forKey:@"longitude"];
    if(device)                  [registerDetails    setObject:device                forKey:@"device"];
    if(deviceid)                [registerDetails    setObject:deviceid              forKey:@"deviceid"];
    if(isnotification_message)  [registerDetails    setObject:isnotification_message forKey:@"notification_message"];
    if(isnotification_sound)    [registerDetails    setObject:isnotification_sound  forKey:@"notification_sound"];
    if(isMatch)[registerDetails    setObject:isMatch  forKey:@"isMatch"];
    if(pushType) [registerDetails setObject:pushType forKey:@"push_type"];
    if(fbimage)  [registerDetails setObject:fbimage forKey:@"fbimage"];
    if(fbProfile)  [registerDetails setObject:fbProfile forKey:@"profileImage1"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    NSLog(@"Registerdeteils%@",registerDetails);
     NSLog(@"RegisterdeteilsUrl = %@",urlString);
    [self POST:urlString parameters:registerDetails constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if(profileImage1){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImage1)
                                         name:@"profileImage1"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
        
                  
         if(profileImage2){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImage2)
                                         name:@"profileImage2"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         if(profileImage3){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImage3)
                                         name:@"profileImage3"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         
     }
     
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([type  isEqual: @"2"]){
             NSLog(@"responseObject = %@",responseObject);
             
             NSMutableDictionary *registerDict = [[NSMutableDictionary alloc]init];
             
             registerDict = [responseObject valueForKey:@"register"];
             
             if([[registerDict valueForKey:@"status"]isEqualToString:@"success"]){
                 
                 [COMMON setUserDetails:[[registerDict valueForKey:@"userDetails"]objectAtIndex:0]];
                 NSLog(@"userdetails = %@",[COMMON getUserDetails]);
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"registerform"
                                                                     object:self
                                                                   userInfo:responseObject];
                // [self gotoHomeView];
             }
             else{
                 NSLog(@"responseObject = %@",responseObject);
                 NSString *errMsg = [NSString stringWithFormat:@"%@",[registerDict valueForKey:@"Message"]];
                 errMsg = [errMsg stringByReplacingOccurrencesOfString:@"{" withString:@""];
                 errMsg = [errMsg stringByReplacingOccurrencesOfString:@"}" withString:@""];
                
                 
             }
             
         }
         else{
         NSLog(@"rsponse:%@",responseObject);
         NSMutableDictionary *registerDict = [[NSMutableDictionary alloc]init];
         registerDict = [responseObject valueForKey:@"register"];
         if([[registerDict valueForKey:@"status"]isEqualToString:@"success"]){
             [COMMON setUserDetails:[[registerDict valueForKey:@"userDetails"]objectAtIndex:0]];
             NSLog(@"userdetails = %@",[COMMON getUserDetails]);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"registerform"
                                                                 object:self
                                                               userInfo:responseObject];
         }
         }
     }
     
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           
//           UIAlertView * objAltert =[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//           [objAltert show];
           NSLog(@"Error = %@",error);

       }];
        
}

#pragma mark - POST profile update

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
              failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",profileUpdtURL]];
    
    NSMutableDictionary *profileUpdate = [[NSMutableDictionary alloc] init];

    if(first_name)         [profileUpdate    setObject:first_name                 forKey:@"first_name"];
    if(last_name)          [profileUpdate    setObject:last_name                  forKey:@"last_name"];
    if(dob)                [profileUpdate    setObject:dob                        forKey:@"dob"];
    if(gender)             [profileUpdate    setObject:gender                     forKey:@"gender"];
    if(about)              [profileUpdate    setObject:about                      forKey:@"about"];
    if(hobbies)            [profileUpdate    setObject:hobbies                    forKey:@"hobbies"];
    if(password)           [profileUpdate    setObject:password                   forKey:@"password"];
                           [profileUpdate    setObject:latitude                   forKey:@"latitude"];
                           [profileUpdate    setObject:longitude                  forKey:@"longitude"];
    if(notification)       [profileUpdate    setObject:notification               forKey:@"notification"];
    if(sessionid)          [profileUpdate    setObject:sessionid                  forKey:@"sessionid"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"Profile Update = %@",profileUpdate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageNameStr = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
    NSLog(@"ProfileUpdatedetails%@",profileUpdate);
    [self POST:urlString parameters:profileUpdate constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         
         if(profileImage1){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImage1)
                                         name:@"profileImage1"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         if(profileImage2){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImage2)
                                         name:@"profileImage2"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
         if(profileImage3){
             [formData appendPartWithFileData:UIImagePNGRepresentation(profileImage3)
                                         name:@"profileImage3"
                                     fileName:imageNameStr
                                     mimeType:@"image/png"];
             
             NSLog(@"formData = %@",formData);
         }
     }

       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"UPDATEresponseObject = %@",responseObject);
         
         
         NSMutableDictionary *profileUpdateDict = [[NSMutableDictionary alloc]init];
         profileUpdateDict = [responseObject valueForKey:@"updateprofile"];
         if([[profileUpdateDict valueForKey:@"status"]isEqualToString:@"success"]){
             [COMMON setUserDetails:[[profileUpdateDict valueForKey:@"userDetails"]objectAtIndex:0]];
             NSLog(@"userdetails = %@",[COMMON getUserDetails]);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateprofile"object:self userInfo:responseObject];

         }
         else {
           
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateprofileLogOut"object:self userInfo:responseObject];
             
         }

         [[NSNotificationCenter defaultCenter]postNotificationName:@"profilesuccess"object:self userInfo:nil];

         [COMMON removeLoading];

     }
     
       failure:^(AFHTTPRequestOperation *operation, NSError *error){
           NSLog(@"Error = %@",error);
           [COMMON removeLoading];
          
       }];


}

#pragma mark - POST Location Update

- (void)locationUpdate:(NSString *)locationUpdtURL
             sessionid:(NSString *)sessionid
              latitude:(NSString *)latitude
             longitude:(NSString *)longitude
           deviceToken:(NSString *)deviceToken
              pushType:(NSString *)pushType
               success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure
{
   urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",locationUpdtURL]];
    NSLog(@"urlString = %@",urlString);
    NSMutableDictionary *locationUpdate = [[NSMutableDictionary alloc] init];
    
             [locationUpdate    setObject:sessionid                 forKey:@"sessionid"];
             [locationUpdate    setObject:latitude                  forKey:@"latitude"];
             [locationUpdate    setObject:longitude                 forKey:@"longitude"];
             [locationUpdate    setObject:deviceToken               forKey:@"device_token"];
             [locationUpdate    setObject:pushType                 forKey:@"push_type"];
    
    NSLog(@"locationUpdate = %@",locationUpdate);
    
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
            dosomething_id:(NSString *)dosomething_id
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
   filter_available:(NSString *)filter_available
    filter_agerange:(NSString *)filter_agerange
    filter_distance:(NSString *)filter_distance
               page:(NSString *)currentpage
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&latitude=%@&longitude=%@&filter_status=%@&filter_gender=%@&filter_agerange=%@&filter_distance=%@&filter_available=%@&page=%@",nearestUsersURL,sessionid,latitude,longitude,filter_status,filter_gender,filter_agerange,filter_distance,filter_available,currentpage]];
    
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
          dateTime:(NSString *)dateTime
       //chat_user_id:(NSString *)chat_user_id
            success:(WebserviceRequestSuccessHandler)success
            failure:(WebserviceRequestFailureHandler)failure
{
    //urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&chat_user_id%@",userChatURL,sessionid,chat_user_id]];
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&datetime=%@",userChatURL,sessionid,dateTime]];
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
   conversation_id:(NSString *)conversationId
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",sendMessageURL]];
    
    NSMutableDictionary *msgDict = [[NSMutableDictionary alloc] init];
    
    if(sessionid)               [msgDict setObject:sessionid forKey:@"sessionid"];
    if(message_send_user_id)    [msgDict setObject:message_send_user_id forKey:@"message_receiver_id"];
                               [msgDict setObject:message forKey:@"message"];
     if(conversationId)        [msgDict setObject:conversationId forKey:@"conversation_id"];
    
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"SendMessage = %@",msgDict);
    
    [self sendRequestWithURLString:urlString
                     andParameters:msgDict
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
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&conversationId=%@",blockUserURL,sessionid,block_user_id]];
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
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&conversationId=%@",deleteUserChatURL,sessionid,chat_user_id]];
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];

}

#pragma mark - Get Activity

-(void)getActivity:(NSString *)getActivity
      activityName:(NSString *)activityName
         sessionId:(NSString *)sessionID
      availableNow:(NSString *)available_now
     doSomethingId:(NSString *)dosomethingID
           success:(WebserviceRequestSuccessHandler)success
           failure:(WebserviceRequestFailureHandler)failure{
    
    if([activityName isEqualToString:@"update"])
        urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?op=%@&sessionid=%@&available_now=%@&dosomething_id=%@",getActivity,activityName,sessionID,available_now,dosomethingID]];
    else
        urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?op=%@&sessionid=%@",getActivity,activityName,sessionID]];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}
#pragma mark - Update Notification

-(void)updateNotification:(NSString *)notificationUpdate
                sessionID:(NSString *)sessionId
               messageStr:(NSString *)messageStr
                 soundstr:(NSString *)soundStr
                    match:(NSString *)domatch
                    sound:(NSString *)soundType
                  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure{
    
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&notification_message=%@&notification_sound=%@&do_match=%@&sound=%@",notificationUpdate,sessionId,messageStr,soundStr,domatch,soundType]];
    
    NSLog(@"urlStringnotification = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}

#pragma mark - Get Chat Conversation
-(void)getConversation:(NSString *)getConversation
             sessionID:(NSString *)sessionID
        conversationId:(NSString *)conversationId
              dateTime:(NSString *)dateTime
               success:(WebserviceRequestSuccessHandler)success
               failure:(WebserviceRequestFailureHandler)failure{
    
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&conversationId=%@&datetime=%@",getConversation,sessionID,conversationId,dateTime]];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];
    
}
#pragma onlineStatus
-(void)getOnlinstatus:(NSString *)onlineStatus sessionID:(NSString *)sessionID status:(NSString *)status success:(WebserviceRequestSuccessHandler)success failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&status=%@",onlineStatus,sessionID,status]];
    
    NSLog(@"urlString = %@",urlString);
    
    [self sendRequestWithURLString:urlString
                     andParameters:nil
                            method:ServiceGet
           completionSucessHandler:success
          completionFailureHandler:failure];

}

#pragma mark POST forgetPasswordRequest

-(void)forgetPasswordRequest:(NSString *)forgotPasswordRequestURL
                       email:(NSString *)email
                     success:(WebserviceRequestSuccessHandler)success
                     failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?",forgotPasswordRequestURL]];
    
    NSMutableDictionary *sendRequest = [[NSMutableDictionary alloc] init];
    
    if(email)               [sendRequest    setObject:email                 forKey:@"email"];
    
    NSLog(@"urlString = %@",urlString);
    NSLog(@"forgotPasswordRequest = %@",sendRequest);
    
    [self sendRequestWithURLString:urlString
                     andParameters:sendRequest
                            method:ServicePost
           completionSucessHandler:success
          completionFailureHandler:failure];
}

-(void)getMatchuserrequestSend:(NSString *)matchuserrequest sessionid:(NSString *)sessionid requestsenduser:(NSString *)resquestsenduserid chartstart:(NSString *)chatstart success:(WebserviceRequestSuccessHandler)success failure:(WebserviceRequestFailureHandler)failure
{
    urlString = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@?sessionid=%@&request_send_user_id=%@&chatstart=%@",matchuserrequest,sessionid,resquestsenduserid,chatstart]];
    
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
             if (sucesshandler){
                 if([responseDict objectForKey:@"error"]){
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidSession"object:self userInfo:responseDict];
                 }
                 sucesshandler(operation,responseDict);
             }
         }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (failurehandler){
                  NSLog(@"response ");
                 failurehandler(operation, error);
             }
         }];
    }
    else
    {
        [self POST:url parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseDict)
         {
             if (sucesshandler){
                 if([responseDict objectForKey:@"error"]){
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidSession"object:self userInfo:responseDict];
                 }
                 sucesshandler(operation,responseDict);
             }
         }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (failurehandler) failurehandler(operation,error);
         }];
    }
}

-(void)cancelRequest
{
    [self.operationQueue cancelAllOperations];
}


@end
