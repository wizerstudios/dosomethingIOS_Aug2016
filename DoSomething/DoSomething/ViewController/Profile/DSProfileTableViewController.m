//
//  ProfileTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSProfileTableViewController.h"
#import "CustomNavigationView.h"

@interface DSProfileTableViewController ()<UITextFieldDelegate>
{
    NSArray *placeHolderArray;
}
@end

@implementation DSProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
    [self initializeArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNavigation{
    
    self.navigationController.navigationBarHidden=YES;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 56);
     [customNavigation.buttonBack addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
//    [customNavigation setlogoutButtonHidden:YES];
//    [customNavigation setbackButtonHidden:YES];
    [self.view addSubview:customNavigation.view];    
    
    
}
- (void)BackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initializeArray{
     placeHolderArray = [[NSArray alloc]initWithObjects:@"Firstname"@"Firstname",@"Lastname",@"male",@"Date of Birth",@"About You",@"Hobbies",nil];
    
//       [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:
//                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Firstname",@"placeholder", nil],
//                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Lastname",@"placeholder", nil],
//                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"male",@"placeholder", nil],
//                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Date of Birth",@"placeholder", nil],
//                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"About You",@"placeholder", nil],
//                                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeholder", nil],
//                                 nil] atIndex:0];
    
}
#pragma mark - TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [placeHolderArray count];    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 ){
        return 200;

    }
    if (indexPath.row == 5) {
        return 90;
    }
    
    
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *titleText;
    NSString *placeHolderText;
    
        placeHolderText =  [placeHolderArray objectAtIndex:indexPath.row];
    
    
    
            if (indexPath.row == 0)
            {
                
                if (cell == nil)
                {
                    [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
                    cell = cellProfileImg;
                    
                }
                
            }
            if (indexPath.row == 3)
            {
                if (cell == nil)
                {
                    [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self  options:nil];
                    cell = cellButton;
                    
                }
            }
    if (indexPath.row == 5)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellAddIcon;
            
        }
        
    }
    
 
    
       if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4)
                if (cell == nil)
                {
                    [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
                     cell = cellTextField;
                    
                }
    
                  
    cell.placeHolderTextField.placeholder = titleText;
    cell.labelTitleText.text = titleText;
    

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}




@end
