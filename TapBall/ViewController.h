//
//  ViewController.h
//  TapBall
//
//  Created by Alec Kriebel on 7/2/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GAITrackedViewController.h"
#import "GameCenterManager.h"

@interface ViewController : GAITrackedViewController <GameCenterManagerDelegate> {
    
    IBOutlet UILabel *mainTitle;
    IBOutlet UILabel *mainTitleTop;
    IBOutlet UIButton *play;
    IBOutlet UIButton *howTo;
    IBOutlet UIButton *leaderboard;
    
    IBOutlet UIImageView *ball;
    
    
}

-(IBAction)play:(id)sender;
-(IBAction)howTo:(id)sender;
-(IBAction)leaderboard:(id)sender;

@end
