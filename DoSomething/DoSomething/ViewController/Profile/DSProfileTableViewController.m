
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
    float space;

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
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"switch_on",@"placeHolder",@"",@"NewMessageImage",@"",@"SoundImage",@"",@"VibrationImage",nil],
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
                return 150;
            else if([imageNormalArray count] <= 5)
                return commonHeight + 46;
            else if([imageNormalArray count] <= 10)
                return (commonHeight*2)+46;
            else if([imageNormalArray count] <= 15)
                return (commonHeight * 3)+48;
            else if([imageNormalArray count] <= 20)
                return (commonHeight * 4)+52;
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
            else if([imageNormalArray count] <= 5)
                return commonHeight + 46;
            else if([imageNormalArray count] <= 10)
                return (commonHeight*2)+46;
            else if([imageNormalArray count] <= 15)
                return (commonHeight * 3)+57;
            else if([imageNormalArray count] <= 20)
                return (commonHeight * 4)+70;
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
    NSString *newMessageImage,*soundImage,*vibrationImage;
    

        typingText       = [[[placeHolderArray valueForKey:@"TypingText" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        typingTextPass   = [[[placeHolderArray valueForKey:@"TypingTextPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        typingTextFemale = [[[placeHolderArray valueForKey:@"TypingTextFemale" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

        placeHolderText     =  [[[placeHolderArray valueForKey:@"placeHolder" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        placeHolderTextPass =  [[[placeHolderArray valueForKey:@"placeHolderPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        placeHolderFemale =  [[[placeHolderArray valueForKey:@"placeHolderFemale" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    newMessageImage =  [[[placeHolderArray valueForKey:@"NewMessageImage" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    soundImage =  [[[placeHolderArray valueForKey:@"SoundImage" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    vibrationImage =  [[[placeHolderArray valueForKey:@"VibrationImage" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];


    
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
        space = imageSize / 2;
        commonHeight = imageSize+15;
        
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
        cell.messSwitchBtn.userInteractionEnabled = YES;
        cell.vibrationSwitchBtn.userInteractionEnabled = YES;
        cell.SoundSwitchBtn.userInteractionEnabled = YES;
        
        [cell.messSwitchBtn setTag:2000];
        [cell.SoundSwitchBtn setTag:2001];
        [cell.vibrationSwitchBtn setTag:2002];
        
        
        if([newMessageImage isEqualToString:@""] || newMessageImage == nil)
        {
            [cell.imageViewNewMessSwitch setImage:[UIImage imageNamed:placeHolderText]];
        }
        else
        {
            [cell.imageViewNewMessSwitch setImage:[UIImage imageNamed:newMessageImage]];
        }
        if([vibrationImage isEqualToString:@""] || vibrationImage == nil)
        {
            [cell.imageViewVibrationSwitch setImage:[UIImage imageNamed:placeHolderText]];
        }
        else
        {
            [cell.imageViewVibrationSwitch setImage:[UIImage imageNamed:vibrationImage]];
        }
        if([soundImage isEqualToString:@""] || soundImage == nil)
        {
            [cell.imageViewSoundSwitch setImage:[UIImage imageNamed:placeHolderText]];
        }
        else
        {
            [cell.imageViewSoundSwitch setImage:[UIImage imageNamed:soundImage]];
        }
        
        [cell.vibrationSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.SoundSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messSwitchBtn addTarget:self action:@selector(newMessSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
        commonWidth = (cell.contentView.frame.size.width - 20) / 14;
        imageSize = commonWidth * 2;
    }
}

-(void)newMessSwitchBtnAction:(UIButton *)sender
{
    id button = sender;
    while (![button isKindOfClass:[UITableViewCell class]]) {
        button = [button superview];
    }
    NSIndexPath *indexPath;
    
    DSProfileTableViewCell *cell;
    
    indexPath = [_tableviewProfile indexPathForCell:(UITableViewCell *)button];
    cell = (DSProfileTableViewCell *) [_tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    
    NSArray *titleArray1  = [[NSArray alloc]initWithObjects:@"switch_on",@"switch_off", nil];
    NSString *selOptionVal;
    
    if([sender tag] == 2000){
        NSString *place1 =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"NewMessageImage"];
        
        
        if([place1 isEqualToString:@""] || place1 == nil)
        {
            
            NSString *NewMessageImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"placeHolder"];
            
            
            
            if (NewMessageImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
            }
            if (NewMessageImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
            }
            
            
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"NewMessageImage"];
        }
        
        
        else
            
        {
            
            NSString *NewMessageImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"NewMessageImage"];
            
            
            if (NewMessageImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
            }
            if (NewMessageImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
            }
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"NewMessageImage"];
            
            
        }
    }
    
    
    if([sender tag] == 2001){
        
        NSString *place =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"SoundImage"];
        
        
        if([place isEqualToString:@""] || place == nil)
        {
            
            NSString *SoundImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"placeHolder"];
            
            
            
            
            if (SoundImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
            }
            if (SoundImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
            }
            
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"SoundImage"];
        }
        
        
        else
            
        {
            
            NSString *SoundImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"SoundImage"];
            
            
            if (SoundImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
            }
            if (SoundImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
            }
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"SoundImage"];
            
            
        }
        
        
    }
    
    
    if([sender tag] == 2002){
        
        NSString *place =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"VibrationImage"];
        
        
        if([place isEqualToString:@""] || place == nil)
        {
            
            NSString *VibrationImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"placeHolder"];
            
            
            
            
            if (VibrationImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
            }
            if (VibrationImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
            }
            
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"VibrationImage"];
        }
        
        
        else
            
        {
            
            NSString *VibrationImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"VibrationImage"];
            
            
            if (VibrationImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
            }
            if (VibrationImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
            }
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"VibrationImage"];
        }
    }
    
    [_tableviewProfile reloadData];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    DSProfileTableViewCell *cell ;
//   }
@end
