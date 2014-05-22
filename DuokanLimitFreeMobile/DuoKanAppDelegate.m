//
//  DuoKanAppDelegate.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-19.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanAppDelegate.h"

@implementation DuoKanAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    DuoKanDelegate* delegate = [self getDuokanDelegate];
    [delegate setCallback:nil];
    [delegate run];
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (DuoKanDelegate*)getDuokanDelegate {
    @synchronized(_duokanDelegate) {
        if (_duokanDelegate == nil) {
            _duokanDelegate = [[DuoKanDelegate alloc] init];
        }
    }
    
    return _duokanDelegate;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"background refresh started");
    DuoKanDelegate* delegate = [self getDuokanDelegate];
    [delegate setCallback:self];
    _handler = completionHandler;
    [delegate run];
    NSLog(@"background refresh ended");
}

- (void)DuokanDelegate:(id)delegate success:(Book *)book {
    NSLog(@"Background job is executed successfully. %0.0f seconds left", [UIApplication sharedApplication].backgroundTimeRemaining);
    _handler(UIBackgroundFetchResultNewData);
}

- (void)DuokanDelegate:(id)delegate failure:(Book *)book withError:(NSError *)err {
    NSLog(@"Failed to execute background job: %@", [err localizedDescription]);
    _handler(UIBackgroundFetchResultFailed);
}

@end
