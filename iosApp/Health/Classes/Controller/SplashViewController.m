//
//  SplashViewController.m
//  Health
//
//  Created by Administrator on 9/9/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Parse/Parse.h>
#import "SplashViewController.h"
#import "SharedData.h"
#import "HealthAppDelegate.h"
#import "GSHealthKitManager.h"
#import "SessionManager.h"
#import "SVProgressHUD.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadchallengeFinish:) name:kNotificationRefreshChallenge object:nil];
    [self showNextScreen];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showNextScreen
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionID"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""])
    {
        [self autoLoginWithUser:[defaults objectForKey:@"username"] password:[defaults objectForKey:@"password"]];

    }
    else
    {
        [self.navigationController pushViewController:appDelegate.loginViewController animated:YES];
    }
    

    
  }

- (void) loadChallengeData
{
    SharedData *sharedData = [SharedData sharedData];
    [sharedData loadChallengesWithCompletion:nil];
}

- (void) loadchallengeFinish : (NSNotification *) notification
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFUser *user = [PFUser currentUser];
    
    if ( user == nil ) {
        [self.navigationController pushViewController:appDelegate.loginViewController animated:YES];
    } else {
        [self.navigationController pushViewController:appDelegate.loginViewController animated:NO];
    }
}
-(void) autoLoginWithUser:email  password:password
{
     HealthAppDelegate *appDelegate = (HealthAppDelegate *)[[UIApplication sharedApplication] delegate];
    [SVProgressHUD showWithStatus:@"Logging..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSDictionary *parameters = @{@"username":email,@"password":password};
    
    SessionManager *manager = [SessionManager sharedManager];
    
    NSURLCredential *myCredential = [[NSURLCredential alloc] initWithUser:email password:password persistence:NSURLCredentialPersistenceForSession];
    [manager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        if (challenge.previousFailureCount == 0) {
            *credential = myCredential;
            return NSURLSessionAuthChallengeUseCredential;
        } else {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }];
    
    [manager POST:@"v1/login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *sessionId = (NSDictionary *)responseObject;
        NSString *session_ID=[sessionId valueForKey:@"jsessionid"];
        if(session_ID.length>0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:session_ID forKey:@"SessionID"];
            [[NSUserDefaults standardUserDefaults] setObject:@"autoLogin" forKey:@"loginType"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SVProgressHUD dismiss];
           
            [self checkAssessment];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Please try again later"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD dismiss];
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        
        [self.navigationController pushViewController:appDelegate.loginViewController animated:YES];

        
    }];
    
}

-(BOOL)checkAssessment
{
    
    HealthAppDelegate *appDelegate = (HealthAppDelegate *)[[UIApplication sharedApplication] delegate];

    __block BOOL *asses;
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/healthAssessmentOverallPercentage" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
       
        
        NSDictionary *assessmentPercent = (NSDictionary *)responseObject;
        if([assessmentPercent count]>0)
        {
            if([[assessmentPercent valueForKey:@"assessment"] boolValue])
            {
                asses=YES;
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"assesment_status"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                asses=NO;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"assesment_status"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            [self.navigationController pushViewController:appDelegate.rootViewController animated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        asses=NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"assesment_status"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         [self.navigationController pushViewController:appDelegate.rootViewController animated:YES];
        
    }];
    
    return asses;
    
}




@end
