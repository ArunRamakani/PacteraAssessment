//
//  AppDelegate.m
//  PacteraAssessment
//
//  This call is responsible for handling application life cycle event. This class also prepares the window for first lanch
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) dealloc {
    
    // release retained property
    [_applicationBasewindow     release];
    [_baseFactListController    release];
    [_applicationBaseNavigation release];
    
    _applicationBasewindow      = nil;
    _baseFactListController     = nil;
    _applicationBaseNavigation  = nil;
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize application base window , navigation and Facts view
    _applicationBasewindow      = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    _baseFactListController     = [[FactsViewController alloc] init];
    _applicationBaseNavigation  = [[UINavigationController alloc] initWithRootViewController:_baseFactListController];

    // Setup base window for application lanch
    [_applicationBasewindow setBackgroundColor:[UIColor whiteColor]];
    _applicationBasewindow.rootViewController = _applicationBaseNavigation;
    [_applicationBasewindow makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
