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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ChatNameArray =[[NSArray alloc] initWithObjects:@"Gal Gadot",@"Yuna",@"Taylor",nil];
    MessageArray =[[NSArray alloc] initWithObjects:@" Haha Sure I'll see you at 7:)",@"Hello?",@"See Ya!",nil];
    timeArray = [[NSArray alloc] initWithObjects:@"19:58",@"17:20",@"15:30",nil];
    imageArray =[[NSArray alloc] initWithObjects:@"Galglot.png",@"yuna.png",@"taylor.png",nil];
    badgeimage=[[NSArray alloc] initWithObjects:@"18-Chats.png",@"12-Chats.png",@" ",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
