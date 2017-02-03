//
//  SettingViewController.m
//  Health
//
//  Created by Administrator on 9/11/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UINavigationBar+FlatUI.h"
#import "MMDrawerBarButtonItem.h"
#import "SharedData.h"
#import "NSDate+MTDates.h"
#import "Focus.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "EHRViewController.h"
#import "EHRManager.h"
#import "ResetPasswordViewController.h"
#import "Yabbit-Swift.h"
#import "BackgroundApiCall.h"
#import "GSHealthKitManager.h"

@interface SettingViewController ()

@end


@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0]];
    
    self.title = @"SETTINGS";

    [self initUI];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _transparentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _transparentView.backgroundColor = [UIColor blackColor];
    _transparentView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_transparentView addGestureRecognizer:tap];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark update UI

- (void) initUI
{
    [self initBarButtonItem];
    
    pickerBackView.frame = CGRectMake(0, self.view.frame.size.height, pickerBackView.frame.size.width, pickerBackView.frame.size.height);
    NSString *frequency = [[NSUserDefaults standardUserDefaults] objectForKey:@"Frequency"];
   
    if([frequency isEqualToString:@"Once a Day"])
    {
       fireDateLabel.text=@"Once a Day";
    }
    else if([frequency isEqualToString:@"Twice a Day"])
    {
       fireDateLabel.text=@"Twice a Day";
    }
    else if([frequency isEqualToString:@"Every Hour"])
    {
        fireDateLabel.text=@"Every Hour";
    }
    else if([frequency isEqualToString:@"Every Minute"])
    {
        fireDateLabel.text=@"Every Minute";
    }
    else
    {
        fireDateLabel.text=@"Once a Day";
    }

    
   
}

- (void) refreshUI
{
   /* PFUser *currentUser = [PFUser currentUser];
    fireDateLabel.text = [currentUser[@"fireDate"] stringFromDateWithHourAndMinuteFormat:MTDateHourFormat12Hour];*/
    
    __weak typeof(self) weakSelf = self;
    
   /* [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    [[EHRManager sharedManager] isConnectedWithCompletion:^(BOOL isConnected)
    {
        __strong typeof(weakSelf) self = weakSelf;
        self->_MRNLabel.text = isConnected ? @"EHR Connected" : @"Connect to EHR";
        self->_MRNButton.enabled = !isConnected;
        
        [SVProgressHUD popActivity];
    }];*/
    
    //[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    [[FitbitManager sharedManager] isLoggedInWithCompletion:^(BOOL isLoggedIn)
    {
        __strong typeof(weakSelf) self = weakSelf;
        [self updateFitbitUIIfConnected:isLoggedIn];
        
       // [SVProgressHUD popActivity];
    }];
}

-(void)updateFitbitUIIfConnected:(BOOL)connected
{
    _fitbitLabel.text = connected ? @"Fitbit Connected" : @"Connect to Fitbit";
    
    NSString *title = connected ? @"Logout" : @"Connect";
    [_fitbitButton setTitle:title forState:UIControlStateNormal];
}

- (void) initBarButtonItem
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonClicked) image:[UIImage imageNamed:@"ico_menu_threelines.png"]];
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
}



#pragma mark
#pragma mark actions

-(IBAction) resetPassword:(id)sender
{
    ResetPasswordViewController *rpVC = [[ResetPasswordViewController alloc] init];
    [self presentViewController:rpVC animated:YES completion:nil];
}

- (void) leftDrawerButtonClicked
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction) chooseDateButtonClicked : (id) sender
{
   
   }

- (IBAction) selectTimeButtonClicked : (id) sender
{
   [self setUpdateFrequency];
}

-(void)tap:(UIGestureRecognizer*)recognizer
{
    [self showDatePickerView:NO];
}

-(void)showDatePickerView:(BOOL)show
{
    if (show)
    {
        [self.view insertSubview:_transparentView belowSubview:datePickerBackView];
        [self.view bringSubviewToFront:_datePickerButton];
    }
    
    [self.view layoutIfNeeded];
    
    _datePickerYConstraint.constant = show ? 0 : -datePickerBackView.frame.size.height;
    CGFloat alpha = show ? 0.4 : 0;
    
    [UIView animateWithDuration:0.25 animations:^
    {
        _transparentView.alpha = alpha;
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished)
    {
        if (!show)
        {
            [_transparentView removeFromSuperview];
        }
    }];
}



#pragma mark
#pragma mark human api

- (IBAction)humanAPIButtonTapped:(UIButton *)sender
{
    [[HumanAPIManager sharedManager] connectHumanAPIFromViewController:self];
}

-(void)humanAPIDidSuccess
{
    
}

-(void)humanAPIDidFailWithError:(NSError *)error
{
    
}



#pragma mark
#pragma mark fitbit

- (IBAction)fitbitButtonTapped:(UIButton *)sender
{
    
    /*
     Fitbit swift call
     [[MSYFitBit shareFitBit] fetchDataFromFitbit:^(NSDictionary<NSString *,id> * _Nonnull result, BOOL success) {
        NSLog(@"Result %@",result);
    }];*/
    __weak typeof(self) weakSelf = self;
    
    [[FitbitManager sharedManager] isLoggedInWithCompletion:^(BOOL isLoggedIn)
    {
        __strong typeof(weakSelf) self = weakSelf;
        
        if (isLoggedIn)
        {
            [[[UIAlertView alloc] initWithTitle:@"Do you really want to logout from Fitbit?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
        }
        else
        {
            [FitbitManager sharedManager].delegate = self;
            [[FitbitManager sharedManager] showLoginModal];
            
            [self updateFitbitUIIfConnected:YES];
        }
    }];
}

-(void)fitbitDidFailWithError:(NSError *)error
{
    [self updateFitbitUIIfConnected:NO];
}

-(void)fitbitDidSuccess
{
    [self updateFitbitUIIfConnected:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        __weak typeof(self) weakSelf = self;
        [[FitbitManager sharedManager] logoutWithCompletion:^(BOOL succeeded, NSError *error)
        {
            if (succeeded)
            {
                __strong typeof(weakSelf) self = weakSelf;
                [self updateFitbitUIIfConnected:NO];
            }
        }];
    }
}



#pragma mark
#pragma mark mrn

- (IBAction)connectButtonTapped:(UIButton *)sender
{
 
    /*[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    __weak typeof(self) weakSelf = self;
    [[EHRManager sharedManager] MRNExistsWithCompletion:^(PFObject *object)
    {
        [SVProgressHUD popActivity];
        
        if (object)
        {
            EHRViewController *ehrViewController = [[EHRViewController alloc] init];
            ehrViewController.HL7Import = object;
            
            __strong typeof(weakSelf) self = weakSelf;
            [self presentViewController:ehrViewController animated:YES completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Incorrect mrn entered or no matching hl7" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];*/
}
- (void)setUpdateFrequency
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Frequency"
                                                                   message:@"Sending HealthKit data"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Once a Day"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one");
                                                             fireDateLabel.text=@"Once a Day";
                                                              [[NSUserDefaults standardUserDefaults] setObject:@"Once a Day" forKey:@"Frequency"];
                                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                                             [self startBackgroundTask];
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Twice a Day"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               fireDateLabel.text=@"Twice a Day";
                                                               [[NSUserDefaults standardUserDefaults] setObject:@"Twice a Day" forKey:@"Frequency"];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                               [self startBackgroundTask];
                                                           }];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Every Hour"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                fireDateLabel.text=@"Every Hour";
                                                               [[NSUserDefaults standardUserDefaults] setObject:@"Every Hour" forKey:@"Frequency"];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                               [self startBackgroundTask];
                                                           }]; 
    UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Every Minute"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               fireDateLabel.text=@"Every Minute";
                                                              [[NSUserDefaults standardUserDefaults] setObject:@"Every Minute" forKey:@"Frequency"];
                                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                                              [self startBackgroundTask];
                                                          }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    [alert addAction:fourthAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) startBackgroundTask
{
    float timeInterval;
    NSString *frequency = [[NSUserDefaults standardUserDefaults] objectForKey:@"Frequency"];
    if([frequency isEqualToString:@"Every Minute"])
    {
        timeInterval=1*1*60;
        
    }
    else if([frequency isEqualToString:@"Twice a Day"])
    {
        timeInterval=12*60*60;
    }
    else if([frequency isEqualToString:@"Every Hour"])
    {
        timeInterval=1*60*60;
    }
    else if([frequency isEqualToString:@"Once a Day"])
    {
        timeInterval=24*60*60;
    }
    NSTimer *timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                             target:self
                                           selector:@selector(performAction:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)performAction:(NSTimer*)theTimer
{
    [[GSHealthKitManager sharedManager] readStepCount];
    [[GSHealthKitManager sharedManager] readEnergyBurned];
    [[GSHealthKitManager sharedManager] queryHealthDataHeart];
}


@end
