
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
#import "HomeViewController.h"


@interface DSProfileTableViewController ()<UITextFieldDelegate>
{
    NSMutableArray *placeHolderArray, *imageNormalArray,*hobbiesNameArray;
    NSArray *titleArray;
    NSMutableArray *interstAndHobbiesArray;
    UIDatePicker *datePicker;
    UITextField *currentTextfield;
    UILabel *maleLabel;
    UILabel *femaleLabel;
    
    float commonWidth, commonHeight;
    float yAxis;
    float imageSize;

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
    if (IS_IPHONE6 ){
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
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
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

-(void)saveAction
{
     HomeViewController * objHomeview = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:objHomeview animated:NO];
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
    textField.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
    
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
//    else if (indexPath.row ==3 ) {
//        selOptionVal = cell.textFieldDPPlaceHolder.text;
//        
//        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
//            [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
//            
//            
//            
//        }
    
        
//    }

    
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
    maleLabel .textColor =[UIColor redColor];
    femaleLabel.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];

    
}



-(void)femaleButtonAction
{
    femaleLabel .textColor =[UIColor redColor];
    maleLabel.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];


    
}

- (void)pushToHobbiesView {
    DSInterestAndHobbiesViewController * DSHobbiesView  = [[DSInterestAndHobbiesViewController alloc]initWithNibName:@"DSInterestAndHobbiesViewController" bundle:nil];
    [self.navigationController pushViewController:DSHobbiesView animated:YES];

}

-(void)initializeArray{
    imageNormalArray =[[NSMutableArray alloc]init];


    interstAndHobbiesArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"]mutableCopy];
    imageNormalArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
    
    hobbiesNameArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"]mutableCopy];
   

   
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];

    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"First Name",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Last Name",@"placeHolder",@"",@"TypingText", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Male",@"placeHolder",@"Female",@"placeHolderFemale",@"",@"TypingText",@"",@"TypingTextFemale", nil],
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
        if ( indexPath.row ==6) {
            if([imageNormalArray count] < 1)
                return 100;
            else if([imageNormalArray count] <= 10)
                return 150;
            else if([imageNormalArray count] <= 15)
                return 200;
            else if([imageNormalArray count] <= 20)
                return 280;
        }

       
        if ( indexPath.row == 7) {
            return 120;
        }
        if (indexPath.row ==8) {
            return 150;
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
        if ( indexPath.row ==6) {
            if([imageNormalArray count] < 1)
                return 150;
            else if([imageNormalArray count] <= 10)
                return 150;
            else if([imageNormalArray count] <= 15)
                return 200;
            else if([imageNormalArray count] <= 20)
                return 350;
        }
    
        if(indexPath.row ==8)
        {
            return 150;
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
    NSString *placeHolderText,*placeHolderTextPass,*placeHolderFemale;
    NSString *typingText,*typingTextPass,*typingTextFemale;
    

        typingText       = [[[placeHolderArray valueForKey:@"TypingText" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        typingTextPass   = [[[placeHolderArray valueForKey:@"TypingTextPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        typingTextFemale = [[[placeHolderArray valueForKey:@"TypingTextFemale" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

        placeHolderText     =  [[[placeHolderArray valueForKey:@"placeHolder" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        placeHolderTextPass =  [[[placeHolderArray valueForKey:@"placeHolderPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        placeHolderFemale =  [[[placeHolderArray valueForKey:@"placeHolderFemale" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];


    
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
        
        

       
        
//                if([typingText isEqualToString:@""] || typingText == nil)
//                {
//                    [maleLabel setText:placeHolderText];
//                }
//                else
//                {
//                    cell.emailTextField.text = typingText;
//        
//                }
//        
//                if([typingTextFemale isEqualToString:@""] || typingTextFemale == nil)
//                {
//                    [femaleLabel setText:placeHolderFemale];
//                }
//                else
//                {
//                    femaleLabel.text = typingTextFemale;
//                    
//                }
        
        cell.maleButton.userInteractionEnabled = YES;
        cell.femaleButton.userInteractionEnabled = YES;
        
        maleLabel =[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 40, 10)];
        maleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:9.0];
        maleLabel.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
        [maleLabel setText:placeHolderText];
        [cell.maleButton addSubview:maleLabel];
        
        femaleLabel =[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 40, 10)];
        femaleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:9.0];
        femaleLabel.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
        [femaleLabel setText:placeHolderFemale];
        [cell.femaleButton addSubview:femaleLabel];
  
        [cell.maleButton addTarget:self action:@selector(maleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.femaleButton addTarget:self action:@selector(femaleButtonAction) forControlEvents:UIControlEventTouchUpInside];


        
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
            cell = cellTextView;
            
        }
        
        cell.layoutConstraintViewHeight.constant =40;

        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintViewHeight.constant =50;
            
        }
        
        cell.labelAboutYou.text =titleText;
        
//        if([typingText isEqualToString:@""] || typingText == nil)
//            cell.textViewAboutYou.placeholder = placeHolderText;
//        else
//            cell.textFieldPlaceHolder.text = typingText;
//            cell.labelTitleText.text = titleText;
    }
    
    if(indexPath.row == 6)
    {
        if (cell == nil){
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellAddIcon;
            [cell.buttonPushHobbies addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        yAxis = 31;
        float space = imageSize / 2;
        
        NSString *plusIcon = @"Pluis_icon1.png";
        if ([imageNormalArray count] >=1) {
            [imageNormalArray addObject:plusIcon];
        }
        
        UIButton *pushToHobbiesButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
        for (int i =0; i< [imageNormalArray  count]; i++) {
            cell.plusIconImageView.hidden = YES;
            UIImageView *hobbiesImage;
            
            if(i <= 4)
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+ 10, yAxis, imageSize, imageSize)];
            else if(i <= 9)
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize))+ 10, yAxis+imageSize+space, imageSize, imageSize)];
            else if(i <= 14)
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize))+ 10, yAxis+((imageSize+space) * 2), imageSize, imageSize)];
            else
                hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+ 10, yAxis+((imageSize+space) * 3), imageSize, imageSize)];
            NSString *image =[imageNormalArray objectAtIndex:i];
            
            [hobbiesImage setImage:[UIImage imageNamed:image]];
            
            if (image == plusIcon) {
                hobbiesImage.userInteractionEnabled = YES;
                [hobbiesImage addSubview:pushToHobbiesButton];
            }
            
            [cell addSubview:hobbiesImage];
            [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        for (int i =0; i< [hobbiesNameArray  count]; i++) {
            
            NSString *image =[hobbiesNameArray objectAtIndex:i];
            UILabel *hobbiesname;
            
            if(i <= 4)
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize)), yAxis + imageSize, imageSize + 20, 15)];
            else if(i <= 9)
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-5)*(commonWidth + imageSize)), yAxis+(imageSize * 2)+space, imageSize + 20, 15)];
            else if(i <= 14)
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-10)*(commonWidth + imageSize)), yAxis+((imageSize+space) * 2)+imageSize, imageSize + 20, 15)];
            else
                hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize)), yAxis+((imageSize+space) * 3)+imageSize, imageSize + 20, 15)];
            
            [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255 green:(float)102.0/255 blue:(float)102.0/255 alpha:1.0f];
            
            
            hobbiesname.text = image;
            [cell addSubview:hobbiesname];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            
            
        }
    }

  /*
    if (indexPath.row == 6)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellAddIcon;
            [cell.buttonPushHobbies addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        
        
        NSString *plusIcon = @"Pluis_icon1.png";
        if ([imageNormalArray count] >=1) {
            [imageNormalArray addObject:plusIcon];
            
        }
        
        
        UIButton *pushToHobbiesButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        
        for (int i =0; i< [imageNormalArray  count]; i++) {
            
//            NSString *strName = [imageNormalArray objectAtIndex:i];
//            float imgSize = ([strName isEqualToString:@"Pluis_icon1.png"]) ? 38 : 50;
            
            float imgSize = 38;
            
            cell.plusIconImageView.hidden = YES;
            UIImageView *hobbiesImage;
            
            if (i<=4) {
                
                
                if(IS_IPHONE5){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*58, 22, imgSize, imgSize)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*70, 17, imgSize, imgSize)];
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*80, 22, imgSize, imgSize)];
                    
                }
                
            }
            
            else if(i <= 9)
            {
                
                if(IS_IPHONE5){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*58, 85, imgSize, imgSize)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*70, 80, imgSize, imgSize)];
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*80, 90, imgSize, imgSize)];
                }
            }
            else if(i <= 14)
            {
                if(IS_IPHONE5){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*58, 148, imgSize, imgSize)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*70, 143, imgSize, imgSize)];
                    NSLog(@"%@", hobbiesImage);
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*80, 158, imgSize, imgSize)];
                    
                }
            }
            else
            {
                if(IS_IPHONE5){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*58, 211, imgSize, imgSize)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*70, 206, imgSize, imgSize)];
                    NSLog(@"%@", hobbiesImage);
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesImage = [[UIImageView alloc]initWithFrame:CGRectMake((i)%5*80, 226, imgSize, imgSize)];
                    
                }
            }
            NSString *image =[imageNormalArray objectAtIndex:i];
            
            [hobbiesImage setImage:[UIImage imageNamed:image]];
            
            if (image == plusIcon) {
                hobbiesImage.userInteractionEnabled = YES;
                [hobbiesImage addSubview:pushToHobbiesButton];
            }
            
            hobbiesImage.backgroundColor = [UIColor darkGrayColor];
            [cell addSubview:hobbiesImage];
            [pushToHobbiesButton addTarget:self action:@selector(pushToHobbiesView) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        for (int i =0; i< [hobbiesNameArray  count]; i++) {
            
            NSString *image =[hobbiesNameArray objectAtIndex:i];
            
            UILabel *hobbiesname;
            
            
            if (i<=4){
                
                
                if(IS_IPHONE5){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(i*58, 65, 60, 15)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(i*65, 60, 55, 15)];
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake(i*80, 75, 50, 15)];
                    
                }
            }
            
            
            else if(i <= 9)
            {
                if(IS_IPHONE5){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*55, 126, 60, 15)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*70, 121, 55, 15)];
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*80, 135, 60, 15)];
                    
                }
            }
            else if(i <= 14)
            {
                if(IS_IPHONE5){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*55, 188, 60, 15)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*70, 182, 55, 15)];
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*80, 195, 60, 15)];
                    
                }
            }
            else
            {
                if(IS_IPHONE5){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*55, 250, 60, 15)];
                }
                if(IS_IPHONE6){
                    
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*70, 245, 55, 15)];
                }
                if(IS_IPHONE6_Plus)
                {
                    hobbiesname = [[UILabel alloc]initWithFrame:CGRectMake((i)%5*80, 255, 60, 15)];
                    
                }
            }
            
            hobbiesname.backgroundColor = [UIColor darkGrayColor];
            [hobbiesname setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255 green:(float)102.0/255 blue:(float)102.0/255 alpha:1.0f];
            
            
            hobbiesname.text = image;
            [cell addSubview:hobbiesname];
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            
            
        }
        
        
    }
   
   */
   
//    }

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
        
        
//        DVSwitch *fifth = [DVSwitch switchWithStringsArray:@[@"", @""]];
//        fifth.frame = CGRectMake(10,10, self.view.frame.size.width / 2 - 100, 20);
//        fifth.sliderOffset = 1.0;
//        fifth.cornerRadius = 10;
//        fifth.font = [UIFont fontWithName:@"Baskerville-Italic" size:18];
//        fifth.labelTextColorOutsideSlider = [UIColor colorWithRed:255/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
//        fifth.labelTextColorInsideSlider = [UIColor colorWithRed:255 green:255 blue:102 alpha:1.0];
//        fifth.backgroundColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
//        fifth.sliderColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
//        [cell addSubview:fifth];
//
        
        
        
        
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 6)
    {
        commonHeight = cell.contentView.frame.size.height;
        commonWidth = (cell.contentView.frame.size.width - 20) / 14;
        imageSize = commonWidth * 2;
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    DSProfileTableViewCell *cell ;
//   }
@end
