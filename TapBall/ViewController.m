//
//  ViewController.m
//  TapBall
//
//  Created by Alec Kriebel on 7/2/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+DCAnimationKit.h"
#import "ALInterstitialAd.h"
#import "howToViewController.h"
#import "highScoreViewController.h"

#define P(x,y) CGPointMake(x, y)

@interface ViewController ()

@end

@implementation ViewController {
    
    BOOL animStarted;
    BOOL tutorial;
    int location;
}

-(IBAction)play:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"howToOpened"]) {
        
        location = 2;
        tutorial = YES;
        
    } else {
        
        location = 1;
        tutorial = NO;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [howTo setAlpha:0];
    [leaderboard setAlpha:0];
    [play setAlpha:0];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(leave) userInfo:nil repeats:NO];
}

-(void)leave {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    mainTitleTop.frame = CGRectMake(mainTitleTop.frame.origin.x, 129, 345, 76);
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:.6 target:self selector:@selector(leave2) userInfo:nil repeats:NO];
}

-(void)leave2 {
    
    mainTitle.hidden = YES;
    mainTitleTop.hidden = YES;

    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(leave3) userInfo:nil repeats:NO];
}

-(void)leave3 {
    
    if (location == 1) {
        
        [self performSegueWithIdentifier:@"homeToPlay" sender:nil];
        
    } else if (location == 2) {
        
        [self performSegueWithIdentifier:@"homeToHowTo" sender:nil];
        
    } else if (location == 3) {
        
        [self performSegueWithIdentifier:@"homeToHighScore" sender:nil];
        
    }
}

-(IBAction)howTo:(id)sender {
    
    location = 2;
    tutorial = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [howTo setAlpha:0];
    [leaderboard setAlpha:0];
    [play setAlpha:0];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(leave) userInfo:nil repeats:NO];
    
}

-(IBAction)leaderboard:(id)sender {
    
    location = 3;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [howTo setAlpha:0];
    [leaderboard setAlpha:0];
    [play setAlpha:0];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(leave) userInfo:nil repeats:NO];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //Check if the segue is tagged "goToMain" in storyboard
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"homeToHowTo"]) {
        
        howToViewController *viewController = segue.destinationViewController;
        
        if (tutorial) {
            
            viewController.tutorial = YES;
            
        } else {
            
            viewController.tutorial = NO;
            
        }
    }
    
    if([segue.identifier isEqualToString:@"homeToHighScore"]) {
        
        highScoreViewController *viewController = segue.destinationViewController;
        
        viewController.fromMenu = YES;
    }
}


-(void)disableMain {
    
    play.enabled = NO;
    leaderboard.enabled = NO;
    howTo.enabled = NO;
}

-(void)enableMain {
    
    play.enabled = YES;
    leaderboard.enabled = YES;
    howTo.enabled = YES;
}

-(void)start {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    mainTitle.frame = CGRectMake(mainTitle.frame.origin.x, 20, 345, 76);
    [UIView commitAnimations];

    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(fadeMain2) userInfo:nil repeats:NO];
}

-(void)fadeMain2 {
    
    [self enableMain];
    
    mainTitle.hidden = YES;
    mainTitleTop.hidden = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [howTo setAlpha:1];
    [leaderboard setAlpha:1];
    [play setAlpha:1];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(startBallAnimation) userInfo:nil repeats:NO];
}

-(void)startBallAnimation {
    
    if (!animStarted) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:P(-65, 130)];
        [path addQuadCurveToPoint:P(287.5, 284.0) controlPoint:P(237.5, 210)];
        [path addQuadCurveToPoint:P(480.0, 160.0) controlPoint:P(317.5, 230)];
        [path addQuadCurveToPoint:P(-65, 255.0) controlPoint:P(227.5, 0)];
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        anim.path = path.CGPath;
        anim.repeatCount = 1;
        anim.duration = 3;
        anim.calculationMode = kCAAnimationPaced;
        [anim setDelegate:self];
        ball.userInteractionEnabled = NO;
        [ball.layer addAnimation:anim forKey:@"pathAnimation"];
        
        animStarted = YES;
        
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    animStarted = NO;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startBallAnimation) userInfo:nil repeats:NO];
    
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[UIAlertView alloc] initWithTitle: title message: message
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL];
	[alert show];
	
}

//------------------------------------------------------------------------------------------------------------//
//------- View Lifecycle -------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Home View";
    
    [[GameCenterManager sharedManager] setDelegate:self];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSLog(@"%f", screenBounds.size.width);
    if (screenBounds.size.height == 480) {
        
        mainTitle.frame = CGRectOffset(mainTitle.frame, -44, 0);
        mainTitleTop.frame = CGRectOffset(mainTitleTop.frame, -44, 0);
        play.frame = CGRectOffset(play.frame, -44, 0);
        howTo.frame = CGRectOffset(howTo.frame, -44, 0);
        leaderboard.frame = CGRectOffset(leaderboard.frame, -44, 0);
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [mainTitle expandIntoView:self.view finished:^{
        
        [self start];
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    animStarted = NO;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------------------------//
//------- GameCenter Manager Delegate ------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}


@end
