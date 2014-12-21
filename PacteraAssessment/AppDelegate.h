//
//  AppDelegate.h
//  PacteraAssessment
//
//  This call is responsible for handling application life cycle event. This class also prepares the window for first lanch
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern NSString * const YOUR_STRING;
//Application navigation stack and window
@property (retain, nonatomic) UIWindow                  *applicationBasewindow;
@property (retain, nonatomic) UINavigationController    *applicationBaseNavigation;

// first base view of the navigation stack
@property (retain, nonatomic) FactsViewController       *baseFactListController;



@end

