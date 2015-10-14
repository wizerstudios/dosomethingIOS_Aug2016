//
//  ProfileTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSProfileTableViewController.h"
#import "DSHobbiesViewController.h"
#import "CustomNavigationView.h"


@interface DSProfileTableViewController ()<UITextFieldDelegate>
{
    NSArray *placeHolderArray;
    NSArray *titleArray;
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
    customNavigation.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),10);
    customNavigation.view.backgroundColor =[UIColor blackColor];
     [customNavigation.buttonBack addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customNavigation.view];    
    
    
}
- (void)BackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pushToHobbiesView {
    DSHobbiesViewController * DSHobbiesView  = [[DSHobbiesViewController alloc]initWithNibName:@"DSHobbiesViewController" bundle:nil];
    [self.navigationController pushViewController:DSHobbiesView animated:YES];

}

-(void)initializeArray{
     placeHolderArray = [[NSArray alloc]initWithObjects:@"Firstname",@"Firstname",@"Lastname",@"male",@"DD/MM/YYYY",@"Write something about yourself here.",@"Hobbies",nil];
    titleArray = [[NSArray alloc]initWithObjects:@"Firstname",@"Firstname",@"Lastname",@"male",@"Date of Birth",@"About You",@"Hobbies",nil];
    
    
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
    if (indexPath.row == 6) {
        return 90;
    }
    if (indexPath.row == 4) {
        return 55;
    }

    
    
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *titleText;
    NSString *placeHolderText;
    
        placeHolderText =  [placeHolderArray objectAtIndex:indexPath.row];
        titleText       =  [titleArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 6)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellAddIcon;
            
        }
        [cell.buttonPushHobbies addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (indexPath.row == 4)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellDatePicker;
            
        }
        cell.textFieldDPPlaceHolder.placeholder = placeHolderText;
        cell.labelDPTitleText.text = titleText;
        
    }
    if (indexPath.row == 3)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self  options:nil];
            cell = cellButton;
            
        }
    }


    
            if (indexPath.row == 0)
            {
                
                if (cell == nil)
                {
                    [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
                    cell = cellProfileImg;
                    
                }
                
            }
    
    
       if (indexPath.row == 1 || indexPath.row == 2|| indexPath.row == 5)
       {
                if (cell == nil)
                {
                    [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
                     cell = cellTextField;
                    
                }
    
                  
    cell.textFieldPlaceHolder.placeholder = placeHolderText;
    cell.labelTitleText.text = titleText;
       }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}




@end
