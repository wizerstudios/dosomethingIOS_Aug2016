//
//  DSNearByDetailViewController.m
//  DoSomething
//
//  Created by OCS iOS Developer on 21/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "DSNearByDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "DSWebservice.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+FontAwesome.h"
#import "DSNearbyCustomCell.h"
#import "AppDelegate.h"
#import "DSNearByImageView.h"


@interface DSNearByDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    DSWebservice    * objWebService;
    NSMutableArray  * profileDataArray;
    UIImageView     * userProfileImage;
    
    NSMutableArray  * interstAndHobbiesArray;
    NSMutableArray  * imageNormalArray,*hobbiesNameArray;
    
    NSMutableArray  * doSomethingArray;
    NSMutableArray  * doSomethingImageArray,* doSomethingNameArray;
    
    float commonWidth, commonHeight;
    float yAxis;
    float imageSize;
    float space;
    
    NSString        * requestUserID;
    CGSize              dataSize;
    UIImage *genderImage;
    NSMutableArray *valueArray;
    
    DSNearbyCustomCell *NearbyCustomcell;
    NSString *requestStr;
    AppDelegate *appDelegate;
    
    UIWindow *windowInfo;
    UIButton * profilebutton1,* profilebutton2,* profilebutton3;
    NSString *profileImageString;
    

}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) DSNearByImageView *nearByImageView;

@end

@implementation DSNearByDetailViewController
@synthesize userDetailsArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    objWebService =[[DSWebservice alloc]init];
    valueArray=[[NSMutableArray alloc]initWithObjects:@"cell0",@"cell1",@"cell2",@"cell3", nil];
    
   
   
    // Do any additional setup after loading the view from its nib.
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
        customNavigation.view.frame = CGRectMake(0,-20, 375, 76);
        
    }
    if(IS_IPHONE6_Plus)
    {
        customNavigation.view.frame = CGRectMake(0,-20, 420, 83);
        
    }
    [customNavigation.menuBtn setHidden:YES];
    [customNavigation.buttonBack setHidden:NO];
    [customNavigation.saveBtn setHidden:YES];
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    interstAndHobbiesArray  = [[userDetailsArray valueForKey:@"hobbieslist"]mutableCopy];
    hobbiesNameArray        = [[interstAndHobbiesArray valueForKey:@"name"]mutableCopy];
    imageNormalArray        = [[interstAndHobbiesArray valueForKey:@"image"]mutableCopy];
    doSomethingArray        = [[userDetailsArray valueForKey:@"dosomething"]mutableCopy];
    doSomethingNameArray    = [[doSomethingArray valueForKey:@"name"]mutableCopy];
    doSomethingImageArray   = [[doSomethingArray valueForKey:@"ActiveImage"]mutableCopy];

    
    [self profileImageDisplay];
    self.profileImgSelectview.hidden=YES;
   
}

#pragma mark - userAgeName
-(NSString *) getData{
    
    NSString *strUserData=@"";
    if ([userDetailsArray valueForKey:@"first_name"] != NULL && ![[userDetailsArray valueForKey:@"first_name"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@ %@",strUserData,[userDetailsArray valueForKey:@"first_name"]];
    }
    if ([userDetailsArray valueForKey:@"last_name"] != NULL && ![[userDetailsArray valueForKey:@"last_name"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@ %@",strUserData,[userDetailsArray valueForKey:@"last_name"]];
    }
    if ([userDetailsArray valueForKey:@"age"] != NULL && ![[userDetailsArray valueForKey:@"age"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@, %@",strUserData,[userDetailsArray valueForKey:@"age"]];
    }
    return strUserData;
    
}
#pragma mark - profileImageDisplay

-(void)profileImageDisplay{
    
    NSString *ImageURL1,*ImageURL2,*ImageURL3;
    if([[userDetailsArray valueForKey:@"image1"]isEqual:@""]){
        ImageURL1=@"";
    }
    else{
        ImageURL1=[userDetailsArray valueForKey:@"image1_thumb"];
    }
    if([[userDetailsArray valueForKey:@"image2"]isEqual:@""]){
        ImageURL2=@"";
    }
    else{
        ImageURL2=[userDetailsArray valueForKey:@"image2_thumb"];
    }
    if([[userDetailsArray valueForKey:@"image3"]isEqual:@""]){
        ImageURL3=@"";
    }
    else{
        ImageURL3=[userDetailsArray valueForKey:@"image3_thumb"];
    }
    profileDataArray = [[NSMutableArray alloc]initWithObjects:ImageURL1,ImageURL2,ImageURL3, nil];
    
}
#pragma mark - profileImageScrollView
-(void)profileImageScrollView{
    
    self.profileImageScroll.pagingEnabled=YES;
    self.profileImageScroll.delegate=self;
    self.profileImageScroll.scrollEnabled=YES;
    
    int spacing = 20;
    for(int i = 0; i < 3; i++)
    {
        
        NSData * profileData = [profileDataArray objectAtIndex:i];
        NSString *image     = [profileDataArray objectAtIndex:i];
        if(IS_IPHONE6||IS_IPHONE6_Plus)
            
        {
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.profileImageScroll.frame.size.width) + spacing+30, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];

        }
        
        else
        {
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*self.profileImageScroll.frame.size.width) + spacing, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
        }
        [userProfileImage setTag:i+100];
        if([profileData length] == 0){
            [userProfileImage setImage:[UIImage imageNamed:@"profile_noimg"]];
        }
        else{
            downloadImageFromUrl(image, userProfileImage);
            [userProfileImage setImageWithURL:[NSURL URLWithString:image]];
        }
        [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height / 2;
        userProfileImage.layer.masksToBounds = YES;
        [userProfileImage setUserInteractionEnabled:YES];
        [self.profileImageScroll addSubview:userProfileImage];
        profilebutton1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f ,130, 140)];
        profilebutton2 = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f ,130, 140)];
        profilebutton3 = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f ,130, 140)];
        [profilebutton1 addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
        [profilebutton2 addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
        [profilebutton3 addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
        profilebutton1.tag=101;
        profilebutton2.tag=102;
        profilebutton3.tag=103;


        
        if(i==0 &&[profileDataArray objectAtIndex:0]){
            
            [userProfileImage addSubview:profilebutton1];
            
        }
        if(i==1 &&[profileDataArray objectAtIndex:1]){
            [userProfileImage addSubview:profilebutton2];
            
        }
        if(i==2 &&[profileDataArray objectAtIndex:2]){
            
            [userProfileImage addSubview:profilebutton3];
        }
        
       
        
    }
    self.profileImageScroll.contentSize=CGSizeMake(self.profileImageScroll.frame.size.width*3, self.profileImageScroll.frame.size.height);
    
    
    if(CurrentImage == 0)
        [self.profileImageScroll setContentOffset:CGPointMake(0, 0)animated:NO];
    else if(CurrentImage == 1)
    {
            [self.profileImageScroll setContentOffset:CGPointMake(1*self.profileImageView.frame.size.width - 15, 0)animated:NO];
    }
    else if(CurrentImage == 2)
    {
            [self.profileImageScroll setContentOffset:CGPointMake((1.5*self.profileImageView.frame.size.width - 15), 0)animated:NO];
    }
    xslider=0;
    pgDtView=[[UIView alloc]init];
    pgDtView.backgroundColor=[UIColor clearColor];
    pageImageView =[[UIImageView alloc]init];
    detailPageControl.numberOfPages=profileDataArray.count;
    
    for(int i=0;i<detailPageControl.numberOfPages;i++)
    {
        blkdot=[[UIImageView alloc]init];
        [blkdot setFrame:CGRectMake(i*18, 0, 8, 8 )];
        [blkdot setImage:[UIImage imageNamed:@"dot_normal"]];
        
        [pgDtView addSubview:blkdot];
        [pageImageView setFrame:CGRectMake(0, 0, 8, 8)];
        [pageImageView setImage:[UIImage imageNamed:@"dot_active_red"]];
        [pgDtView addSubview:pageImageView];
        [_topViewCell addSubview:pgDtView];
        if(IS_IPHONE6||IS_IPHONE6_Plus) {
            [pgDtView setFrame:CGRectMake(40, -5, detailPageControl.numberOfPages*18, 10)];
           // [pgDtView setFrame:CGRectMake(60, -5, detailPageControl.numberOfPages*18, 10)];//IS_IPHONE6_Plus
            
        }
        else{
            [pgDtView setFrame:CGRectMake(15, -5, detailPageControl.numberOfPages*18, 10)];
        }
        
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CurrentImage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (scrollView==self.profileImageScroll) {
        
    }
    pull=@"";
    jslider = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.profileImageScroll setNeedsDisplay];
    detailPageControl.currentPage=jslider;
    [pageImageView setFrame:CGRectMake(jslider*18, 0, 8, 8)];
    
    isTapping=NO;
    scrolldragging=@"YES";
}
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row ==0)
    {
        return 200;
    }
    if ( indexPath.row ==1)
    {
        NSString *objstr=[userDetailsArray valueForKey:@"about"];
         dataSize = [COMMON getControlHeight:objstr withFontName:@"Patron-Medium" ofSize:10.0 withSize:CGSizeMake(150,tableView.frame.size.height+60)];
        if([objstr isEqualToString:@""]|| dataSize.height <=24)
        {
            return 30 ;
        }
        
        
        else
        {
            self.aboutTextHeight.constant=dataSize.height+45;
            self.aboutviewHeight.constant=self.aboutTextHeight.constant;
            
            return self.aboutviewHeight.constant-10;
       }
        
    }
    if ( indexPath.row ==2)
    {
        
        return 100;
    }
    if ( indexPath.row ==3)
    {
        imageSize =39;
        commonWidth=19.5;
        commonHeight = 54;
        if([imageNormalArray count] < 1)
            return 80;
        else if([imageNormalArray count] <= 5)
            return commonHeight + 56;
        else if([imageNormalArray count] <= 10)
            return (commonHeight*2)+56;
        else if([imageNormalArray count] <= 15)
            return (commonHeight * 3)+58;
        else if([imageNormalArray count] <= 20)
            return (commonHeight * 4)+62;
    }
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    NearbyCustomcell = (DSNearbyCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row == 0)
    {
        if (NearbyCustomcell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSNearbyCustomCell" owner:self options:nil];
            NearbyCustomcell = cellNearbyProfileImg;
        }
        [detailPageControl setHidden:YES];
        [self profileImageScrollView];
        
        //To display gender with name
        NSString *strUserGender;
        
        if([[userDetailsArray valueForKey:@"gender"]isEqualToString:@"Female"]){
            strUserGender= [NSString stringWithFormat:@"%@", @"\uf221"];
            
        }
        else{
            strUserGender = [NSString stringWithFormat:@"%@", @"\uf222"];
        }
        
        UIFont *awesomeFont = [UIFont fontWithName:@"FontAwesome" size:16];
        NSDictionary *awesomeFontDict = [NSDictionary dictionaryWithObject:awesomeFont forKey:NSFontAttributeName];
        NSMutableAttributedString *awAttrString = [[NSMutableAttributedString alloc] initWithString:strUserGender attributes: awesomeFontDict];
        
        UIFont *patronFont = [UIFont fontWithName:@"patron-Medium" size:14];
        NSDictionary *patronFontDict = [NSDictionary dictionaryWithObject:patronFont forKey:NSFontAttributeName];
        NSMutableAttributedString *patAttrString = [[NSMutableAttributedString alloc]initWithString: [self getData] attributes:patronFontDict];
        
        [awAttrString appendAttributedString:patAttrString];
        self.nameAgeLabel.attributedText = awAttrString;
       
    }
    if (indexPath.row == 1)
    {
        
        if (NearbyCustomcell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSNearbyCustomCell" owner:self options:nil];
            NearbyCustomcell = cellAbout;
        }
       
        NSString *strAbout=[userDetailsArray valueForKey:@"about"];
        NearbyCustomcell.aboutText.text = strAbout;
        NearbyCustomcell.aboutText.textColor=[UIColor lightGrayColor];
        
       
        
    }
    
    if (indexPath.row == 2 )
    {
        if (NearbyCustomcell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSNearbyCustomCell" owner:self options:nil];
            NearbyCustomcell = cellDosomething;
        }
        
        requestStr= [userDetailsArray valueForKey:@"send_request"];
        if([requestStr isEqualToString:@"Yes"])
        {
            [NearbyCustomcell.letsDoSomethingButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f
                                                                                       green:83.0f/255.0f
                                                                                        blue:83.0f/255.0f
                                                                                       alpha:1.0f]];
            [NearbyCustomcell.letsDoSomethingButton setTitle:@"Request\n    Sent" forState:UIControlStateNormal];
        }
        else
        {
            [NearbyCustomcell.letsDoSomethingButton setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f
                                                                                       green:64.0f/255.0f
                                                                                        blue:81.0f/255.0f
                                                                                       alpha:1.0f]];
            [NearbyCustomcell.letsDoSomethingButton setTitle:@"   Let's Do \n Something" forState:UIControlStateNormal];
        }
        
        imageSize =39;
        yAxis = 31;
      //  commonWidth=19.5;
        space = imageSize / 2;
        commonHeight = imageSize+15;
        if(IS_IPHONE6_Plus){
            
            commonWidth=39.5;
        }
        else if (IS_IPHONE6){
            
            commonWidth=29.5;
        }
        else{
            
            commonWidth=19.5;
        }
        
        //doSomethingImageArray
        for (int i =0; i< [doSomethingImageArray  count]; i++) {
            
            UIImageView *doSomethingImage;
            
            if(i <= 3)
                doSomethingImage = [[UIImageView alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize))+ 10, yAxis, imageSize, imageSize)];
            
            else
                doSomethingImage = [[UIImageView alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize))+ 10, yAxis+((imageSize+space) * 3), imageSize, imageSize)];
            NSString *image =[doSomethingImageArray objectAtIndex:i];
            
            
            image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [doSomethingImage setImageWithURL:[NSURL URLWithString:image]];
            
            [NearbyCustomcell addSubview:doSomethingImage];
            
        }
        //doSomethingNameArray
        for (int i =0; i< [doSomethingNameArray  count]; i++) {
            
            NSString *image =[[doSomethingNameArray objectAtIndex:i]uppercaseString];
            UILabel *doSomethingName;
            
            if(i <= 3)
                doSomethingName = [[UILabel alloc]initWithFrame:CGRectMake((i*(commonWidth + imageSize)), yAxis + imageSize, imageSize + 20, 15)];
            
            else
                doSomethingName = [[UILabel alloc]initWithFrame:CGRectMake(((i-15)*(commonWidth + imageSize)), yAxis+((imageSize+space) * 3)+imageSize, imageSize + 20, 15)];
            
            [doSomethingName setFont:[UIFont fontWithName:@"Patron-Regular" size:7]];
            doSomethingName.textAlignment = NSTextAlignmentCenter;
            doSomethingName.textColor = [UIColor colorWithRed:218.0f/255.0f
                                                        green:40.0f/255.0f
                                                         blue:64.0f/255.0f
                                                        alpha:1.0f];
            doSomethingName.text = image;
            [NearbyCustomcell addSubview:doSomethingName];
            doSomethingName.textAlignment = NSTextAlignmentCenter;
        }
    
    }
    if (indexPath.row == 3)
    {
        
        if (NearbyCustomcell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"DSNearbyCustomCell" owner:self options:nil];
            NearbyCustomcell = cellInterestHobbies;
        }
        
        imageSize =39;
        commonWidth=19.5;
        //commonHeight = 54;
        yAxis = 31;
        //commonWidth=19.5;
        space = imageSize / 2;
        commonHeight = imageSize+15;
        
        
        if(IS_IPHONE6_Plus){
           
            commonWidth=39.5;
        }
        else if (IS_IPHONE6){
            
            commonWidth=29.5;
        }
        else{
            
            commonWidth=19.5;
        }

        
        for (int i =0; i< [imageNormalArray  count]; i++) {
            
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
            
            
            image= [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [hobbiesImage setImageWithURL:[NSURL URLWithString:image]];
            
            [NearbyCustomcell addSubview:hobbiesImage];
            
        }
        //hobbiesNameArray
        for (int i =0; i< [hobbiesNameArray  count]; i++) {
            
            NSString *image =[[hobbiesNameArray objectAtIndex:i]uppercaseString];
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
            hobbiesname.textColor =[UIColor colorWithRed:(float)102.0/255
                                                   green:(float)102.0/255
                                                    blue:(float)102.0/255
                                                   alpha:1.0f];
            
            hobbiesname.text = image;
            
            //[self.myInterestView addSubview:hobbiesname];
            [NearbyCustomcell addSubview:hobbiesname];
             hobbiesname.textAlignment = NSTextAlignmentCenter;
            
            
        }
    }
    NearbyCustomcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return NearbyCustomcell;
    
}

-(IBAction)changeSize:(UIButton *)sender
{
    self.profileImgSelectview.hidden=NO;
   
//    UIView * selectprofileImg=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,368)];
    //windowInfo = [[[UIApplication sharedApplication] delegate] window];

   // DSNearByImageView *nearByImageView = [[DSNearByImageView alloc] init];
    
    if([sender tag] ==101){
        
        profileImageString= [userDetailsArray valueForKey:@"image1"];
        
    }
    else if([sender tag] ==102){
        profileImageString= [userDetailsArray valueForKey:@"image2"];
        
    }
    else if([sender tag] ==103){
        profileImageString= [userDetailsArray valueForKey:@"image3"];
        
    }
    if([profileImageString isEqualToString:@""]){
        [self.selectImg setImage:[UIImage imageNamed:@"profile_noimg"]];
    }
    else{
        downloadImageFromUrl(profileImageString, self.selectImg);
        [self.selectImg setImageWithURL:[NSURL URLWithString:profileImageString]];
        
    }

    self.selectImgBgview.layer.cornerRadius =225;
    self.selectImgBgview.layer.masksToBounds = YES;
    
   // self.selectuserName.tintColor=[UIColor colorWithRed:218.0f/255.0f
                                 //   green:40.0f/255.0f
                                   //  blue:64.0f/255.0f
                                    //alpha:1.0f];
    //  label.backgroundColor = [UIColor whiteColor];
    //[self.selectuserName setFont:[UIFont fontWithName:@"patron-bold" size:16]];
    
    //label.text= [self getData];
    //[label setTextAlignment:NSTextAlignmentCenter];
   // label.userInteractionEnabled = YES;
    
    NSString *strUserGender;
    if(IS_IPHONE5)
        
        [self.selectuserName setFont:[UIFont fontWithName:@"FontAwesome" size:14]];
    
    else
        
        [self.selectuserName setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    
    
    if([[userDetailsArray valueForKey:@"gender"]isEqualToString:@"Female"]){
        strUserGender= [NSString stringWithFormat:@"%@", @"\uf221"];
        
    }
    else{
        strUserGender = [NSString stringWithFormat:@"%@", @"\uf222"];
    }
    
    UIFont *awesomeFont = [UIFont fontWithName:@"FontAwesome" size:14];
    NSDictionary *awesomeFontDict = [NSDictionary dictionaryWithObject:awesomeFont forKey:NSFontAttributeName];
    NSMutableAttributedString *awAttrString = [[NSMutableAttributedString alloc] initWithString:strUserGender attributes: awesomeFontDict];
    
    UIFont *patronFont = [UIFont fontWithName:@"patron-bold" size:14];
    NSDictionary *patronFontDict = [NSDictionary dictionaryWithObject:patronFont forKey:NSFontAttributeName];
    NSMutableAttributedString *patAttrString = [[NSMutableAttributedString alloc]initWithString: [self getData] attributes:patronFontDict];
    
    [awAttrString appendAttributedString:patAttrString];
    
    
    self.selectuserName.attributedText = awAttrString;
    
    
    //nearByImageView.userDetailsImageArray   = userDetailsArray;
    
   // nearByImageView.profileImageStringValue = profileImageString;
   
    //[selectprofileImg addSubview:nearByImageView];
    
    [self.selectImgCloseBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self setNearByImageView:nearByImageView];
    
//    NSDictionary *dictView = @{@"_terms":nearByImageView};
//    
//    [windowInfo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_terms]|"
//                                
//                                                                       options:0
//                                
//                                                                       metrics:nil views:dictView]];
//    
//    [windowInfo addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_terms]|"
//                                
//                                                                       options:0
//                                
//                                                                       metrics:nil views:dictView]];
    
}
#pragma mark - letsDoSomethingAction
-(IBAction)letsDoSomethingAction:(id)sender
{
    if(![requestStr isEqualToString:@"Yes"])
    {
        UIButton *buttonSender = (UIButton *)sender;
        NearbyCustomcell.letsDoSomethingButton = buttonSender;
        [NearbyCustomcell.letsDoSomethingButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f
                                                                                   green:83.0f/255.0f
                                                                                    blue:83.0f/255.0f
                                                                                   alpha:1.0f]];
        [NearbyCustomcell.letsDoSomethingButton setTitle:@"Request\n    Sent" forState:UIControlStateNormal];
        
        requestUserID = [userDetailsArray valueForKey:@"user_id"];
        
        [objWebService sendRequest:SendRequest_API
                         sessionid:[COMMON getSessionID]
              request_send_user_id:requestUserID
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"SEND REQ%@",responseObject);
                               
                           } failure:^(AFHTTPRequestOperation *operation, id error) {
                               NSLog(@"SEND REQ ERR%@",error);
                           }];

    }
    
}
#pragma  mark - backAction
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [COMMON removeLoading];
    
}

-(IBAction)closeButtonAction:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.nearByImageView removeFromSuperview];
        
    });
    self.profileImgSelectview.hidden=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
