//
//  SignupViewController.m
//  Health
//
//  Created by Administrator on 9/11/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "SignupViewController.h"
#import "HealthAppDelegate.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "NSDate+MTDates.h"
#import "Common.h"
#import "Utility.h"
#import "SessionManager.h"


@interface SignupViewController ()
@property(strong) NSDictionary *userReg ;


@end

@implementation SignupViewController

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

    [self initUI];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    signupButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    signupButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    signupButton.shadowHeight = 1;
    signupButton.shadowColor = [UIColor colorWithRed:49.0f/255.0f green:163.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [signupButton setCornerRadius:3.0f];
}

- (IBAction) loginButtonClicked : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) registerButtonClicked : (id) sender
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
    
    NSString *retypePass = retypePasswordTextField.text;
    
    retypePass = [retypePass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( retypePass == nil || retypePass.length == 0 ) {
        
        [retypePasswordTextField becomeFirstResponder];
        return;
    }
    
    
    if(![Utility isValidEmailAddress:email])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter email in valid format." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         [alertview show];
          return;
    }
    
    else if(![Utility isValidPassword:password])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enters correct password. Password should contain Atleast One Upper case,Lower case, Number and special symbol.EX: Abcd@123" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    else if(![Utility isValidPassword:retypePass])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please retype password in valid format.Password should contain Atleast One Upper case,Lower case, Number and special symbol.EX: Abcd@123" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
   else if ( [password isEqualToString:retypePass] == NO )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check if password matches." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }


    NSString* invitationCode=invitationCodeTextfield.text;
    if(invitationCode.length<8)
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Invitation code is too short" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Registering..." maskType:SVProgressHUDMaskTypeBlack];
    
    SessionManager *manager = [SessionManager sharedManager];
    
    NSURLCredential *myCredential = [[NSURLCredential alloc] initWithUser:@"root" password:@"root" persistence:NSURLCredentialPersistenceForSession];
    [manager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
        if (challenge.previousFailureCount == 0) {
            *credential = myCredential;
            return NSURLSessionAuthChallengeUseCredential;
        } else {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }];

    NSDictionary *parameters = @{@"userName":email,@"firstName":@"",@"lastName":@"",@"password":password,@"invitationCode":invitationCode};
    
    [manager POST:@"v1/registerPatient" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.userReg = (NSDictionary *)responseObject;
        NSString *response=[self.userReg valueForKey:@"response"];
        if(response.length>1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"user register successfully"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:nil error:nil];
                                  
 
        
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[json valueForKey:@"message"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
        
    }];
        
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
         [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        //Do something else
    }
}

@end
