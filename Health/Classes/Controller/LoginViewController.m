//
//  LoginViewController.m
//  Health
//
//  Created by Administrator on 9/11/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Parse/Parse.h>
#import "HealthAppDelegate.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "ForgotPasswordViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "SVProgressHUD.h"
#import "SharedData.h"
#import "Utility.h"
#import "Common.h"
#import "SessionManager.h"


@interface LoginViewController ()
@property(strong) NSDictionary *sessionId;

@end

@implementation LoginViewController
@synthesize healthStore;

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
    
    self.title = @"Health";
    [self initUI];
   
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"launched"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Welcome to Yabbit!" message:@"Yabbit is a tool to help you work with your doctor to accomplish your health goals. Each day, you will choose 3 health challenges among a number of options specific to your health goals. You can connect your wearable fitness tracker to let your care team see your progress. Lastly, Yabbit will track your movement through the day. All of the data from this app will be shared with your care team so that they can provide tailored and specific feedback to help you reach your goals." delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil, nil] show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user is alraidy Login
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        // Redirected to Dashboard.
         [self checkAssessment];
    }

    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    emailTextField.text = @"";
    passwordTextField.text= @"";
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadchallengeFinish:) name:kNotificationRefreshChallenge object:nil];
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

- (void) initUI
{
    loginButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    loginButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    loginButton.shadowHeight = 1;
    loginButton.shadowColor = [UIColor colorWithRed:49.0f/255.0f green:163.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [loginButton setCornerRadius:3.0f];
}

- (void) loadChallengeData
{
    SharedData *sharedData = [SharedData sharedData];
    
    [sharedData loadChallengesWithCompletion:nil];
}

- (void) loadchallengeFinish : (NSNotification *) notification
{
    HealthAppDelegate *appDelegate = (HealthAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate registerForNotifications];
    [self.navigationController pushViewController:appDelegate.rootViewController animated:YES];
}

- (IBAction) loginButtonClicked : (id) sender
{
    NSString *email = emailTextField.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( email == nil || email.length == 0) {
        
        [emailTextField becomeFirstResponder];
        return;
        
    }
    
    NSString *password = passwordTextField.text;
    
    if ( password.length == 0 ) {
     
        [passwordTextField becomeFirstResponder];
        return;
    }
    if(![Utility isValidEmailAddress:email])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter  email in valid format" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
       return;
    }
    else if(![Utility isValidPassword:password])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter password in valid format.Password should contain Atleast One Upper case,Lower case, Number and special symbol.Range should be 8-16 characters.EX: Abcd@123" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
         return;
    }

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
        self.sessionId = (NSDictionary *)responseObject;
        NSString *session_ID=[self.sessionId valueForKey:@"jsessionid"];
        if(session_ID.length>0)
        {
           [[NSUserDefaults standardUserDefaults] setObject:session_ID forKey:@"SessionID"];
           [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"username"];
           [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
           [[NSUserDefaults standardUserDefaults] setObject:@"appLogin" forKey:@"loginType"];
           [[NSUserDefaults standardUserDefaults] setObject:@"Once a Day" forKey:@"Frequency"];
           [[NSUserDefaults standardUserDefaults] synchronize];
           [self checkAssessment];
           [SVProgressHUD dismiss];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid credential"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
         [SVProgressHUD dismiss];
       if(![AFNetworkReachabilityManager sharedManager].reachable)
       {
           
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"Network not reachable"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
           [alertView show];

       }
       else
       {
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:nil error:nil];
        
       if(json==[NSNull null])
       {
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:[error localizedDescription]
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
           [alertView show];
       }
       else
        {
            if([[json valueForKey:@"code"]integerValue]==10015)
            {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid username and password combination"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[json valueForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
       }
     }
}];
    
}

- (IBAction) registerButtonClicked : (id) sender
{
    SignupViewController *signupVc = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    
    [self.navigationController pushViewController:signupVc animated:YES];
}

- (IBAction) forgotPassButtonClicked : (id) sender
{
    ForgotPasswordViewController *forgotPassVc = [[ForgotPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:forgotPassVc animated:YES];
}

-(BOOL)checkAssessment
{
    
    __block BOOL *asses;
    
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{};
    
    [manager GET:@"v1/healthAssessmentOverallPercentage" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //[self.navigationController popViewControllerAnimated:YES];
        
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
             [self loadchallengeFinish:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        asses=NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"assesment_status"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         //[self loadchallengeFinish:nil];
    }];
    
    return asses;
    
}


@end
