//
//  HealthAppDelegate.h
//  Health
//
//  Created by Administrator on 8/28/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "DashboardViewController.h"
#import "ChallengeViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AssessmentViewController.h"
#import "MMDrawerController.h"
@import HealthKit;

@interface HealthAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController        *rootViewController;
@property (strong, nonatomic) UINavigationController    *dashboardViewController;
@property (strong, nonatomic) UINavigationController    *menuViewController;
@property (strong, nonatomic) UINavigationController    *challengeViewController;
@property (strong, nonatomic) UINavigationController    *settingViewController;
@property (strong, nonatomic) UINavigationController    *historyViewController;
@property (strong, nonatomic) UINavigationController    *assessmentViewController;
@property (strong, nonatomic) LoginViewController       *loginViewController;
@property (nonatomic) HKHealthStore *healthStore;
@property (nonatomic) UIBackgroundTaskIdentifier *backgroundTask;
@property (nonatomic, strong) NSTimer *updateTimer;

+(BOOL)isFourInchScreen;
-(void)resetUI:(int)num;

-(void)registerForNotifications;



@end
