//
//  DSInterestAndHobbiesViewController.m
//  DoSomething
//
//  Created by OCSDEV2 on 17/10/15.
//  Copyright (c) 2015 OClock Apps. All rights reserved.
//

#import "DSInterestAndHobbiesViewController.h"
#import "DSInterestAndHobbiesCollectionViewCell.h"
#import "CustomNavigationView.h"
#import "DSConfig.h"

@interface DSInterestAndHobbiesViewController ()
{
    
    NSMutableArray *interstAndHobbiesArray;
    NSArray *sectionArray;
}
@end

@implementation DSInterestAndHobbiesViewController
@synthesize interestAndHobbiesCollectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.interestAndHobbiesCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(self.interestAndHobbiesCollectionView.bounds.size.width, 40);
    [self.interestAndHobbiesCollectionView setCollectionViewLayout:flowLayout];
    [self loadNavigation];
    [self initializeArray];
}

-(void)loadNavigation{
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CustomNavigationView *customNavigation;
    customNavigation = [[CustomNavigationView alloc] initWithNibName:@"CustomNavigationView" bundle:nil];
    customNavigation.view.frame = CGRectMake(0,-20, (self.view.frame.size.width), 65);
    if (IS_IPHONE6 ||IS_IPHONE6_Plus){
        customNavigation.view.frame = CGRectMake(0,-20, 375, 83);
        self.layoutConstraintcollectionviewYPos.constant =83;
    }
    [self.navigationController.navigationBar addSubview:customNavigation.view];
    [customNavigation.buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)initializeArray{
    UINib *cellNib = [UINib nibWithNibName:@"DSInterestAndHobbiesCollectionViewCell" bundle:nil];
    [self.interestAndHobbiesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell"];
    
    interestAndHobbiesCollectionView.delegate=self;
    interestAndHobbiesCollectionView.dataSource=self;
    
    sectionArray = [[NSArray alloc]initWithObjects:@"ARTS",@"FOOD",@"PETS",@"RECREATION",nil];
    interstAndHobbiesArray = [[NSMutableArray alloc] initWithCapacity: 4];
    
    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"guitar.png",@"imageNormal",@"guitar_active.png",@"imageActive",@"GUITAR",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"paint.png",@"imageNormal",@"paint_active.png",@"imageActive",@"PAINTING",@"name", nil],

                                          [NSDictionary dictionaryWithObjectsAndKeys:@"photography.png",@"imageNormal",@"photography_active.png",@"imageActive",@"PHOTOGRAPHY",@"name", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"piano.png",@"imageNormal",@"piano_active.png",@"imageActive",@"PIANO",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"violin.png",@"imageNormal",@"violin_active.png",@"imageActive",@"VIOLIN",@"name", nil]
                            ,nil]atIndex:0];
    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"bbq.png",@"imageNormal",@"bbq_active.png",@"imageActive",@"BBQ",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"cooking.png",@"imageNormal",@"cooking_active.png",@"imageActive",@"COOKING",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"fastfood.png",@"imageNormal",@"fastfood_active.png",@"imageActive",@"FASTFOOD",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"italianfood.png",@"imageNormal",@"italianfood_active.png",@"imageActive",@"ITALIANFOOD",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"japanesefood.png",@"imageNormal",@"japanesefood_active.png",@"imageActive",@"JAPANESEFOOD",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"food.png",@"imageNormal",@"food_active.png",@"imageActive",@"KOREANFOOD",@"name", nil]

                                          ,nil]atIndex:1];
    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"cat.png",@"imageNormal",@"cat_active.png",@"imageActive",@"CAT",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"dog.png",@"imageNormal",@"dog_active.png",@"imageActive",@"DOG",@"name", nil],
                                          nil]atIndex:2];
    [interstAndHobbiesArray insertObject:[[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Boardgames.png",@"imageNormal",@"guitar_active.png",@"imageActive",@"BOARDGAMES",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"fishing.png",@"imageNormal",@"fishing_active.png",@"imageActive",@"FISHING",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"game.png",@"imageNormal",@"game_active.png",@"imageActive",@"GAMING",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"gardening.png",@"imageNormal",@"gardening_active.png",@"imageActive",@"GARDENING",@"name", nil],
                                          [NSDictionary dictionaryWithObjectsAndKeys:@"finance.png",@"imageNormal",@"finance_acative.png",@"imageActive",@"FINANCE",@"name", nil]

                                          ,nil]atIndex:3];
    
    
    [interestAndHobbiesCollectionView reloadData];
    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [interstAndHobbiesArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [interstAndHobbiesArray[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width), 40)];
        }
        
        for (UIView* view in reusableview.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 23, (self.view.frame.size.width), 10)];
    
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =[UIColor colorWithRed:(float)231.0/255 green:(float)90.0/255 blue:(float)102.0/255 alpha:1.0f];
        [label setFont:[UIFont fontWithName:@"Patron-Bold" size:9]];

        
        NSString *cellData = [sectionArray objectAtIndex:indexPath.section];
        NSLog(@"headervalue =%@",cellData);
        
        label.text=cellData;
        [reusableview addSubview:label];
        return reusableview;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount < 3 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth<contentWidth )
        {
            CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
    }
    if( cellCount > 5 )
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        if( totalCellWidth>contentWidth )
        {
            
            CGFloat padding = (totalCellWidth - contentWidth) / 8.0;
            return UIEdgeInsetsMake(0, padding, 0, padding);
        }
        
    }
    
    
    return UIEdgeInsetsZero;
}







-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSInterestAndHobbiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterestAndHobbiesCollectionViewCell" forIndexPath:indexPath];
    [cell.nameLabel setText:[[[interstAndHobbiesArray valueForKey:@"name"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    NSString *image =[[[interstAndHobbiesArray valueForKey:@"imageNormal"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell.interestAndHobbiesImageView setImage:[UIImage imageNamed:image]];

    
    return cell;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//
//   {
//       CGFloat picDimension;
//       if (indexPath.section == 1 ) {
//           if (indexPath.item == 5 || indexPath .item ==6) {
//               picDimension = self.view.frame.size.width / 7.0f;
//               return CGSizeMake(picDimension, picDimension);
//           }
//           
//
//       }
//    
//       return CGSizeMake(picDimension, picDimension);
//   }
//

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

{
    DSInterestAndHobbiesCollectionViewCell *dataselCell = (DSInterestAndHobbiesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    NSString *image =[[[interstAndHobbiesArray valueForKey:@"imageActive"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [dataselCell.interestAndHobbiesImageView setImage:[UIImage imageNamed:image]];
    
    dataselCell.nameLabel.textColor=[UIColor colorWithRed:(float)230.0/255 green:(float)63.0/255 blue:(float)82.0/255 alpha:1.0f];
    
    
    
}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
//{
//    DSInterestAndHobbiesCollectionViewCell *dataDeselCell = (DSInterestAndHobbiesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    
//    
//    NSString *image =[[[interstAndHobbiesArray valueForKey:@"imageNormal"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//    [dataDeselCell.interestAndHobbiesImageView setImage:[UIImage imageNamed:image]];
//    
//    dataDeselCell.nameLabel.textColor=[UIColor colorWithRed:(float)0.0/255 green:(float)0.0/255 blue:(float)0.0/255 alpha:1.0f];
//}


@end
