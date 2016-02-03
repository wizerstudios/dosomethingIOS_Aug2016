//
//  DSChatsTableViewController.m
//  DoSomething
//
//  Created by ocsdeveloper9 on 10/28/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSChatsTableViewController.h"
#import "ChatTableViewCell.h"
#import "DSChatDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSWebservice.h"
#import "DSAppCommon.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"


@interface DSChatsTableViewController ()

{
    UIButton *navButton;
    NSString * currentLatitude, * currentLongitude;
    DSWebservice *webService;
    NSMutableArray *chatArray;
    NSUInteger isSupportUser;
    UIRefreshControl            * refreshControl;
    AppDelegate *appDelegate;
    BOOL _isStartTimer;
    
}

@end

@implementation DSChatsTableViewController
@synthesize ChatTableView,locationManager,messageTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    chatArray = [[NSMutableArray alloc]init];
    webService = [[DSWebservice alloc]init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(releaseToRefresh:) forControlEvents:UIControlEventValueChanged];
    [ChatTableView addSubview:refreshControl];

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"backAction"];
    
     [self getUserCurrenLocation];
    
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ChatTableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:20.0]];
    
   
    [COMMON LoadIcon:self.view];

   
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadChatHistoryAPI];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [self setNavigation];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    _isStartTimer = YES;
    
    [self startTimer];

}

-(void)startTimer{
    
    if(messageTimer == nil)
        messageTimer = [NSTimer scheduledTimerWithTimeInterval:timerSeconds target:self selector:@selector(loadChatHistoryAPI) userInfo:nil repeats:YES];

}

-(void)stopTimer{
    
    if(messageTimer){
      [messageTimer invalidate];
       messageTimer =nil;
    }
    
}

-(void)viewwillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _isStartTimer = NO;

    [self stopTimer];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
     [super viewDidDisappear:animated];
    
    _isStartTimer = NO;

    [self stopTimer];
    
}


- (void)setNavigation
{
    CustomNavigationView *customNavigation;
    
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    
    if (IS_IPHONE6 )
        
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
    
    if(IS_IPHONE6_Plus)
        
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
    
    [customNavigation.menuBtn setHidden:YES];
    
    [customNavigation.buttonBack setHidden:YES];
    
    [customNavigation.saveBtn setHidden:YES];
    
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    //    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    //    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)releaseToRefresh:(UIRefreshControl *)_refreshControl
{
    [self loadChatHistoryAPI];
}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
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
    
    [locationManager stopUpdatingLocation];
    
    NSString *savedLatitude =  [[NSUserDefaults standardUserDefaults]valueForKey:CurrentLatitude];
    NSString *savedLongitude = [[NSUserDefaults standardUserDefaults]valueForKey:CurrentLongitude];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    NSLog(@"savedLatitude & saved Longitude = %@ & %@",savedLatitude,savedLongitude);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if((![currentLatitude isEqualToString:savedLatitude] || ![currentLongitude isEqualToString:savedLongitude]) && (currentLongitude !=nil || currentLatitude != nil))
            [self loadLocationUpdateAPI];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
        });
        
    });
    
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
}



#pragma mark - TableView Datasources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *Cell;
    
    static NSString *identifier = @"Mycell";
    
    Cell = (ChatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    if (!Cell)
        
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:nil options:nil];
        
        Cell = [nib objectAtIndex:0];
        
        
    }
    [Cell.activeIndicator setHidden:NO];
    [Cell.activeIndicator startAnimating];
    NSMutableDictionary *chatDict = [chatArray objectAtIndex:indexPath.row];
    
    isSupportUser = [[chatDict valueForKey:@"supportuser"]integerValue];
    
    Cell.ChatName .text = [chatDict valueForKey:@"Name"];
    
    Cell.Message.text= [chatDict valueForKey:@"LastMessage"];
    
    
    
    NSString *timeStr = [chatDict valueForKey:@"LastMessageSentTime"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormat dateFromString:timeStr];
        
    [dateFormat setDateFormat:@"hh:mm"];
    
    timeStr = [dateFormat stringFromDate:date];
    
    Cell.Time.text = timeStr;
    
    
    NSString *ProfileName=[NSString stringWithFormat:@"%@",[chatDict valueForKey:@"image1"]];
    
    NSLog(@"ProfileName = %@",ProfileName);
    
    if([ProfileName length]>0){
         [Cell.profileImageView setImageWithURL:[NSURL URLWithString:ProfileName]];
        
    }
    else{
        [Cell.profileImageView setImage:[UIImage imageNamed:@"profile_noimg.png"]];
         [Cell.activeIndicator setHidden:YES];
    }
    
    [Cell.profileImageView.layer setCornerRadius:29];
    
    if(isSupportUser == 1){
        
        [Cell.profileImageView.layer setMasksToBounds:YES];
        
        [Cell.profileImageView.layer setBorderWidth:2.0f];
        
        [Cell.profileImageView.layer setBorderColor:[[UIColor colorWithRed:229.0f/255.0f green:63.0f/255.0f blue:81.0f/255.0f alpha:1.0f] CGColor]];
        
    }

    
    NSUInteger msgCount = [[chatDict valueForKey:@"unreadmessage"]integerValue];
    
  //  msgCount = 3;
        
    if(msgCount > 0){
        
        [Cell.msgCountLabel setHidden:NO];
        
        [Cell.msgCountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)msgCount]];
        
        [Cell.msgCountLabel.layer setCornerRadius:10];
      
        Cell.msgCountLabel.clipsToBounds = YES;
        
    }
    
    else
        
        [Cell.msgCountLabel setHidden:YES];
    
    
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    ChatTableView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    return Cell;
}

#pragma edit TableViewCell

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [chatArray removeObjectAtIndex:indexPath.row];
        [ChatTableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *chatDict = [chatArray objectAtIndex:indexPath.row];
    
    isSupportUser = [[chatDict valueForKey:@"supportuser"]integerValue];
    
    if(isSupportUser == 0)
        return YES;
    
    else
        return NO;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
         NSMutableArray*objselectuser = [chatArray objectAtIndex:indexPath.row];
        NSString *userid=[objselectuser valueForKey:@"id"];
        [self loadblockUser:userid];
        [self.ChatTableView setEditing:YES];
        
        
    }];
    
    
    [blockButton.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Patron-Regular" size:11.0]}];
    
    blockButton.backgroundColor =[UIColor colorWithRed:0.465f green:0.465f blue:0.465f alpha:1.0f] ;
    
    
    UITableViewRowAction *deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
         NSLog(@"index:%ld",(long)indexPath.row);
        NSInteger row = indexPath.row;
       
       // NSInteger* selectIndex= &row;
        NSMutableArray*objselectuser = [chatArray objectAtIndex:indexPath.row];
        NSString *userid=[objselectuser valueForKey:@"id"];
        //[timeArray objectAtIndex:indexPath.row];
        [self loadDeleteUserChatHistory:userid :row];
        //[self.ChatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }];
    
    [deleteButton.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Patron-Regular" size:11.0]}];
    
    deleteButton.backgroundColor =[UIColor colorWithRed:(230/255.0) green:(63/255.0) blue:(82/255.0) alpha:1];
    
    
    
    return @[deleteButton,blockButton];}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[chatArray objectAtIndex:indexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:@"0" forKey:@"unreadmessage"];
    [chatArray replaceObjectAtIndex:indexPath.row withObject:newDict];
    [self loadTabbarMsgCount];
    
    DSChatDetailViewController *ChatDetail =[[DSChatDetailViewController alloc]initWithNibName:nil bundle:nil];
    
    ChatDetail.chatuserDetailsDict = [chatArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:ChatDetail animated:YES];
    
}

#pragma mark - WebService

-(void)loadLocationUpdateAPI{
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DeviceToken];
    if(deviceToken == nil)
        deviceToken = @"";
    
    [webService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                 deviceToken:deviceToken pushType:push_type
                       success:^(AFHTTPRequestOperation *operation, id responseObject){
                           NSLog(@"responseObject = %@",responseObject);
                           if([[responseObject valueForKey:@"status"]isEqualToString:@"success"]){
                               [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:CurrentLatitude];
                               [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:CurrentLongitude];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, id error) {
                           
                       }];
    
    
}

-(void)loadChatHistoryAPI{
    
    [self stopTimer];
    
    [webService userChatHist:ChatHistory_API sessionid:[COMMON getSessionID] dateTime:[COMMON getCurrentDateTime]
                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                         
                         
                         if(_isStartTimer == YES)
                              [self startTimer];
                         
                         NSLog(@"responseObject = %@",responseObject);
                         if([[[responseObject valueForKey:@"getchathistory"] valueForKey:@"status"]isEqualToString:@"success"]){
                         
                             chatArray = [[[responseObject valueForKey:@"getchathistory"]valueForKey:@"converation"] mutableCopy];
                             
                             [self loadTabbarMsgCount];
                                                     
                             [refreshControl endRefreshing];
                             
                             [ChatTableView reloadData];
                         }
                         
                         [COMMON removeLoading];
                                                  
                     }
     
                     failure:^(AFHTTPRequestOperation *operation, id error) {
                         [COMMON removeLoading];
                         
                     }];
    
    
}


#pragma deleteuserchatdetails, Blockuser
-(void)loadDeleteUserChatHistory:(NSString*) deleteuserID :(NSInteger)selectIndex
{
     NSLog(@"selectIndex:%ld",(long)selectIndex);
    
    [webService deleteUserChatHist:DeleteConversation sessionid:[COMMON getSessionID] chat_user_id:deleteuserID success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"response:%@",responseObject);
         if([[[responseObject valueForKey:@"deleteconversation"]valueForKey:@"status"]isEqualToString:@"success"])
         {
             NSIndexPath *path = [NSIndexPath indexPathForRow:selectIndex inSection:0];
         
            //[chatArray removeObject:selectIndex];
             [self tableView:ChatTableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:path];

             //[ChatTableView reloadData];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, id error) {
         
     }];
}
-(void)loadblockUser:(NSString*)blockuserID
{
   
    
    [webService blockUser:BlockUser_API sessionid:[COMMON getSessionID] block_user_id:blockuserID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

-(void)loadTabbarMsgCount{
    
    NSArray *unreadMsgArray = [chatArray valueForKey:@"unreadmessage"];
    int total =0;
    for(int i=0;i<[unreadMsgArray count];i++)
    {
        total += [[unreadMsgArray objectAtIndex:i]integerValue];
    }
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(total > 0){
        [appDelegate.badgeCountLabel setHidden:NO];
        NSString *count = [NSString stringWithFormat:@"%d",total];
        [appDelegate.badgeCountLabel setText:count];
        [[NSUserDefaults standardUserDefaults]setValue:count forKey:UnreadMsgCount];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        [appDelegate.badgeCountLabel setHidden:YES];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:UnreadMsgCount];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    NSLog(@"total = %d",total);
}


@end
