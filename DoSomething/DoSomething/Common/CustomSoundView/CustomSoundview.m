//
//  CustomSoundview.m
//  DoSomething
//
//  Created by Sha on 3/3/16.
//  Copyright © 2016 OClock Apps. All rights reserved.
//

#import "CustomSoundview.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SoundTableCell.h"
@interface CustomSoundview ()


@end

@implementation CustomSoundview

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0,250,365)];
    self.soundmenuView.hidden =YES;
   
    [self.view setHidden:YES];
    [self loadAudioFileList];
    [self loadAudioFileListNew];
}

-(void)loadAudioFileList{
    audioFileList = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSURL *directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/Modern"];
    
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         
                                         enumeratorAtURL:directoryURL
                                         
                                         includingPropertiesForKeys:keys
                                         
                                         options:0
                                         
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             
                                             // Handle the error.
                                             
                                             // Return YES if the enumeration should continue after the error.
                                             
                                             return YES;
                                             
                                         }];
    
    for (NSURL *url in enumerator) {
        
        NSError *error;
        
        NSNumber *isDirectory = nil;
        
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            
            // handle error
            
        }
        
        else if (! [isDirectory boolValue]) {
            
            [audioFileList addObject:url];
            
        }
        
    }
    
    NSLog(@"audioFileList: %@", audioFileList);
}
-(void)loadAudioFileListNew{
    
    audioFilelistNew = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSURL *directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/New"];
    
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         
                                         enumeratorAtURL:directoryURL
                                         
                                         includingPropertiesForKeys:keys
                                         
                                         options:0
                                         
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             
                                             // Handle the error.
                                             
                                             // Return YES if the enumeration should continue after the error.
                                             
                                             return YES;
                                             
                                         }];
    
    for (NSURL *url in enumerator) {
        
        NSError *error;
        
        NSNumber *isDirectory = nil;
        
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            
            // handle error
            
        }
        
        else if (! [isDirectory boolValue]) {
            
            [audioFilelistNew addObject:url];
            
        }
        
    }
    
    NSLog(@"audioFileList: %@", audioFilelistNew);
    
    [self combineAudioArray];
    
}

-(void)combineAudioArray{
    
    
    
    combinationArray =[[audioFileList arrayByAddingObjectsFromArray:audioFilelistNew]mutableCopy];
    
    NSLog(@"audioFileList: %@", combinationArray);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [combinationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    SoundTableCell* cell = (SoundTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SoundTableCell" owner:self options:nil];
        cell = soundMenuCell;
    }
    
    NSString *string = [combinationArray[indexPath.row]lastPathComponent];
    
    NSString *string1 = [string stringByReplacingOccurrencesOfString:@".caf" withString:@""];
    
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"sms_alert_" withString:@""];
    
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    NSIndexPath *selectedIndexPath = indexPath;
    NSInteger selectedrow = selectedIndexPath.row;
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"selectSound"] == selectedrow) {
        
        cell.selectedsoundMenuImg.image = [UIImage imageNamed:@"Soundon"];
        self.selectSoundStr =[combinationArray[indexPath.row]lastPathComponent ];
    }
    
    cell.soundNamelbl.text = [string3 capitalizedString];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[combinationArray objectAtIndex:indexPath.row],&soundID);
    AudioServicesPlaySystemSound(soundID);
    NSIndexPath *selectedIndexPath = indexPath;
    NSInteger selectedrow = selectedIndexPath.row;
    NSLog(@"selectedrow=%ld",(long)selectedrow);
    SoundTableCell *cell = (SoundTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"selectSound"] == selectedrow) {
        
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectSound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setInteger:selectedrow forKey:@"selectSound"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        cell.selectedsoundMenuImg.image = [UIImage imageNamed:@"Soundon"];
        _selectSoundStr =[combinationArray[indexPath.row] lastPathComponent];
        NSLog(@"Soundstring=%@",_selectSoundStr);
        [self.soundmenutableview reloadData];
        
    }
    
    
    
    
    NSLog(@"File url: %@", [[combinationArray objectAtIndex:indexPath.row] description]);
}
-(IBAction)DidclickSoundMenuCancel:(id)sender
{
    self.soundmenuView.hidden=YES;
}
-(IBAction)didClickSoundOk:(id)sender
{
    
    NSLog(@"Soundstring=%@",_selectSoundStr);
   // [self loadUpdateNotificationAPI];
    self.soundmenuView.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end