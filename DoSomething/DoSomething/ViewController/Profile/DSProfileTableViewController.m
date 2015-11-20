
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
#import "DSAppCommon.h"
#import "DSWebservice.h"
#import "OpenUDID.h"
#import <MapKit/MapKit.h>
#import "NSString+validations.h"
#import "PWParallaxScrollView.h"
#import "NSString+validations.h"
#import "UIImageView+AFNetworking.h"

@interface DSProfileTableViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate,PWParallaxScrollViewDataSource,PWParallaxScrollViewDelegate,UIScrollViewDelegate>
{
    DSWebservice            * objWebService;
    CLLocationManager       *locationManager;
    NSString                *currentLatitude,*currentLongitude;
    NSMutableArray          *imageNormalArray,*hobbiesNameArray;
    NSArray                 *titleArray;
    NSMutableArray          *interstAndHobbiesArray;
    UIDatePicker            *datePicker;
    UITextField             *currentTextfield;
    UILabel                 *maleLabel;
    UILabel                 *femaleLabel;
    
    float commonWidth, commonHeight;
    float yAxis;
    float imageSize;
    float space;
    
    UIImage *profileImage;
    
    DSProfileTableViewCell *cell;
    
    NSString * deviceUdid;
    NSString * selectGender;
    NSString * strFirstName;
    NSString * strLastName;
    
    NSString * isNotification_message;
    NSString * isNotification_sound;
    NSString * isNotification_vibration;
    NSMutableArray *BGimageArray;
    NSMutableArray *FGimageArray;
    UIButton *pageControllBtn;
    UIImageView *foregroundView;
     UIView * mainview;
    UIImageView * objImag;
    NSInteger Currentindex;
    

}
@property (nonatomic, strong) PWParallaxScrollView *scrollView;
@end

@implementation DSProfileTableViewController
@synthesize profileData, textviewText, placeHolderArray,FBprofileID;
@synthesize userDetailsDict,emailAddressToRegister,emailPasswordToRegister,selectEmail,topViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    objWebService = [[DSWebservice alloc]init];
    [self initializeArray];
    deviceUdid = [OpenUDID value];
    infoArray=[[NSMutableArray alloc]initWithObjects:@"profile_noimg",@"profile_noimg",@"profile_noimg", nil];
   
    
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
    [customNavigation.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    imageNormalArray =[[NSMutableArray alloc]init];
    
    interstAndHobbiesArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItem"]mutableCopy];
    
    imageNormalArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemNormal"]mutableCopy];
    
    hobbiesNameArray =[[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedItemName"]mutableCopy];
    
    [_tableviewProfile reloadData];

}
- (NSString *) getEmail {
    
    if (emailAddressToRegister == NULL) {
        emailAddressToRegister = @"";
    }
    NSString *emailAddress = emailAddressToRegister;
    NSLog(@"email = %@",emailAddress);
    return emailAddress;
}
- (NSString *) getPassword {
    
    if (emailPasswordToRegister == NULL) {
        emailPasswordToRegister = @"";
    }
    NSString *emailPassword = emailPasswordToRegister;
    NSLog(@"email = %@",emailPassword);
    return emailPassword;
}

#pragma mark get user CurrentLocation

- (void)getUserCurrenLocation{
    
    if(!locationManager){
        
        locationManager                 = [[CLLocationManager alloc] init];
        locationManager.delegate        = self;
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
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Cannot find the location for main view.");
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
    textField.textColor =[UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
    
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        
        textFieldSuper = [textFieldSuper superview];
        
    }
    NSIndexPath *indexPath ;
    
    //DSProfileTableViewCell *cell;
    
    indexPath = [self.tableviewProfile indexPathForCell:(DSProfileTableViewCell *)textFieldSuper];
    
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
       // selOptionVal = cell.textFieldDPPlaceHolder.text;
       
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        selOptionVal = [formatter stringFromDate:date];
       
        if(selOptionVal != nil || ![selOptionVal isEqualToString:@""]){
            //[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"TypingText"];
            currentTextfield.text =selOptionVal;
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

- (void)pushToHobbiesView {
    
    DSInterestAndHobbiesViewController * DSHobbiesView  = [[DSInterestAndHobbiesViewController alloc]initWithNibName:@"DSInterestAndHobbiesViewController" bundle:nil];
    DSHobbiesView.profileDetailsArray = placeHolderArray;
    [self.navigationController pushViewController:DSHobbiesView animated:YES];

}

-(void)initializeArray{
    
    placeHolderArray = [[NSMutableArray alloc] initWithCapacity: 1];
    
   // NSMutableDictionary *detailsDict = [[NSMutableDictionary alloc]init];
   // detailsDict = [[COMMON getUserDetails]mutableCopy];

    [placeHolderArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Image",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"first_name"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"last_name"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"gender"],@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"DD/MM/YYYY",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Write something about yourself here.",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hobbies",@"placeHolder",@"",@"TypingText", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:[userDetailsDict valueForKey:@"email"],@"placeHolder",@"Password",@"placeHolderPass",@"",@"TypingText",@"",@"TypingTextPass", nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"switch_on",@"placeHolder",@"",@"NewMessageImage",@"",@"SoundImage",@"",@"VibrationImage",nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"TermsOfUse",@"placeHolder",@"",@"TypingText", nil],nil]atIndex:0];
    
    titleArray = [[NSArray alloc]initWithObjects:@"Image",@"First Name",@"Last Name",@"male",@"Date of Birth",@"About You",@"Hobbies",@"Email&Password",@"switch_on",@"TermsOfUse",nil];
    
    NSLog(@"PlaceHolder %@",placeHolderArray);
    [self.tableviewProfile reloadData];
   
}
#pragma mark - cellScroll
-(void) cellScroll
{
    for( UIView *subView in [profileScrollCell subviews]) {
        [subView removeFromSuperview];
    }
    for(int i=0;i<infoArray.count;i++)
    {
        NSLog(@"%d",i);
        NSLog(@"%lu",(unsigned long)infoArray.count);
        int yPosition=-60;
        infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(i*(self.view.frame.size.width)+0, yPosition, self.view.frame.size.width, self.view.frame.size.height)];
        infoImage.tag = i+1;
        UIImageView *image=[[UIImageView alloc] init];
        image.frame=CGRectMake(90, 90, 100, 100);
        //  image.image=[UIImage imageNamed:[infoArray objectAtIndex:i]];
        [infoImage addSubview:image];
        [profileScrollCell addSubview:infoImage];
        
        if(!profileImage){
            image.image=[UIImage imageNamed:[infoArray objectAtIndex:i]];
            //[cell.profileImageview setImage:profileImage];
            [topViewCell setHidden:YES];
            [profileScrollCell setScrollEnabled:NO];
        }
        else{
            if(i==0){
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self
                           action:@selector(selectCamera:)
                 forControlEvents:UIControlEventTouchUpInside];
                UIImage *buttonImage = [UIImage imageNamed:@"camera_icon"];
                [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
                button.frame = CGRectMake(37, 65, 32, 32);
                [image addSubview:button];
                [cell.cameraButton setHidden:YES];
                image.layer.cornerRadius = image.frame.size.width / 2;
                image.clipsToBounds = YES;
                [image setImage:profileImage];
                
            }
    
            else{
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self
                           action:@selector(selectCamera:)
                 forControlEvents:UIControlEventTouchUpInside];
                UIImage *buttonImage = [UIImage imageNamed:@"camera_icon"];
                [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
                button.frame = CGRectMake(37, 65, 32, 32);
                [image addSubview:button];
                image.image=[UIImage imageNamed:[infoArray objectAtIndex:i]];
                
            }
           
                    }
}
    
    [profileScrollCell setContentSize:CGSizeMake((infoArray.count * self.view.frame.size.width), 50)];
    
    xslider=0;
    pgDtView=[[UIView alloc]init];
    pgDtView.backgroundColor=[UIColor clearColor];
    pageImageView =[[UIImageView alloc]init];
    profilePageInfoControl.numberOfPages=infoArray.count;
    
    for(int i=0;i<profilePageInfoControl.numberOfPages;i++)
    {
        blkdot=[[UIImageView alloc]init];
        [blkdot setFrame:CGRectMake(i*13, 0, 7, 7 )];
        [blkdot setImage:[UIImage imageNamed:@"dot_normal"]];
        [pgDtView addSubview:blkdot];
        [pageImageView setFrame:CGRectMake(0, 0,7, 7)];
        [pageImageView setImage:[UIImage imageNamed:@"dot_active_gray"]];
        [pgDtView addSubview:pageImageView];
        [topViewCell addSubview:pgDtView];
        if(IS_IPHONE5) {
        [pgDtView setFrame:CGRectMake(20, -5, profilePageInfoControl.numberOfPages*13, 10)];
        }
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView2
{
    if (scrollView2==profileScrollCell) {    }
    pull=@"";
    jslider = scrollView2.contentOffset.x/320;
    [profileScrollCell setNeedsDisplay];
    profilePageInfoControl.currentPage=jslider;
    [pageImageView setFrame:CGRectMake(jslider*13, 0, 7, 7)];
    
    isTapping=NO;
    scrolldragging=@"YES";
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
                return 70;
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
                return 80;
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
    
    cell = (DSProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *titleText;
    NSString *placeHolderText,*placeHolderTextPass;
   NSString *typingText,*typingTextPass;
    NSString *newMessageImage,*soundImage,*vibrationImage;
    

        typingText       = [[[placeHolderArray valueForKey:@"TypingText" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        typingTextPass   = [[[placeHolderArray valueForKey:@"TypingTextPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
       // typingTextFemale = [[[placeHolderArray valueForKey:@"TypingTextFemale" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

        placeHolderText     =  [[[placeHolderArray valueForKey:@"placeHolder" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        placeHolderTextPass =  [[[placeHolderArray valueForKey:@"placeHolderPass" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
       // placeHolderFemale =  [[[placeHolderArray valueForKey:@"placeHolderFemale" ]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
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
            [self cellScroll];
           
        }
        
        if (IS_IPHONE6 ||IS_IPHONE6_Plus)
        {
            cell.layoutConstraintProfileImageHeight.constant =159;
            cell.layoutConstraintProfileImageWidth.constant =161;
        }
        
//        if(!profileImage){
//            [cell.profileImageview setImage:[UIImage imageNamed:@"profile_noimg"]];
//        }
//        else{
//             [cell.profileImageview setImage:profileImage];
//        }
        
        cell.profileImageview.layer.cornerRadius = cell.profileImageview.frame.size.height / 2;
        cell.profileImageview.layer.masksToBounds = YES;
        cell.cameraButton.userInteractionEnabled = YES;
        [cell.cameraButton setTag:101];
        [cell.cameraButton addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
         [cell.uploadButton addTarget:self action:@selector(selectCamera:) forControlEvents:UIControlEventTouchUpInside];
        
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
        NSLog(@"typingText%@",typingText);
        
        NSLog(@"titleText%@",titleText);
        NSLog(@"placeHolderText%@",placeHolderText);

        if(typingText == (id)[NSNull null] || [typingText isEqualToString:@""])//|| [typingText  isEqual: @"NULL"])
        {
            if(placeHolderText ==(id) [NSNull null])
                cell.textFieldPlaceHolder.placeholder = titleText;
            else
                cell.textFieldPlaceHolder.text = placeHolderText;
            
        
        }
        
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
        
        int labelWidth = 0,labelHeight = 0;
        
        if(IS_IPHONE5){
            
            labelWidth =50;
            labelHeight=14;
            
            
        }
        if(IS_IPHONE6){
            labelWidth =75;
            labelHeight=25;
            
        }
        if(IS_IPHONE6_Plus)
        {
            
            labelWidth =94;
            labelHeight=25;
            
        }
        
        [cell.maleButton setTag:2004];
        [cell.femaleButton setTag:2005];
        
        maleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelWidth,labelHeight)];
        maleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:9.0];
        maleLabel.textAlignment = NSTextAlignmentCenter;
        [maleLabel setText:@"Male"];
        [cell.labelMale addSubview:maleLabel];
        
        femaleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,labelWidth, labelHeight)];
        femaleLabel.font = [UIFont fontWithName:@"Patron-Regular" size:9.0];
        femaleLabel.textAlignment = NSTextAlignmentCenter;
        [femaleLabel setText:@"Female"];
        [cell.labelFemale addSubview:femaleLabel];
        
        if(placeHolderText == (id)[NSNull null]){
            
            femaleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
            maleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
            
        }
        
        else{
         if([placeHolderText isEqualToString:@"Male"])
        {
            femaleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
            maleLabel.textColor = [UIColor redColor];
            
        }
        else if([placeHolderText isEqualToString:@"female"])
        {
            maleLabel.textColor = [UIColor colorWithRed:(float)161.0/255 green:(float)161.0/255 blue:(float)161.0/255 alpha:1.0f];
            femaleLabel.textColor = [UIColor redColor];
            
        }
        }
        
        cell.maleButton.userInteractionEnabled = YES;
        cell.femaleButton.userInteractionEnabled = YES;
        
        
        [cell.maleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.femaleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }


    if (indexPath.row == 4)
    {
        
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSProfileTableViewCell" owner:self options:nil];
            cell = cellDatePicker;
            
        }
        
        
        if([typingText isEqualToString:@""] || typingText == nil)
            cell.textFieldDPPlaceHolder.text = placeHolderText;
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
        
        if(textviewText == nil)
            cell.textViewHeaderLabel.hidden = NO;
        else
            cell.textViewHeaderLabel.hidden = YES;
            
        
        cell.textViewAboutYou.text = textviewText;
        cell.labelAboutYou.text =titleText;
        cell.textViewHeaderLabel.text =placeHolderText;
        cell.textViewAboutYou.delegate = self;
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
        
        NSString *plusIcon = @"Plus_icon.png";
        if ([imageNormalArray count] >=1)
        {
            for(NSString *strPlus in imageNormalArray)
            {
                if([strPlus isEqualToString:@"Plus_icon.png"])
                    [imageNormalArray removeObject:strPlus];
            }
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
           //[imageNormalArray lastObject];
            NSLog(@"lastObject:%@",[imageNormalArray lastObject]);
            if([image isEqualToString:@"Plus_icon.png"])
            {
                [hobbiesImage setImage:[UIImage imageNamed:image]];
            }
            else
            {
               image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
               [hobbiesImage setImageWithURL:[NSURL URLWithString:image]];
            }
            
            if (image == plusIcon) {
                hobbiesImage.userInteractionEnabled = YES;
                pushToHobbiesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
        NSLog(@"typingText%@",typingText);
        NSLog(@"titleText%@",titleText);
        NSLog(@"placeHolderText%@",placeHolderText);
        
        if(typingText == (id)[NSNull null] || [typingText isEqualToString:@""]  || typingText == nil)//|| [typingText  isEqual: @"NULL"])
        {
            if(placeHolderText ==(id) [NSNull null])
                cell.emailTextField.text = [self getEmail];
            else
                cell.emailTextField.text = placeHolderText;
            
        }
        
        else if (typingText!=nil)
        {
            cell.emailTextField.text=typingText;
        }
        if(typingTextPass == (id)[NSNull null] || [typingTextPass isEqualToString:@""]  || typingTextPass == nil)//|| [typingText  isEqual: @"NULL"])
        {
            if(placeHolderText ==(id) [NSNull null])
                cell.passwordTextField.text =[self getPassword];
            else
                cell.passwordTextField.text =@"";
            
        }
        else if (typingTextPass != nil)
        {
            cell.passwordTextField.text=typingTextPass;
        }
//        if([typingText isEqualToString:@""] || typingText == nil)
//        {
//           cell.emailTextField.text = placeHolderText;
//        }
//          else
//          {
//            cell.emailTextField.text = typingText;
//
//          }
//        
//        if([typingTextPass isEqualToString:@""] || typingTextPass == nil)
//        {
//            cell.passwordTextField.text =@"";
//        }
//        else
//        {
//            cell.passwordTextField.text = typingTextPass;
//            
//        }
        
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Tablecell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 6)
    {
        commonWidth = (Tablecell.contentView.frame.size.width - 20) / 14;
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
    
    //DSProfileTableViewCell *cell;
    
    indexPath = [_tableviewProfile indexPathForCell:(UITableViewCell *)button];
    cell = (DSProfileTableViewCell *) [_tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    
    NSArray *titleArray1        = [[NSArray alloc]initWithObjects:@"switch_on",@"switch_off", nil];
    NSArray *notificationArray  = [[NSArray alloc]initWithObjects:@"YES",@"NO", nil];
    NSString *selOptionVal;
    
    if([sender tag] == 2000){
        NSString *place1 =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"NewMessageImage"];
        
        
        if([place1 isEqualToString:@""] || place1 == nil)
        {
            
            NSString *NewMessageImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"placeHolder"];
            
            if (NewMessageImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
                isNotification_message =[notificationArray objectAtIndex:1];
                
            }
            if (NewMessageImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
                isNotification_message =[notificationArray objectAtIndex:0];
            }
            
            
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"NewMessageImage"];
            
        }
        
        
        else
            
        {
            
            NSString *NewMessageImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"NewMessageImage"];
            
            
            if (NewMessageImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
               isNotification_message =[notificationArray objectAtIndex:1];
            }
            if (NewMessageImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
                isNotification_message =[notificationArray objectAtIndex:0];
               // isNotification_message = YES;
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
                isNotification_sound =[notificationArray objectAtIndex:1];
            }
            if (SoundImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
               isNotification_sound = [notificationArray objectAtIndex:0];
            }
            
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"SoundImage"];
        }
        
        
        else
            
        {
            
            NSString *SoundImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"SoundImage"];
            
            
            if (SoundImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
                isNotification_sound = [notificationArray objectAtIndex:1];
            }
            if (SoundImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
                isNotification_sound = [notificationArray objectAtIndex:0];
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
               isNotification_vibration = [notificationArray objectAtIndex:1];
            }
            if (VibrationImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
                isNotification_vibration = [notificationArray objectAtIndex:0];
            }
            
            
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"VibrationImage"];
        }
        
        
        else
            
        {
            
            NSString *VibrationImage =[[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"VibrationImage"];
            
            
            if (VibrationImage == [titleArray1 objectAtIndex:0]) {
                selOptionVal = [titleArray1 objectAtIndex:1];
                isNotification_vibration = [notificationArray objectAtIndex:1];
            }
            if (VibrationImage == [titleArray1 objectAtIndex:1]) {
                selOptionVal = [titleArray1 objectAtIndex:0];
                isNotification_vibration = [notificationArray objectAtIndex:0];;
            }
            if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"VibrationImage"];
            
            
        }
        
        
    }
    
    NSLog(@"placeHolderArray %@",placeHolderArray);
    [_tableviewProfile reloadData];
}

-(void)buttonAction:(UIButton *)sender
{
    
    id button = sender;
    while (![button isKindOfClass:[UITableViewCell class]]) {
        button = [button superview];
    }
    NSIndexPath *indexPath;
     NSString *selOptionVal;
    //DSProfileTableViewCell *cell;
    
    indexPath = [_tableviewProfile indexPathForCell:(UITableViewCell *)button];
    cell = (DSProfileTableViewCell *) [_tableviewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    if([sender tag] == 2004){
        selOptionVal = @"Male";
    }
    
    if([sender tag] == 2005){
       selOptionVal = @"female";
    }
    
                if(selOptionVal != nil || ![selOptionVal isEqualToString:@""])
                    [[[placeHolderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:selOptionVal forKey:@"placeHolder"];
    [_tableviewProfile beginUpdates];
    [_tableviewProfile reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_tableviewProfile endUpdates];
    selectGender =selOptionVal;
    
    //[_tableviewProfile reloadData];
}

#pragma mark - Textview delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
    //DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell.textViewHeaderLabel.hidden = YES;
    
    textviewText = textView.text;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGPoint position = [textView convertPoint:CGPointZero toView: _tableviewProfile ];
    NSIndexPath *indexPath = [_tableviewProfile indexPathForRowAtPoint: position];
    //DSProfileTableViewCell *cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell = (DSProfileTableViewCell *)[_tableviewProfile cellForRowAtIndexPath:indexPath];
    cell.textViewHeaderLabel.hidden = YES;
    
    textviewText = textView.text;
}

#pragma mark - Camera Action
-(void)selectCamera: (UIButton *)sender
{
 
    imagepickerController = [[UIImagePickerController alloc] init];
    imagepickerController.delegate = self;
    [imagepickerController setAllowsEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL",@"") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //[self promptForCamera];
                                                        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                   }];
    
    UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:NSLocalizedString(@"CAMERA",@"") style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          imagepickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          [self presentViewController:imagepickerController animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"PHOTO LIBRARY",@"") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                      // [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                                        imagepickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        [self presentViewController:imagepickerController animated:YES completion:nil];
                                                   }];
    
    [alert addAction:camera];
    [alert addAction:photoRoll];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    image = [info valueForKey:UIImagePickerControllerEditedImage];
     profileImage = image;
    NSLog(@"uploadImg=%@",image);
    
    if(profileImage != nil)
    {
        [self uploadNextImageMethod];
    }
    //[_tableviewProfile reloadData];
    [imagepickerController dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadNextImageMethod
{
   // [self scrollViewDidScroll:cell.profileScrollview];
    [self cellScroll];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//{
//    if (scrollView == cell.profileScrollview) {
//        //IndexVal = scrollView.contentOffset.x/SCREEN_WIDTH;
//        //[topSliderScrollView setNeedsDisplay];
//        //pageController.currentPage = IndexVal;
//        [cell.profileImageview setFrame:CGRectMake(300, 0,cell.profileScrollview.frame.size.width,cell.profileScrollview.frame.size.height)];
//    }
//
//    NSLog(@"scroll");
//}
#pragma mark - gotoHomeView
-(void)gotoHomeView{
    HomeViewController * objHomeview = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:objHomeview animated:NO];
    
}
#pragma mark - registerAPI
-(void) registerAPI{
    
    [objWebService postRegister:Register_API
                           type:strType
                     first_name:FirstName
                      last_name:LastName
                          email:emailAddressToRegister
                       password:emailPasswordToRegister
                      profileId:strProfileID
                            dob:strDOB
                   profileImage:strProfileImage
                         gender:strGender
                       latitude:currentLatitude
                      longitude:currentLongitude
                         device:Device
                       deviceid:deviceUdid
           notification_message:YES
           notification_sound  :YES
         notification_vibration:YES
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"rsponse:%@",responseObject);
         
         NSMutableDictionary *registerDict = [[NSMutableDictionary alloc]init];
         
         registerDict = [responseObject valueForKey:@"register"];
         
         if([[registerDict valueForKey:@"status"]isEqualToString:@"success"]){
             [COMMON setUserDetails:[[registerDict valueForKey:@"userDetails"]objectAtIndex:0]];
             NSLog(@"userdetails = %@",[COMMON getUserDetails]);
             [self gotoHomeView];
         }
     }
     
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            
                        }];

    
}
#pragma mark - saveAction
-(void)saveAction:(id)sender
{
    NSArray *postPerArray;
    postPerArray = [[placeHolderArray objectAtIndex:0]valueForKey:@"TypingText"];
    
    strFirstName = [postPerArray objectAtIndex:1];
    strLastName  = [postPerArray objectAtIndex:2];
    strType      = (selectEmail== YES)?@"1":@"2";
    strProfileID = (FBprofileID!=nil)?FBprofileID:@"";
    strGender    = (selectGender!=nil)?selectGender:@"";
    FirstName    = (strFirstName!=nil)? strFirstName:@"";
    LastName     = (strLastName!=nil)?strLastName:@"";
    strDOB       = (currentTextfield.text !=nil)?currentTextfield.text :@"";
    
    NSLog(@"isNotification_vibration:%@",isNotification_vibration);
    
        if(![FirstName isEqual:[NSNull null]]&&![LastName isEqual:[NSNull null]]&&![strDOB isEqual:[NSNull null]]&&![strGender isEqual:[NSNull null]]&&![emailAddressToRegister isEqual:[NSNull null]]&&![emailPasswordToRegister isEqual:[NSNull null]]){
            [self registerAPI];
        }
    else{
        [self presentViewController:[ DSAppCommon alertWithTitle:@"Title" withMessage:FILL_ALL_DETAILS preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:NULL];
        [COMMON removeLoading];
        return;
    }

}

@end
