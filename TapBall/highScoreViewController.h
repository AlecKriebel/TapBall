//
//  highScoreViewController.h
//  TapBall
//
//  Created by Alec Kriebel on 7/7/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "ALAdLoadDelegate.h"

@interface highScoreViewController : GAITrackedViewController <ALAdLoadDelegate> {
    
    IBOutlet UILabel *lastScore;
    IBOutlet UILabel *popUpLabel;
    
    IBOutlet UIButton *local;
    IBOutlet UIButton *friends;
    IBOutlet UIButton *world;
    
    IBOutlet UIButton *leaderboard;
    IBOutlet UIButton *menu;
    
    IBOutlet UILabel *name1;
    IBOutlet UILabel *name2;
    IBOutlet UILabel *name3;
    IBOutlet UILabel *name4;
    IBOutlet UILabel *name5;
    
    IBOutlet UILabel *score1;
    IBOutlet UILabel *score2;
    IBOutlet UILabel *score3;
    IBOutlet UILabel *score4;
    IBOutlet UILabel *score5;
    
    IBOutlet UILabel *rank1;
    IBOutlet UILabel *rank2;
    IBOutlet UILabel *rank3;
    IBOutlet UILabel *rank4;
    IBOutlet UILabel *rank5;
    
}

@property (nonatomic) BOOL fromMenu;
@property (nonatomic, retain)IBOutlet UIButton *play;

-(IBAction)leaderboards:(id)sender;
-(IBAction)play:(id)sender;
//-(IBAction)local:(id)sender;
//-(IBAction)friends:(id)sender;
//-(IBAction)world:(id)sender;

@end
