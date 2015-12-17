//
//  DSDetailViewController.m
//  DoSomething
//
//  Created by OCS iOS Developer on 15/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "DSDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "DSWebservice.h"
#import "UIImageView+AFNetworking.h"



@interface DSDetailViewController ()
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
    NSString        * strsessionID;
    NSString        * requestUserID;
    
}
@property (strong, nonatomic) IBOutlet UIButton *letsDoButton;
@end

@implementation DSDetailViewController
@synthesize userDetailsDict,letsDoButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    objWebService =[[DSWebservice alloc]init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:USERDETAILS];
    
    strsessionID =[dic valueForKey:@"SessionId"];
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
    
    [self profileImageDisplay];
    [self profileImageScrollView];
    
    CGRect buttonFrame;
    if(IS_IPHONE6||IS_IPHONE6_Plus)
        buttonFrame = CGRectMake( 230, 33, 80, 40 );
    else
        buttonFrame = CGRectMake( 190, 33, 80, 40 );
    //letsDoButton = [[UIButton alloc] init];//WithFrame: buttonFrame];
    letsDoButton = [[UIButton alloc] initWithFrame: buttonFrame];
    //letsDoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [letsDoButton setTitle: @"Let's Do Something!" forState: UIControlStateNormal];
  //  [letsDoButton addTarget:self action:@selector(letsDoSomethingAction:) forControlEvents:UIControlEventTouchUpInside];
    [letsDoButton.titleLabel setFont:[UIFont fontWithName:@"Patron-Bold" size:12]];
    letsDoButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    letsDoButton.titleLabel.numberOfLines = 2;
    letsDoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [letsDoButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    letsDoButton.backgroundColor = [UIColor colorWithRed:218.0f/255.0f
                                                   green:40.0f/255.0f
                                                    blue:64.0f/255.0f
                                                   alpha:1.0f];
    [self.thingsView addSubview:letsDoButton];
    //genderImage
    UIImage *genderImage;
   
    if([[userDetailsDict objectForKey:@"gender"]isEqualToString:@"Female"]){
        genderImage = [UIImage imageNamed:@"female_Icon"];
        
    }
    else
        genderImage = [UIImage imageNamed:@"male_Icon"];
    
    UIImageView *genderImageView = [[UIImageView alloc] initWithImage:genderImage];
    genderImageView.frame = CGRectMake(0.0f, 0.0f,20.0f, 20.0f);
    [self.genderView addSubview:genderImageView];

    
   
    self.aboutTextBox.text = [userDetailsDict valueForKey:@"about"];
    self.userName.text     = [self getData];
    [self.userName setFont:[UIFont fontWithName:@"Patron-Medium" size:14]];
    self.userName.textColor =[UIColor colorWithRed:218.0f/255.0f
                                             green:40.0f/255.0f
                                              blue:64.0f/255.0f
                                             alpha:1.0f];
    //AboutLabel
    self.aboutLabel.text = NSLocalizedString(@"About Me", @"");
    [self.aboutLabel setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
    self.aboutLabel.textColor =[UIColor colorWithRed:83.0f/255.0f
                                               green:83.0f/255.0f
                                                blue:83.0f/255.0f
                                               alpha:1.0f];
    //ThingsLabel
    [self.thingsLabel setText:NSLocalizedString(@"Things I Wanna Do", @"")];
    [self.thingsLabel setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
    self.thingsLabel.textColor =[UIColor colorWithRed:83.0f/255.0f
                                                green:83.0f/255.0f
                                                blue:83.0f/255.0f
                                                alpha:1.0f];
    //MyInterestLabel
    [self.myinterestsLabel setText:NSLocalizedString(@"My Interests and Hobbies", @"")];
    [self.myinterestsLabel setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
    self.myinterestsLabel.textColor =[UIColor colorWithRed:83.0f/255.0f
                                                     green:83.0f/255.0f
                                                      blue:83.0f/255.0f
                                                     alpha:1.0f];
    
    interstAndHobbiesArray  = [[userDetailsDict valueForKey:@"hobbieslist"]mutableCopy];
    hobbiesNameArray        = [[interstAndHobbiesArray valueForKey:@"name"]mutableCopy];
    imageNormalArray        = [[interstAndHobbiesArray valueForKey:@"image"]mutableCopy];
    doSomethingArray        = [[userDetailsDict valueForKey:@"dosomething"]mutableCopy];
    doSomethingNameArray    = [[doSomethingArray valueForKey:@"name"]mutableCopy];
    doSomethingImageArray   = [[doSomethingArray valueForKey:@"ActiveImage"]mutableCopy];
    
    [self profileInterestsDetails];
    [self profileDoSomethingDetails];
    
    [self updateScrollViewContentSize];
   }
#pragma mark - userAgeName
-(NSString *) getData{
    
    NSString *strUserData= @"";
    
    if ([userDetailsDict objectForKey:@"first_name"] != NULL && ![[userDetailsDict objectForKey:@"first_name"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@%@",strUserData,[userDetailsDict objectForKey:@"first_name"]];
    }
    if ([userDetailsDict objectForKey:@"last_name"] != NULL && ![[userDetailsDict objectForKey:@"last_name"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@ %@",strUserData,[userDetailsDict objectForKey:@"last_name"]];
    }
    if ([userDetailsDict objectForKey:@"age"] != NULL && ![[userDetailsDict objectForKey:@"age"] isEqualToString:@""]) {
        strUserData = [NSString stringWithFormat:@"%@, %@",strUserData,[userDetailsDict objectForKey:@"age"]];
    }
    return strUserData;
    
}
#pragma mark - profileImageDisplay

-(void)profileImageDisplay{
    
    NSString *ImageURL1,*ImageURL2,*ImageURL3;
    if([[userDetailsDict valueForKey:@"image1"]isEqual:@""]){
        ImageURL1=@"";
    }
    else{
        ImageURL1=[userDetailsDict valueForKey:@"image1_thumb"];
    }
    if([[userDetailsDict valueForKey:@"image2"]isEqual:@""]){
        ImageURL2=@"";
    }
    else{
        ImageURL2=[userDetailsDict valueForKey:@"image2_thumb"];
    }
    if([[userDetailsDict valueForKey:@"image3"]isEqual:@""]){
        ImageURL3=@"";
    }
    else{
        ImageURL3=[userDetailsDict valueForKey:@"image3_thumb"];
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
        if(IS_IPHONE6_Plus)
        {
            userProfileImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3.5) + spacing, 20,self.profileImageView.frame.size.width, self.profileImageView.frame.size.height)];
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
    }
    self.profileImageScroll.contentSize=CGSizeMake(self.profileImageScroll.frame.size.width*3, self.profileImageScroll.frame.size.height);
    
//    if(CurrentImage == 0)
//        [self.profileImageScroll setContentOffset:CGPointMake(0, 0)animated:NO];
//    else if(CurrentImage == 1)
//        [self.profileImageScroll setContentOffset:CGPointMake(1*self.profileImageView.frame.size.width - 15, 0)animated:NO];
//    else if(CurrentImage == 2)
//        [self.profileImageScroll setContentOffset:CGPointMake((1.5*self.profileImageView.frame.size.width - 15), 0)animated:NO];
    
    if(CurrentImage == 0)
        [self.profileImageScroll setContentOffset:CGPointMake(0, 0)animated:NO];
    else if(CurrentImage == 1)
    {
        if(IS_IPHONE6|| IS_IPHONE6_Plus)
        {
           // [self.scrView setContentOffset:CGPointMake(4.5*self.profileImageView.frame.size.width - 25  , 0)animated:NO];
            [self.profileImageScroll setContentOffset:CGPointMake(4*self.profileImageView.frame.size.width - 15, 0)animated:NO];
        }
        else
        {
            [self.profileImageScroll setContentOffset:CGPointMake(1*self.profileImageView.frame.size.width - 15, 0)animated:NO];
        }
    }
    else if(CurrentImage == 2)
    {
        if(IS_IPHONE6|| IS_IPHONE6_Plus)
        {
            //[self.scrView setContentOffset:CGPointMake(9*self.profileImageView.frame.size.width - 15, 0)animated:NO];
            [self.profileImageScroll setContentOffset:CGPointMake((6*self.profileImageView.frame.size.width - 15), 0)animated:NO];
        }
        else
        {
            
            [self.profileImageScroll setContentOffset:CGPointMake((1.5*self.profileImageView.frame.size.width - 15), 0)animated:NO];
        }
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CurrentImage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (scrollView==self.profileImageScroll) {
        pull=@"";
        jslider = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self.profileImageScroll setNeedsDisplay];
        detailPageControl.currentPage=jslider;
        [pageImageView setFrame:CGRectMake(jslider*18, 0, 8, 8)];
        
        isTapping=NO;
        scrolldragging=@"YES";
    }
}

#pragma mark - profileDoSomethingDetails
-(void)profileDoSomethingDetails{
    
    imageSize =39;
    commonWidth=19.5;
    //commonHeight = 54;
    yAxis = 31;
    commonWidth=19.5;
    
    space = imageSize / 2;
    commonHeight = imageSize+15;
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
        
        [self.thingsView addSubview:doSomethingImage];
        
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
        [self.thingsView addSubview:doSomethingName];
        doSomethingName.textAlignment = NSTextAlignmentCenter;
    }

}
#pragma mark - profileInterestsDetails
-(void)profileInterestsDetails{
    imageSize =39;
    commonWidth=19.5;
    //commonHeight = 54;
    yAxis = 31;
    commonWidth=19.5;
    space = imageSize / 2;
    commonHeight = imageSize+15;
    //imageNormalArray
    UIView *myInterestsView;
    
    if([imageNormalArray count]<=1){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 367, 290, 10)];
    }
    if([imageNormalArray count] <=4){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 367, 290, 50)];
    }
    if([imageNormalArray count] <9 && [imageNormalArray count] >=5){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 367, 290,50)];
    }
    if([imageNormalArray count] <9 && [imageNormalArray count] >5){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 367, 290,160)];
    }
    if([imageNormalArray count] ==10){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 367, 290,160)];
    }
    if([imageNormalArray count] >10){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 367, 290,200)];
    }
    if([imageNormalArray count] >15){
        myInterestsView=[[UIView alloc]initWithFrame:CGRectMake(14, 368, 290,265)];
    }
    UILabel *myInterests = [[UILabel alloc] initWithFrame:CGRectMake(10,5,170,20)];
    //myInterests.autoresizingMask = paintView.autoresizingMask;
    myInterests.text = NSLocalizedString(@"My Interest and Hobbies", @"");
    [myInterests setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
    myInterests.textColor =[UIColor colorWithRed:83.0f/255.0f
                                           green:83.0f/255.0f
                                            blue:83.0f/255.0f
                                           alpha:1.0f];
    
    [myInterestsView addSubview:myInterests];
    [myInterestsView setBackgroundColor:[UIColor whiteColor]];
    [self.detailPageMainScroll addSubview:myInterestsView];
    
    
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
           // [self.myInterestView addSubview:hobbiesImage];
            [myInterestsView addSubview:hobbiesImage];
       
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
        [myInterestsView addSubview:hobbiesname];
        
        hobbiesname.textAlignment = NSTextAlignmentCenter;
        
        
    }
    if([hobbiesNameArray count] <=5){
        self.detailPageMainScroll.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
        
        
    }
    if([hobbiesNameArray count] <=10 && [hobbiesNameArray count] >5){
        self.detailPageMainScroll.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        
        
    }
    
    if([hobbiesNameArray count] >10){
        self.detailPageMainScroll.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        
        

    }
    if([hobbiesNameArray count] >15){
        self.detailPageMainScroll.contentInset = UIEdgeInsetsMake(0, 0, 125, 0);
        
    }
}

#pragma mark - letsDoSomethingAction
- (void)letsDoSomethingAction:(id)sender
{
    requestUserID = [userDetailsDict valueForKey:@"user_id"];
    
   [objWebService sendRequest:SendRequest_API
                    sessionid:strsessionID
         request_send_user_id:requestUserID
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"SEND REQ%@",responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, id error) {
                          NSLog(@"SEND REQ ERR%@",error);
                      }];
    
}

- (void) updateScrollViewContentSize {
    
    
    
    //myInterestView.origin.y + myInterestView.size.height
        
//        self.detailPageMainScroll.contentSize = CGSizeMake(self.view.frame.size.width,
//                                                  self.detailPageMainScroll.frame.size.height +
//                                                  self.fullView.frame.size.height +150
//                                                  );
}

#pragma mark - back Action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [COMMON removeLoading];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
