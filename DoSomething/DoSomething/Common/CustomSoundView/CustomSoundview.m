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
{
    SystemSoundID soundID;
}

@end

@implementation CustomSoundview

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0,250,365)];
    self.soundmenuView.hidden =YES;
   
    [self.view setHidden:YES];
  
    [self loadAudioListArray];
}
-(void)loadAudioListArray
{
    audioFileList=[[NSMutableArray alloc]initWithObjects:@"Default.caf",@"Silence.caf",@"Aurora.caf",@"Bamboo.caf",@"Beacon.caf",@"Bulletin.caf",@"By The Seaside.caf",@"Chimes.caf",@"Chord.caf",@"Circles.caf",@"Circuit.caf",@"Complete.caf",@"Constellation.caf",@"Cosmic.caf",@"Crystals.caf",@"Hello.caf",@"Hillside.caf",@"Illuminate.caf",@"Input.caf",@"Keys.caf",@"Night Owl.caf",@"Note.caf",@"Opening.caf",@"Playtime.caf",@"Popcorn.caf",@"Presto.caf",@"Pulse.caf",@"Radar.caf",@"Radiate.caf",@"Ripples.caf",@"Sencha.caf",@"Signal.caf",@"Silk.caf",@"Slow Rise.caf",@"Stargaze.caf",@"Summit.caf",@"Synth.caf",@"Twinkle.caf",@"Uplift.caf",@"Waves.caf",@"Silence.caf", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [audioFileList count];
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
    
    NSString *string = [audioFileList[indexPath.row]lastPathComponent];
    
    NSString *string1 = [string stringByReplacingOccurrencesOfString:@".caf" withString:@""];
    
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"sms_alert_" withString:@""];
    
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    NSIndexPath *selectedIndexPath = indexPath;
    NSInteger selectedrow = selectedIndexPath.row;
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"selectSound"] == selectedrow) {
        
        cell.selectedsoundMenuImg.image = [UIImage imageNamed:@"Soundon"];
        self.selectSoundStr =[audioFileList[indexPath.row]lastPathComponent ];
    }
    
    cell.soundNamelbl.text = [string3 capitalizedString];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *Soundstring = [audioFileList[indexPath.row]lastPathComponent];
    
    NSString *seprateSOundName = [Soundstring stringByReplacingOccurrencesOfString:@".caf" withString:@""];

    if(![seprateSOundName isEqualToString:@"Default"]){
//   AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[combinationArray objectAtIndex:indexPath.row],&soundID);
//   AudioServicesPlaySystemSound(soundID);
        
        if(![seprateSOundName isEqualToString:@"Silence"])
        {

    
            AudioServicesRemoveSystemSoundCompletion (soundID);
        
            AudioServicesDisposeSystemSoundID(soundID);

    NSString *playSoundOnAlert = [[NSBundle mainBundle] pathForResource:seprateSOundName
                                                                 ofType:@"caf"];
   
    NSURL *soundURL = [NSURL fileURLWithPath:playSoundOnAlert];
    self.urlString=[NSString stringWithFormat:@"%@",soundURL];
           
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
    
        AudioServicesPlaySystemSound(soundID);
           
           
            self.selectSoundID = &(soundID);
            
            
        }
    }

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
        _selectSoundStr =[audioFileList[indexPath.row] lastPathComponent];
       // NSLog(@"Soundstring=%@",_selectSoundStr);
         //_selectSoundStr=playSoundOnAlert;
        [self.soundmenutableview reloadData];
        
    }
    
    
    
    
   // NSLog(@"File url: %@", [[combinationArray objectAtIndex:indexPath.row] description]);
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
    AudioServicesRemoveSystemSoundCompletion (soundID);
    
    AudioServicesDisposeSystemSoundID(soundID);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
