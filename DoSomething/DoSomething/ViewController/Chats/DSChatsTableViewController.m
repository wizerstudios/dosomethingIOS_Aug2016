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

@interface DSChatsTableViewController ()

{
    NSArray *ChatNameArray;
    NSArray *MessageArray;
    NSArray *timeArray;
    NSArray *imageArray;
    NSArray*badgeimage;
    UIButton *navButton;
    NSString * currentLatitude, * currentLongitude;
    DSWebservice *webService;
}

@end

@implementation DSChatsTableViewController
@synthesize ChatTableView,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    webService = [[DSWebservice alloc]init];
    ChatNameArray =[[NSArray alloc] initWithObjects:@"Gal Gadot",@"Yuna",@"Taylor",nil];
    MessageArray =[[NSArray alloc] initWithObjects:@"Haha Sure I'll see you at 7:)",@"Hello?",@"See Ya!",nil];
    timeArray = [[NSArray alloc] initWithObjects:@"19:58",@"17:20",@"15:30",nil];
    imageArray =[[NSArray alloc] initWithObjects:@"Galglot.png",@"yuna.png",@"taylor.png",nil];
    badgeimage=[[NSArray alloc] initWithObjects:@"12-Chats.png",@"18-Chats.png",@" ",nil];
//    badgeimage=[[NSArray alloc] initWithObjects:@"18-Chats.png",@"12-Chats.png",@" ",nil];
    
    if(IS_IPHONE6 || IS_IPHONE6_Plus)
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ChatTableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:20.0]];
    
    }




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserCurrenLocation];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self setNavigation];
}

- (void)setNavigation
{
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
    }
    [customNavigation.menuBtn setHidden:NO];
    [customNavigation.buttonBack setHidden:YES];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    //    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    //    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
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

-(void)loadLocationUpdateAPI{
    
    [webService locationUpdate:LocationUpdate_API sessionid:[COMMON getSessionID] latitude:currentLatitude longitude:currentLongitude
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              NSLog(@"responseObject = %@",responseObject);
                          }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              
                          }];
    
    
}

#pragma mark - TableView Datasources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeArray count];
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
    Cell.ChatName .text = [ChatNameArray objectAtIndex:indexPath.row];
    Cell.Message.text= [MessageArray objectAtIndex:indexPath.row];
    Cell.Time.text =[timeArray objectAtIndex:indexPath.row];
    
    NSString *ProfileName=[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:indexPath.row]];
    [Cell.ChatImage setImage:[UIImage imageNamed:ProfileName]];
    
    NSString *ProfileName1=[NSString stringWithFormat:@"%@",[badgeimage objectAtIndex:indexPath.row]];
    [Cell.profileImageView setImage:[UIImage imageNamed:ProfileName1]];
    ChatTableView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    return Cell;
}

#pragma edit TableViewCell

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *ShareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                         {
                                             [self.ChatTableView setEditing:YES];
                                             
                                         }];
    [ShareAction.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Patron-Regular" size:11.0]}];
    ShareAction.backgroundColor =[UIColor colorWithRed:0.465f green:0.465f blue:0.465f alpha:1.0f] ;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [timeArray objectAtIndex:indexPath.row];
        [self.ChatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    [deleteAction.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Patron-Regular" size:11.0]}];
    deleteAction.backgroundColor =[UIColor colorWithRed:(230/255.0) green:(63/255.0) blue:(82/255.0) alpha:1];
    return @[deleteAction,ShareAction];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DSChatDetailViewController *ChatDetail =[[DSChatDetailViewController alloc]initWithNibName:nil bundle:nil];
    ChatDetail.activestring  = [ChatNameArray objectAtIndex:indexPath.row];
    ChatDetail.activestring1  = [imageArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ChatDetail animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
