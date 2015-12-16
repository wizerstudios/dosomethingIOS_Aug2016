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
    NSMutableArray *profileDataArray;
    UIImageView    *userProfileImage;
    
}
@end

@implementation DSDetailViewController
@synthesize userDetailsDict;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self profileScroll];
   // [self profileDetails];
    self.aboutTextBox.text = [userDetailsDict valueForKey:@"about"];
    self.userName.text     = [self getData];
    self.userName.textColor =[UIColor colorWithRed:218.0f/255.0f
                                             green:40.0f/255.0f
                                              blue:64.0f/255.0f
                                             alpha:1.0f];
    //AboutLabel
    self.aboutLabel.text = NSLocalizedString(@"About You", @"");
    self.aboutLabel.textColor =[UIColor colorWithRed:83.0f/255.0f
                                                 green:83.0f/255.0f
                                                  blue:83.0f/255.0f
                                                 alpha:1.0f];
    //ThingsLabel
    [self.thingsLabel setText:NSLocalizedString(@"Things I Wanna Do", @"")];
    self.thingsLabel.textColor =[UIColor colorWithRed:83.0f/255.0f
                                                 green:83.0f/255.0f
                                                  blue:83.0f/255.0f
                                                 alpha:1.0f];
    //MyInterestLabel
    [self.myinterestsLabel setText:NSLocalizedString(@"My Interests and Hobbies", @"")];
    self.myinterestsLabel.textColor =[UIColor colorWithRed:83.0f/255.0f
                                                green:83.0f/255.0f
                                                 blue:83.0f/255.0f
                                                alpha:1.0f];
    
}
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
//    ImageURL1=[userDetailsDict valueForKey:@"image1"];
//    ImageURL2=[userDetailsDict valueForKey:@"image2"];
//    ImageURL3=[userDetailsDict valueForKey:@"image3"];
    
    profileDataArray = [[NSMutableArray alloc]initWithObjects:ImageURL1,ImageURL2,ImageURL3, nil];

}
-(void)profileDetails{
    
   

}
-(void)profileScroll{
    
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
    
    if(CurrentImage == 0)
        [self.profileImageScroll setContentOffset:CGPointMake(0, 0)animated:NO];
    else if(CurrentImage == 1)
        [self.profileImageScroll setContentOffset:CGPointMake(1*self.profileImageView.frame.size.width - 15, 0)animated:NO];
    else if(CurrentImage == 2)
        [self.profileImageScroll setContentOffset:CGPointMake((1.5*self.profileImageView.frame.size.width - 15), 0)animated:NO];
    

   
    
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
