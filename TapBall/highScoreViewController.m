//
//  highScoreViewController.m
//  TapBall
//
//  Created by Alec Kriebel on 7/7/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "highScoreViewController.h"
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
#import "UIView+DCAnimationKit.h"
#import "howToViewController.h"
#import "ALSdk.h"
#import "ALAdService.h"
#import "ALAd.h"
#import "ALInterstitialAd.h"

@interface highScoreViewController ()

@property (strong, nonatomic) ALSdk* sdk;
@property (strong,    atomic) ALAd* lastLoadedAd;

@end

@implementation highScoreViewController

-(IBAction)leaderboards:(id)sender {
    
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
    
}

-(IBAction)play:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"howToOpened"]) {
        
        [self performSegueWithIdentifier:@"highScoreToHowTo" sender:nil];
        
        
    } else {
        
        [self performSegueWithIdentifier:@"highScoreToPlay" sender:nil];
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    howToViewController *viewController = segue.destinationViewController;
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"highScoreToHowTo"]) {
            
            viewController.tutorial = YES;
    }
}
/*
-(IBAction)local:(id)sender {
    
    [self hideNames];
    [self hideRanks];
    [self setLocal];
    
}

-(IBAction)friends:(id)sender {
    
    [self showNames];
    [self hideRanks];
    
    [self retrieveTopScores];
    
    friends.enabled = NO;
    world.enabled = YES;
    local.enabled = YES;
}

-(IBAction)world:(id)sender {
    
    [self showNames];
    [self showRanks];
    
    world.enabled = NO;
    local.enabled = YES;
    friends.enabled = YES;
}

-(void)hideNames {
        
    name1.hidden = YES;
    name2.hidden = YES;
    name3.hidden = YES;
    name4.hidden = YES;
    name5.hidden = YES;
        
}

-(void)hideRanks {
        
    rank1.hidden = YES;
    rank2.hidden = YES;
    rank3.hidden = YES;
    rank4.hidden = YES;
    rank5.hidden = YES;
}

-(void)showRanks {
    
    rank1.hidden = NO;
    rank2.hidden = NO;
    rank3.hidden = NO;
    rank4.hidden = NO;
    rank5.hidden = NO;
    
}

-(void)showNames {
    
    name1.hidden = NO;
    name2.hidden = NO;
    name3.hidden = NO;
    name4.hidden = NO;
    name5.hidden = NO;
    
}
*/

-(void)setLocal {
    
    
    NSArray *scoreArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"scores"];
    
    if ([scoreArray count] == 0) {
        
        score1.text = @"NO SCORES";
        
    } else if ([scoreArray count] == 1) {
        
        score1.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:0]];
        
    } else if ([scoreArray count] == 2) {
        
        score1.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:0]];
        score2.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:1]];
        
    } else if ([scoreArray count] == 3) {
        
        score1.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:0]];
        score2.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:1]];
        score3.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:2]];
        
    } else if ([scoreArray count] == 4) {
        
        score1.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:0]];
        score2.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:1]];
        score3.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:2]];
        score4.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:3]];
        
    } else if ([scoreArray count] == 5) {
        
        score1.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:0]];
        score2.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:1]];
        score3.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:2]];
        score4.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:3]];
        score5.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:4]];
        
    }
    
    /*
    local.enabled = NO;
    friends.enabled = YES;
    world.enabled = YES;
     */
}

/*
- (void) retrieveTopScores
{
    
    NSLog(@"retrieve");
    
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.identifier = @"Combined.LandMaps";
        leaderboardRequest.range = NSMakeRange(1,4);
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error != nil)
            {
                
                NSLog(@"%@", error);
                
            }
            if (scores != nil)
            {
                
                NSLog(@"%@", scores);
                
                NSMutableArray *scoreArray = [scores mutableCopy];
                //NSArray *localScoreArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"scores"];
                
                //[scoreArray addObject:[localScoreArray objectAtIndex:0]];
                
                NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                [scoreArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
                
                score1.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:0]];
                score2.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:1]];
                score3.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:2]];
                score4.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:3]];
                //score5.text = [NSString stringWithFormat:@"%@", [scoreArray objectAtIndex:4]];
                
            }
        }];
    }
}

*/
 
-(void)startAnimation {
    
    [popUpLabel bounceIntoView:self.view direction:DCAnimationDirectionTop];
    
    [UIView animateWithDuration:.5
                          delay:2
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{popUpLabel.alpha = 0.0;}
                     completion:^(BOOL finished){[self startAnimation2];}];

    
}

-(void)startAnimation2 {
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"adCount"] == 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"adCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"adCount"] == 1) {
        
        //[ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
        if(self.lastLoadedAd)
        {
            // Show an interstitial
            ALInterstitialAd* interstitial = [[ALInterstitialAd alloc] initWithSdk: self.sdk];
            [interstitial showOver: [UIApplication sharedApplication].keyWindow andRender: self.lastLoadedAd];
            
            // Also, clear out this ad, since we've just used it.
            self.lastLoadedAd = nil;
        }
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [lastScore setAlpha:1];
    [score1 setAlpha:1];
    [score2 setAlpha:1];
    [score3 setAlpha:1];
    [score4 setAlpha:1];
    [score5 setAlpha:1];
    [UIView commitAnimations];

    
}

-(void) loadAd
{
    NSLog(@"Loading Ad");
    ALAdService* adService = self.sdk.adService;
    [adService loadNextAd: [ALAdSize sizeInterstitial] andNotify: self];
}

-(void) adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    self.lastLoadedAd = ad;
    NSLog(@"Ad Loaded");
}

-(void) adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    if(code == kALErrorCodeNoFill)
    {
        NSLog(@"Unable to load ad due to device or location (Not filled)");
    }
    else
    {
        NSLog(@"Unable to load ad");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 480) {
        
        lastScore.frame = CGRectOffset(lastScore.frame, -44, 0);
        leaderboard.frame = CGRectOffset(leaderboard.frame, -44, 0);
        score1.frame = CGRectOffset(score1.frame, -44, 0);
        score2.frame = CGRectOffset(score2.frame, -44, 0);
        score3.frame = CGRectOffset(score3.frame, -44, 0);
        score4.frame = CGRectOffset(score4.frame, -44, 0);
        score5.frame = CGRectOffset(score5.frame, -44, 0);
        popUpLabel.frame = CGRectOffset(popUpLabel.frame, -44, 0);
        menu.frame = CGRectOffset(menu.frame, -88, 0);
        
    }
    
    if (_fromMenu) {
        
        lastScore.text = @"HIGHSCORES";
        _play.frame = CGRectMake(20, 245, 60, 45);
        [_play setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_play setBackgroundImage:[UIImage imageNamed:@"playHighlight"] forState: UIControlStateHighlighted];
        
        
    } else if (!_fromMenu) {
        
        popUpLabel.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"lastScore"]];
        
        [lastScore setAlpha:0];
        [score1 setAlpha:0];
        [score2 setAlpha:0];
        [score3 setAlpha:0];
        [score4 setAlpha:0];
        [score5 setAlpha:0];
        
        [self startAnimation];
        
        lastScore.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"lastScore"]];
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"adCount"] == 1) {
            
            self.sdk = [ALSdk sharedWithKey: @"k9CuJyq0W_G5P3TQt3ExmnV1AfwV3dvoo6f63U6aTMguQDIIGWD1Ii2SNyzQatCN-tT2LacpyHhMU-fmVtnoZp"];
            
            [self loadAd];
            
            
        }
        
    }
    /*
    [self hideNames];
    [self hideRanks];
     */
    [self setLocal];
    
    self.screenName = @"HighScore View";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
