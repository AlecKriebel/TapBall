//
//  gameViewController.m
//  TapBall
//
//  Created by Alec Kriebel on 7/4/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "gameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "AppSpecificValues.h"
#import "GameCenterManager.h"

#define P(x,y) CGPointMake(x, y)

@interface gameViewController ()

@end

@implementation gameViewController {
    
    int time;
    NSTimer *countDownTimer;
    BOOL enabled;
    BOOL tapped;
    int score;
    int round;
    float speed;
}


-(void)startCountDown {
    
    countDown.text = [NSString stringWithFormat:@"%d", time];
    
    if (countDownTimer == nil) {
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    
}

-(void)countDown {
    
    time --;
    
    if (time > 0) {
        
        countDown.text = [NSString stringWithFormat:@"%d", time];
        
    } else if (time == 0) {
        
        countDown.text = @"Go!";
        
    } else if (time < 0) {
        
        [self startGame];
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    
}

-(void)startGame {
    
    countDown.hidden = YES;
    
    [self createAnimation];
    
    enabled = YES;
    
}

-(void)createAnimation {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:P(-65, 130)];
    [path addQuadCurveToPoint:P(287.5, 284.0) controlPoint:P(237.5, 210)];
    [path addQuadCurveToPoint:P(480.0, 160.0) controlPoint:P(317.5, 230)];
    [path addQuadCurveToPoint:P(-65, 255.0) controlPoint:P(227.5, 0)];
    
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.path = path.CGPath;
	anim.repeatCount = 1;
	anim.duration = speed;
    anim.calculationMode = kCAAnimationCubicPaced;
    //anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    [anim setDelegate:self];
    ball.userInteractionEnabled = NO;
	[ball.layer addAnimation:anim forKey:@"pathAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    if ((round == 1) && (score >= 40) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement40Score] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement40Score percentComplete:100 shouldDisplayNotification:YES];
        
    }
    
    if ((round <= 2) && (score >= 70) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement70Score] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement70Score percentComplete:100 shouldDisplayNotification:YES];
        
    }
    
    round ++;
    
    if (tapped) {
        
        if (speed >= 1.5) {
            
            speed = speed - (speed * .225);
            
        } else {
            
            speed = speed - .1;
            
        }

        [self createAnimation];
        tapped = NO;
        
    } else {
        
        [self gameOver];
    }
    
}

-(void)gameOver {
    
    //Lose sound
    [self playSoundWithOfThisFile:@"lose" withFileType:@"wav"];
    
    //Change Last Score
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"lastScore"];
    
    //Submit total score to GC
    int totalScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"totalScore"] + score;
    [[NSUserDefaults standardUserDefaults] setInteger:totalScore forKey:@"totalScore"];
    [[GameCenterManager sharedManager] saveAndReportScore:totalScore leaderboard:kLeaderboardID2  sortOrder:GameCenterSortOrderHighToLow];
    
    //Local high scores handling
    NSMutableArray *scoreArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"scores"] mutableCopy];
    NSNumber *numberScore = [NSNumber numberWithInt:score];
    
    [self checkAchievements];
    
    if ([scoreArray count] < 5) {
        
        [scoreArray addObject:numberScore];
        
    } else if ([scoreArray objectAtIndex:4] < numberScore) {
        
        [scoreArray removeObjectAtIndex:4];
        [scoreArray addObject:numberScore];
        
    }
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [scoreArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    NSLog(@"%@", scoreArray);
    
    [[NSUserDefaults standardUserDefaults] setObject:scoreArray forKey:@"scores"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Submitting highest score
    [[GameCenterManager sharedManager] saveAndReportScore:[(NSNumber *)[scoreArray objectAtIndex:0] intValue] leaderboard:kLeaderboardID  sortOrder:GameCenterSortOrderHighToLow];
    
    //Handling daily score
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"today"]];
    
    if ([today day] != [otherDay day]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"daily"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"today"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        if (score > [[NSUserDefaults standardUserDefaults] integerForKey:@"daily"]) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"daily"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    //Leave the view and go to high score
    [self performSegueWithIdentifier:@"gameToHighScore" sender:nil];
    
}

-(void)checkAchievements {
    
    long totalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalScore"];
    
    if ((totalScore >= 1000) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement1000TotalScore] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement1000TotalScore percentComplete:100.0 shouldDisplayNotification:YES];
    }
    
    if ((totalScore >= 5000) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement5000TotalScore] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement5000TotalScore percentComplete:100.0 shouldDisplayNotification:YES];
    }
    
    if ((totalScore >= 20000) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement20000TotalScore] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement20000TotalScore percentComplete:100.0 shouldDisplayNotification:YES];
    }
    
    if ((totalScore >= 100000) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement100000TotalScore] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement100000TotalScore percentComplete:100.0 shouldDisplayNotification:YES];
    }
    
    if ((totalScore >= 1000000) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement1000000TotalScore] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement1000000TotalScore percentComplete:100.0 shouldDisplayNotification:YES];
    }
    
    
    
    if ((score >= 100) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement100Score] < 100)) {

        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement100Score percentComplete:100 shouldDisplayNotification:YES];
        
    }
    
    if ((score >= 150) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement150Score] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement150Score percentComplete:100 shouldDisplayNotification:YES];
        
    }
    
    if ((score >= 200) && ([[GameCenterManager sharedManager] progressForAchievement:kAchievement200Score] < 100)) {
        
        [[GameCenterManager sharedManager] saveAndReportAchievement:kAchievement200Score percentComplete:100 shouldDisplayNotification:YES];
        
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGPoint presentationPosition = [(CALayer*)[ball.layer presentationLayer] position];
    
    if (enabled) {
        
        if (point.x > presentationPosition.x - 32.5 && point.x < presentationPosition.x + 32.5
            && point.y > presentationPosition.y - 32.5 && point.y < presentationPosition.y + 32.5) {
            
            [ball setImage:[UIImage imageNamed: @"ballHighlight"]];
            score ++;
            scoreLabel.text = [NSString stringWithFormat:@"SCORE: %d", score];
            
            if (score > [[NSUserDefaults standardUserDefaults] integerForKey:@"daily"]) {
                
                dailyLabel.text = [NSString stringWithFormat:@"DAILY: %d", score];
            }
            
            [self playSoundWithOfThisFile:@"tap" withFileType:@"wav"];
            [self createLabel];
            tapped = YES;
            
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (enabled) {
    
        [ball setImage:[UIImage imageNamed: @"ball"]];
        
    }

}

-(void)createLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(152, 7, 24, 21)];
    int i = arc4random() %2;
    
    if (i == 1) {
        
        label.frame = CGRectMake(150, 10, 32, 21);
        
    } else {
        
        label.frame = CGRectMake(155, 10, 32, 21);
        
    }
    
    label.text = @"+1";
    [label setTextColor:[UIColor greenColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName: @"Avenir Next Demi Bold" size: 25.0f]];
    [self.view addSubview:label];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    label.frame = CGRectOffset(label.frame, 0, -30);
    [label setAlpha:0];
    [UIView commitAnimations];

    label = nil;
    
    
    if (score > [[NSUserDefaults standardUserDefaults] integerForKey:@"daily"]) {
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(148, 10, 24, 21)];
        int i2 = arc4random() %2;
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 480) {
            
            if (i2 == 1) {
                
                label2.frame = CGRectMake(442, 10, 32, 21);
                
            } else {
                
                label2.frame = CGRectMake(447, 10, 32, 21);
                
            }
            
            
        } else if (screenBounds.size.height == 568) {
            
            if (i2 == 1) {
                
                label2.frame = CGRectMake(530, 10, 32, 21);
                
            } else {
                
                label2.frame = CGRectMake(535, 10, 32, 21);
                
            }
            
            
        }
        
        label2.text = @"+1";
        [label2 setTextColor:[UIColor greenColor]];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setFont:[UIFont fontWithName: @"Avenir Next Demi Bold" size: 25.0f]];
        [self.view addSubview:label2];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        label2.frame = CGRectOffset(label2.frame, 0, -30);
        [label2 setAlpha:0];
        [UIView commitAnimations];
        
        label2 = nil;
    }
}

- (void)playSoundWithOfThisFile:(NSString*)fileName withFileType:(NSString*)fileType {
    
        NSString *path  = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    enabled = NO;
    time = 3;
    speed = 6;
    round = 1;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 480) {
     
        dailyLabel.frame = CGRectOffset(dailyLabel.frame, -88, 0);
        countDown.frame = CGRectOffset(countDown.frame, -44, 0);
        
    }
    
    dailyLabel.text = [NSString stringWithFormat:@"DAILY: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"daily"]];
    
    self.screenName = @"Game View";
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self startCountDown];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    
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
