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


@interface DSChatsTableViewController ()

{
    UIButton *navButton;
    NSString * currentLatitude, * currentLongitude;
    DSWebservice *webService;
    NSMutableArray *chatArray;
    NSUInteger isSupportUser;
    UIRefreshControl            * refreshControl;
    
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


    
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ChatTableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:20.0]];
    [COMMON LoadIcon:self.ChatTableView];
   
   
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadChatHistoryAPI];
    [self getUserCurrenLocation];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self setNavigation];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    messageTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadChatHistoryAPI) userInfo:nil repeats:YES];

}

-(void)viewwillDisappear:(BOOL)animated{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [messageTimer invalidate];
        messageTimer =nil;
    });
    
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [messageTimer invalidate];
        messageTimer =nil;
    });
    [super viewDidDisappear:animated];
    
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
    
    [customNavigation.menuBtn setHidden:NO];
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLatitude  forKey:@"currentLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:currentLongitude forKey:@"currentLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Turn off the location manager to save power.
    [locationManager stopUpdatingLocation];
    
    NSLog(@"current latitude & longitude for main view = %@ & %@",currentLatitude,currentLongitude);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
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
       
//        downloadImageFromUrl(ProfileName,Cell.profileImageView);
//        
//        [Cell.profileImageView setImage:[UIImage imageNamed:ProfileName]];
        
       [Cell.profileImageView setImageWithURL:[NSURL URLWithString:ProfileName]];
       if(Cell.profileImageView.image==nil)
       {
           [Cell.activeIndicator startAnimating];
       }
        else
        {
           [Cell.activeIndicator stopAnimating];
            [Cell.activeIndicator setHidden:YES];
        }
        
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
    NSLog(@"didselectindex:%ld",(long)indexPath.row);
    
    DSChatDetailViewController *ChatDetail =[[DSChatDetailViewController alloc]initWithNibName:nil bundle:nil];
    
    ChatDetail.chatuserDetailsDict = [chatArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:ChatDetail animated:YES];
    
}

#pragma mark - WebService

-(void)loadLocationUpdateAPI{
    
    [webService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                       success:^(AFHTTPRequestOperation *operation, id responseObject){
                           NSLog(@"responseObject = %@",responseObject);
                       }
                       failure:^(AFHTTPRequestOperation *operation, id error) {
                           
                       }];
    
    
}

-(void)loadChatHistoryAPI{
    
    [webService userChatHist:ChatHistory_API sessionid:[COMMON getSessionID]
     
                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                         
                         NSLog(@"responseObject = %@",responseObject);
                         
                         chatArray = [[[responseObject valueForKey:@"getchathistory"]valueForKey:@"converation"] mutableCopy];
                         
                         NSLog(@"chatArray = %@",chatArray);
                         
                         [refreshControl endRefreshing];
                         
                         [ChatTableView reloadData];
                         
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


@end
