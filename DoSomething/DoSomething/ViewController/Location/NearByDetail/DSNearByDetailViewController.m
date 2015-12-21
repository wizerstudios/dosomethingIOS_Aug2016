//
//  DSNearByDetailViewController.m
//  DoSomething
//
//  Created by OCS iOS Developer on 21/12/15.
//  Copyright © 2015 OClock Apps. All rights reserved.
//

#import "DSNearByDetailViewController.h"
#import "DSDetailViewController.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"
#import "DSAppCommon.h"
#import "DSWebservice.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+FontAwesome.h"

@interface DSNearByDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
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
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSNearByDetailViewController
@synthesize userDetailsDict;
- (void)viewDidLoad {
    [super viewDidLoad];
    objWebService =[[DSWebservice alloc]init];
    valueArray=[[NSMutableArray alloc]initWithObjects:@"cell0",@"cell1",@"cell2", nil];

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
    self.nameAgeLabel.text=[self getData];
    
    interstAndHobbiesArray  = [[userDetailsDict valueForKey:@"hobbieslist"]mutableCopy];
    hobbiesNameArray        = [[interstAndHobbiesArray valueForKey:@"name"]mutableCopy];
    imageNormalArray        = [[interstAndHobbiesArray valueForKey:@"image"]mutableCopy];
    doSomethingArray        = [[userDetailsDict valueForKey:@"dosomething"]mutableCopy];
    doSomethingNameArray    = [[doSomethingArray valueForKey:@"name"]mutableCopy];
    doSomethingImageArray   = [[doSomethingArray valueForKey:@"ActiveImage"]mutableCopy];

    
    if([[userDetailsDict objectForKey:@"gender"]isEqualToString:@"Female"]){
        _genderImageView.image = [UIImage imageNamed:@"female_Icon"];
        
    }
    else
        _genderImageView.image = [UIImage imageNamed:@"male_Icon"];

    _tableView = [[UITableView alloc] init];//WithFrame:CGRectMake(10, 245, 300, 200)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];     _tableView.bounces = NO;
   // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.mainScroll addSubview:_tableView];
    [self setupConstraints];


    
   // [self profileInterestsDetails];
  //  [self profileDoSomethingDetails];
    
    // [self updateScrollViewContentSize];
    // [self aboutTestText];
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
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.row ==0)
    {
        return 80;
 
    }
    if ( indexPath.row ==1)
    {

        return 85;
    }
    if ( indexPath.row ==2)
    {
        imageSize =39;
        commonWidth=19.5;
        commonHeight = 54;
        if([imageNormalArray count] < 1)
            return 80;
        else if([imageNormalArray count] <= 5)
            return commonHeight + 46;
        else if([imageNormalArray count] <= 10)
            return (commonHeight*2)+46;
        else if([imageNormalArray count] <= 15)
            return (commonHeight * 3)+48;
        else if([imageNormalArray count] <= 20)
            return (commonHeight * 4)+52;
    }

    return 80;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [valueArray count];
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    if (indexPath.row == 0 )
    {
        UILabel *About = [[UILabel alloc] initWithFrame:CGRectMake(10,5,170,20)];
        //myInterests.autoresizingMask = paintView.autoresizingMask;
        About.text = NSLocalizedString(@"About Me", @"");
        [About setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
        About.textColor =[UIColor colorWithRed:83.0f/255.0f
                                               green:83.0f/255.0f
                                                blue:83.0f/255.0f
                                               alpha:1.0f];
        
        [cell addSubview:About];
        
        
    }
    if (indexPath.row == 1 )
    {
        imageSize =39;
        commonWidth=19.5;
        //commonHeight = 54;
        yAxis = 31;
        commonWidth=19.5;
        
        space = imageSize / 2;
        commonHeight = imageSize+15;
        
        
        UILabel *myThings = [[UILabel alloc] initWithFrame:CGRectMake(10,5,170,20)];
        //myInterests.autoresizingMask = paintView.autoresizingMask;
        myThings.text = NSLocalizedString(@"Things I Wanna Do", @"");
        [myThings setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
        myThings.textColor =[UIColor colorWithRed:83.0f/255.0f
                                               green:83.0f/255.0f
                                                blue:83.0f/255.0f
                                               alpha:1.0f];
        
        [cell addSubview:myThings];

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
            
            [cell addSubview:doSomethingImage];
            
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
            [cell addSubview:doSomethingName];
            doSomethingName.textAlignment = NSTextAlignmentCenter;
        }

       

   // cell.textLabel.text = @"Testing";
    
    }
    if (indexPath.row == 2 )
    {
        imageSize =39;
        commonWidth=19.5;
        //commonHeight = 54;
        yAxis = 31;
        commonWidth=19.5;
        space = imageSize / 2;
        commonHeight = imageSize+15;
        
        UILabel *myInterests = [[UILabel alloc] initWithFrame:CGRectMake(10,10,170,20)];
        //myInterests.autoresizingMask = paintView.autoresizingMask;
        myInterests.text = NSLocalizedString(@"My Interest and Hobbies", @"");
        [myInterests setFont:[UIFont fontWithName:@"Patron-Medium" size:12]];
        myInterests.textColor =[UIColor colorWithRed:83.0f/255.0f
                                               green:83.0f/255.0f
                                                blue:83.0f/255.0f
                                               alpha:1.0f];
        
        [cell addSubview:myInterests];
        
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
            
            [cell addSubview:hobbiesImage];
            
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
            [cell addSubview:hobbiesname];
            
            hobbiesname.textAlignment = NSTextAlignmentCenter;
            
            
        }

    
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView setBounces:NO];

    return cell;
    
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}


-(void) setupConstraints{
    
    
    // Width constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.mainScroll
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.9
                                                      constant:0]];
    

    
    
    
    
    // Height constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.mainScroll
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.7 //0.928
                                                      constant:0]];
    
    // Center horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.mainScroll
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    
    // Center vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.mainScroll
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.5 //1.105
                                                          constant:0.0]];
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [COMMON removeLoading];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
