//
//  ChatsTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/13/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSChatsTableViewController.h"
#import "ChatTableViewCell.h"
#import "DSChatDetailViewController.h"

@interface DSChatsTableViewController ()

{
    NSArray *ChatNameArray;
    NSArray *MessageArray;
    NSArray *timeArray;
    NSArray *imageArray;
    NSArray*badgeimage;
    UIButton *navButton;
}

@end

@implementation DSChatsTableViewController
@synthesize ChatTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title =@"DOSOMETHING";
//    self.navigationItem.leftBarButtonItem.title = @"Log Out";
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"menu_icon.png"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"menu_icon.png"]];
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@" "
//                                     style:UIBarButtonItemStylePlain
//                                    target:nil
//                                    action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
        
    ChatNameArray =[[NSArray alloc] initWithObjects:@"Gal Gadot",@"Yuna",@"Taylor",nil];
    MessageArray =[[NSArray alloc] initWithObjects:@" Haha Sure I'll see you at 7:)",@"Hello?",@"See Ya!",nil];
    timeArray = [[NSArray alloc] initWithObjects:@"19:58",@"17:20",@"15:30",nil];
    imageArray =[[NSArray alloc] initWithObjects:@"Galglot2x.png",@"yuna2x.png",@"taylor2x.png",nil];
    badgeimage=[[NSArray alloc] initWithObjects:@"18-Chats copy 3.png",@"18-Chats copy 2.png",@" ",nil];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        ChatTableView.delegate=self;
        ChatTableView.dataSource=self;
    }
    
    return self;
}

#pragma mark - Tableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    ShareAction.backgroundColor =[UIColor colorWithRed:0.465f green:0.465f blue:0.465f alpha:1.0f];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [timeArray objectAtIndex:indexPath.row];
        [self.ChatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
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


//-(void)loadNavigation{
//    
//    self.navigationController.navigationBarHidden=YES;
//    [self.navigationItem setHidesBackButton:YES animated:NO];
//    [self.navigationController.navigationBar setTranslucent:NO];
//    
//    CustomNavigationView *customNavigation;
//    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
//    customNavigation.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 56);
//    
//   [customNavigation setbuttonBackHidden:YES];
//    [self.view addSubview:customNavigation.view];
//    
//    
//}
//
@end
