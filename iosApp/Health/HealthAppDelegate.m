//
//  HealthAppDelegate.m
//  Health
//
//  Created by Administrator on 8/28/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "HealthAppDelegate.h"
#import "SplashViewController.h"

#import "Common.h"
#import "SharedData.h"
#import <Parse/Parse.h>

#import "FitbitManager.h"
#import "GPSManager.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "TestFairy.h"
#import "SessionManager.h"
#import  "Yabbit-Swift.h"
#import "GlobalTimer.h"
#import "SessionManager.h"

#import "LocalNotificationHelper.h"

@implementation HealthAppDelegate
@synthesize rootViewController;
@synthesize dashboardViewController;
@synthesize menuViewController;
@synthesize challengeViewController;
@synthesize historyViewController;
@synthesize settingViewController;
@synthesize loginViewController;
@synthesize assessmentViewController;
@synthesize healthStore;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [Parse setApplicationId:PARSE_API_KEY clientKey:PARSE_CLIENT_KEY];
    [TestFairy begin:@"1edf68164b00335b24f8288cef5644ed4ec83e8e"];
        [Fabric with:@[[Crashlytics class]]];
   // [Fabric with:@[CrashlyticsKit]];
    self.healthStore = [[HKHealthStore alloc] init];
    [TPKeyboardAvoidingScrollView class];

    [self initAppearance];
    [self initViewControllers];
    return YES;
}

-(void)registerForNotifications
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [[GlobalTimer sharedManager] startTimer];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:8
                                                        target:self
                                                      selector:@selector(postGps)
                                                      userInfo:nil
                                                       repeats:YES];
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:*(self.backgroundTask)];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
//        [LocalNotificationHelper notifyUserWithMessage:@"Have you completed your challenges today?" inSeconds:6*60*60];
    
}
-(void)postGps{
    @autoreleasepool {
        
        NSTimeInterval difference=0.0;
        NSDictionary
              *lastLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserLastLocation"];
        NSString *UserGpsState=[[NSUserDefaults standardUserDefaults] objectForKey:@"kUserGps"];
        if([UserGpsState isEqualToString:@"on"])
       {
        NSNumber *latitude=[lastLocation objectForKey:@"lat"];
        NSNumber *longitude=[lastLocation objectForKey:@"long"];
        NSString *timestamp=[lastLocation objectForKey:@"timestamp"];
        NSString *currentTimestamp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        double current = [currentTimestamp doubleValue];
        double last=[timestamp doubleValue];
        difference = [[NSDate dateWithTimeIntervalSince1970:current] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:last]];
        NSLog(@"difference: %f", difference);
        long dur=(long)difference;
        NSNumber *duration = [NSNumber numberWithDouble:dur];
        
        SessionManager *sessionmanager = [SessionManager sharedManager];
        
        NSDictionary *parameters = @{@"latitude":latitude ,@"longitude":longitude,@"duration":duration};
        
        [sessionmanager POST:@"v1/patientGPSData" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:timestamp  forKey:@"kLastLocationUpdateTimestamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
    }
        
        
}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([notification.category isEqual: @"DONT_FORGET"]) {
        [rootViewController setCenterViewController:dashboardViewController];
    } else if ([notification.category isEqual: @"NEW_CHALLENGES"]) {
        [rootViewController setCenterViewController:challengeViewController];
    }
}

- (void) resetUI :(int)num
{
    if ( dashboardViewController != nil )
    {
        dashboardViewController = nil;
    }
    
    DashboardViewController *dashboardVC = [[DashboardViewController alloc] init];
    dashboardViewController = [[UINavigationController alloc] initWithRootViewController:dashboardVC];
    
    // Challenge
    ChallengeViewController *challengeVc = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil];
    
    if ( challengeViewController != nil ) {
        challengeViewController = nil;
    }
    challengeViewController = [[UINavigationController alloc] initWithRootViewController:challengeVc];
    
    // History
    
    HistoryViewController *historyVc = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    
    if ( historyViewController != nil ) {
        historyViewController = nil;
    }
    historyViewController = [[UINavigationController alloc] initWithRootViewController:historyVc];
    
    // Setting
    SettingViewController *settingVc = [[SettingViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    if ( settingViewController != nil ) {
        settingViewController = nil;
    }
    
    settingViewController = [[UINavigationController alloc] initWithRootViewController:settingVc];
    
    if (rootViewController)
    {
        rootViewController = nil;
    }
    
    // Assessment
    
    AssessmentViewController *assessmentVc = [[AssessmentViewController alloc] initWithNibName:@"AssessmentViewController" bundle:nil];
    
    assessmentViewController = [[UINavigationController alloc] initWithRootViewController:assessmentVc];
}

-(MMDrawerController*)rootViewController
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"assesment_status"])
    {
        rootViewController = [[MMDrawerController alloc] initWithCenterViewController:dashboardViewController leftDrawerViewController:menuViewController];
    }
    else {
        rootViewController = [[MMDrawerController alloc] initWithCenterViewController:assessmentViewController leftDrawerViewController:menuViewController];
    }
    [rootViewController setMaximumLeftDrawerWidth:260];
    [rootViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [rootViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [rootViewController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
     {
         
     }];
    
    return rootViewController;
}

- (void) initViewControllers
{
    MenuViewController *menuVc = [[MenuViewController alloc] init];
    menuViewController = [[UINavigationController alloc] initWithRootViewController:menuVc];
    [menuViewController setNavigationBarHidden:YES];
    
    // Dashboard
    DashboardViewController *dashboardVC = [[DashboardViewController alloc] init];
    dashboardViewController = [[UINavigationController alloc] initWithRootViewController:dashboardVC];
    
    // Challenge
    ChallengeViewController *challengeVc = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil];
    challengeViewController = [[UINavigationController alloc] initWithRootViewController:challengeVc];
    
    // History
    
    HistoryViewController *historyVc = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    historyViewController = [[UINavigationController alloc] initWithRootViewController:historyVc];
    
    // Setting
    SettingViewController* settingVc = [[SettingViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingViewController = [[UINavigationController alloc] initWithRootViewController:settingVc];
    
    // Assessment
    
    AssessmentViewController *assessmentVc = [[AssessmentViewController alloc] initWithNibName:@"AssessmentViewController" bundle:nil];
    
    assessmentViewController = [[UINavigationController alloc] initWithRootViewController:assessmentVc];
    

    // Login
    
    loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    SplashViewController *splashVc = [[SplashViewController alloc] init];
    if ([splashVc respondsToSelector:@selector(setHealthStore:)]) {
       
          [splashVc setHealthStore:self.healthStore];
    }

    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:splashVc];
    navigationVc.navigationBarHidden = YES;
    
    self.window.rootViewController = navigationVc;
}

- (void) initAppearance
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [[UINavigationBar appearanceWhenContainedIn:[MMDrawerController class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                                                         [UIFont fontWithName:@"Avenir" size:16.0f], NSFontAttributeName,
                                                                                                         nil]];
    [[UINavigationBar appearanceWhenContainedIn:[MMDrawerController class], nil] setTintColor:[UIColor whiteColor]];
}

- (void) loadFocus
{
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadFocus];
}

+ (BOOL) isFourInchScreen
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ( appDelegate.window.bounds.size.height < 568 ) {
        return NO;
    }
    
    return YES;
}

@end
