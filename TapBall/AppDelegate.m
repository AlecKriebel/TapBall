//
//  AppDelegate.m
//  TapBall
//
//  Created by Alec Kriebel on 7/2/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import "ALSdk.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"scores"] == nil) {
        
        NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:5];
        [userDefaults setObject:array forKey:@"scores"];
        [userDefaults setBool:NO forKey:@"howToOpened"];
        [userDefaults setInteger:0 forKey:@"daily"];
        [userDefaults setInteger:0 forKey:@"totalScore"];
        [userDefaults setInteger:0 forKey:@"adCount"];
        [userDefaults setInteger:0 forKey:@"lastScore"];
        [userDefaults setObject:[NSDate date] forKey:@"today"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 5;
    
    // Optional: set Logger to VERBOSE for debug information.
    //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46212582-7"];
    
    [ALSdk initializeSdk];
    
    [[GameCenterManager sharedManager] setupManager];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:@"today"];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[userDefaults objectForKey:@"today"]];

    if ([today day] != [otherDay day]) {
        
        [userDefaults setInteger:0 forKey:@"daily"];
        [userDefaults setObject:[NSDate date] forKey:@"today"];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
