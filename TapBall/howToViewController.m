//
//  howToViewController.m
//  TapBall
//
//  Created by Alec Kriebel on 7/7/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "howToViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+DCAnimationKit.h"

#define P(x,y) CGPointMake(x, y)

@interface howToViewController ()

@end

@implementation howToViewController {
    
    BOOL animStarted;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)startAnimation {
    
    [UIView animateWithDuration:2.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{topLabel.alpha = 1.0;
                         topLabel.frame = CGRectMake(topLabel.frame.origin.x, 34, 431, 78);}
                     completion:^(BOOL finished){[self showMidLabel];}];
    
}

-(void)showMidLabel {
    
    [UIView animateWithDuration:2.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{midLabel.alpha = 1.0;
                         midLabel.frame = CGRectMake(midLabel.frame.origin.x, 121, 431, 78);}
                     completion:^(BOOL finished){[self showBottomLabel];}];
    
}

-(void)showBottomLabel {
    
    [UIView animateWithDuration:2.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{bottomLabel.alpha = 1.0;
                         bottomLabel.frame = CGRectMake(bottomLabel.frame.origin.x, 207, 431, 78);}
                     completion:^(BOOL finished){[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(movePlayButton) userInfo:nil repeats:NO];;}];
    
}

-(void)movePlayButton {
    
    if (_tutorial) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"howToOpened"]) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"howToOpened"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"howToToPlay" sender:nil];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startAnimation];
    if (_tutorial) {
     
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"howToOpened"]) {
            
            play.hidden = YES;
            back.hidden = YES;
            
        }
    }
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 480) {
    
        play.frame = CGRectOffset(play.frame, -88, 0);
        topLabel.frame = CGRectOffset(topLabel.frame, -44, 0);
        midLabel.frame = CGRectOffset(midLabel.frame, -44, 0);
        bottomLabel.frame = CGRectOffset(bottomLabel.frame, -44, 0);
    }
    
    self.screenName = @"How-To View";
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
