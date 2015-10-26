//
//  ProfileTableViewController.m
//  DoSomething
//
//  Created by Sha on 10/12/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSProfileTableViewController.h"
#import "DSInterestAndHobbiesViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"


@interface DSProfileTableViewController ()<UITextFieldDelegate>
{
    NSMutableArray *placeHolderArray, *imageNormalArray,*hobbiesNameArray;
    NSArray *titleArray;
    NSMutableArray *interstAndHobbiesArray;
    UIDatePicker *datePicker;
    UITextField *currentTextfield;

}
@end

@implementation DSProfileTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
   
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, CGRectGetWidth(self.view.frame), 65);
    if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
        self.layoutConstraintTableViewYPos.constant= 20;
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        self.layoutConstraintTableViewYPos.constant= 20;
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [customNavigation.saveBtn setHidden:NO];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self initializeArray];

}

-(void)loadDatePicker:(NSInteger)_tag{
    currentTextfield=(UITextField *)[self.view viewWithTag:_tag];
    datePicker   = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 320, 150)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(DateSelectionAction:) forControlEvents:UIControlEventValueChanged];
    datePicker.tag =_tag;
    [currentTextfield setInputView:datePicker];
    currentTextfield.tintColor=[UIColor clearColor];
}

- (void)DateSelectionAction:(UIDatePicker *)sender
{
    currentTextfield=(UITextField *)[self.view viewWithTag:[sender tag]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString =  [dateFormat stringFromDate:sender.date];
    currentTextfield.text = dateString;

    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSInteger tag = [textField tag];
    if(textField.tag >= 1000){
        [self loadDatePicker:tag];
    }
    return YES;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    id textFieldSuper = textField;
    textField.textColor =[UIColor blackColor];
    
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        
        textFieldSuper = [textFieldSuper superview];
        
    }
    NSIndexPath *indexPath ;
    
    DSProfileTableViewCell *cell;
    
    indexPath = [self.tableviewProfile indexPathForCell:(UITableViewCell *)textFieldSuper];
    
    cell = (DSProfileTableViewCell *) [self.tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    NSLog(@"row = %ld section = %ld",(long)indexPath.row,(long)indexPath.section);
    
    NSString *selOptionVal;
    if (indexPath.row ==1 ||indexPath.row ==2||indexPath.row ==5) {
        selOptionVal = cell.textFieldPlaceHolder.text;
        
        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
            [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
            
        }
    }
    
        else if (indexPath.row ==4 ) {
            selOptionVal = cell.textFieldDPPlaceHolder.text;
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
                
            

        }
            

    }
    
        else if (indexPath.row ==7 ) {
            if ((selOptionVal = cell.emailTextField.text)) {
                if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
                    [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];

            }
                
            }
            selOptionVal = cell.passwordTextField.text;
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingTextPass"];
            }
            
        }

    NSLog(@"personalArray =%@", placeHolderArray);
    
    [cell.textFieldPlaceHolder   resignFirstResponder];
    
    [textField resignFirstResponder];
    
}



-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)maleButtonAction
{
    DSProfileTableViewCell *Cell;
    [Cell.maleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}
- (IBAction)maleButtonAction:(id)sender {
    DSProfileTableViewCell *Cell;
    Cell.maleButton.tintColor =[UIColor redColor];
}



-(void)femaleButtonAction
{
    DSProfileTableViewCell *Cell;
    [Cell.femaleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    
}

- (void)pushToHobbiesView {
    DSInterestAndHobbiesViewController * DSHobbiesView  = [[DSInterestAndHobbiesViewController alloc]initWithNibName:@"DSInterestAndHobbiesViewController" bundle:nil];
    [self.navigationController pushViewController:DSHobbiesView animated:YES];

}

-(void)initializeArray{
    imageNormalArray =[[NSMutableArray alloc]init];

    interstAndHobbiesArray =[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"];
    imageNormalArray =[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"];
    
    hobbiesNameArray =[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"];
   


    
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];

    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"First Name",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Last Name",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Male",@"placeHolder",@"Female",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"DD / MM / YYYY",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Write something about yourself here.",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Email",@"placeHolder",@"Password",@"placeHolderPass",@"",@"TypingText",@"",@"TypingTextPass", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"switch_on",@"placeHolder",@"",@"TypingText",nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"TermsOfUse",@"placeHolder",@"",@"TypingText", nil],nil]atIndex:0];
    
    titleArray = [[NSArray alloc]initWithObjects:@"Image",@"First Name",@"Last Name",@"male",@"Date of Birth",@"About You",@"Hobbies",@"Email&Password",@"switch_on",@"TermsOfUse",nil];
    
    NSLog(@"PlaceHolder %@",placeHolderArray);
    [self.tableviewProfile reloadData];
   
}

#pragma mark - TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [placeHolderArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
         return [placeHolderArray[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE4 ||IS_IPHONE5){
    if (indexPath.row == 0 ){
        return 200;
        }
        if (indexPath.row == 4) {
            return 55;
        }
        
        if (indexPath.row == 6 || indexPath.row ==8) {
            return 90;
        }
        if ( indexPath.row == 7) {
            return 120;
        }
        
        if (indexPath.row == 9) {
            return 80;
        }

    return 40;
    }
        if (indexPath.row == 0 ){
            return 258;
        }
        if (indexPath.row == 4) {
            return 70;
        }
    
        if (indexPath.row == 6 || indexPath.row ==8) {
            return 120;
        }
        if ( indexPath.row == 7) {
            return 160;
        }
    
        if (indexPath.row == 9) {
            return 98;
        }
    
    return 50;
    
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *titleText;
    NSString *placeHolderText,*placeHolderTextPass;
    NSString *typingText,*typingTextPass;
    

        typingText      = [[[placeHolderArray valueForKey:@"TypingText" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        typingTextPass      = [[[placeHolderArray valueForKey:@"TypingTextPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];


        placeHolderText     =  [[[placeHolderArray valueForKey:@"placeHolder" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        placeHolderTextPass =  [[[placeHolderArray valueForKey:@"placeHolderPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    
        titleText       =  [titleArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellProfileImg;
            
        }
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintProfileImageHeight.constant =159;
            cell.layoutConstraintProfileImageWidth.constant =161;
            
        }
        
           }
    if (indexPath.row == 1 || indexPath.row == 2)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellTextField;
            
        }
        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintViewHeight.constant =49;

        }
        cell.labelTitleText.text = titleText;

        if([typingText isEqualToString:@""] || typingText == nil)
            cell.textFieldPlaceHolder.placeholder = placeHolderText;
        else
            cell.textFieldPlaceHolder.text = typingText;
        
        
    }
    if (indexPath.row == 3)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self  options:nil];
            cell = cellButton;
            
        }

        
    }


    if (indexPath.row == 4)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellDatePicker;
            
        }
        
        
        if([typingText isEqualToString:@""] || typingText == nil)
            cell.textFieldDPPlaceHolder.placeholder = placeHolderText;
        else
            cell.textFieldDPPlaceHolder.text = typingText;
        
            cell.labelDPTitleText.text = titleText;
            [cell.textFieldDPPlaceHolder setTag:1000];

        
        
    }
    if (indexPath.row == 5)
    {
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellTextField;
            
        }
        
        cell.layoutConstraintViewHeight.constant =40;

        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintViewHeight.constant =50;
            
        }
        
        if([typingText isEqualToString:@""] || typingText == nil)
            cell.textFieldPlaceHolder.placeholder = placeHolderText;
        else
            cell.textFieldPlaceHolder.text = typingText;
            cell.labelTitleText.text = titleText;
    }

    
    if (indexPath.row == 6)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellAddIcon;
            
        }
        [cell.buttonPushHobbies addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
        for (int i =0; i< [imageNormalArray  count]; i++) {
            
           UIImageView *hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*30, 27, 38, 38)];
            NSString *image =[imageNormalArray objectAtIndex:i];
            
            [hobbiesImage setImage:[UIImage imageNamed:image]];
            [cell addSubview:hobbiesImage];
        }
        for (int i =0; i< [hobbiesNameArray  count]; i++) {
            
            UILabel *hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(i*30, 65, 38, 15)];
            [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:6]];

            NSString *image =[hobbiesNameArray objectAtIndex:i];
            
            hobbiesname.text = image;
            [cell addSubview:hobbiesname];
        }
        
       
    }
   
    

    if (indexPath.row == 7)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellEmailPassword;
            
        }
        
        
        if([typingText isEqualToString:@""] || typingText == nil)
        {
           cell.emailTextField.placeholder = placeHolderText;
        }
          else
          {
            cell.emailTextField.text = typingText;

          }
        
        if([typingTextPass isEqualToString:@""] || typingTextPass == nil)
        {
            cell.passwordTextField.placeholder =placeHolderTextPass;
        }
        else
        {
            cell.passwordTextField.text = typingTextPass;
            
        }
        
        
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        cell.layoutConstraintAccLabelYPos.constant =42;
        cell.layoutConstraintEmailPassViewHeight.constant =50;
        }
    }
    if (indexPath.row == 8)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellSwitchOn;
            
        }
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        cell.layoutConstraintNotificationLabelYPos.constant = 40;
        cell.layoutConstraintNotificationViewHeight.constant=51;
        cell.layoutConstraintRadioButtonYPos.constant = 18;
        }
    }

    if (indexPath.row == 9)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = CellTermsOfUse;
            
        }
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        cell.layoutConstraintTermsOfUseBtnDependViewHeight.constant =50;
        }
       
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    DSProfileTableViewCell *cell ;
    [cell.maleButton addTarget:self action:@selector(maleButtonAction) forControlEvents:UIControlEventTouchUpInside];
     [cell.femaleButton addTarget:self action:@selector(femaleButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
@end
