//
//  ForgotPasswordViewController.m
//  Health
//
//  Created by Administrator on 9/12/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "HealthAppDelegate.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Common.h"
#import "Utility.h"
#import "ResetForgotPasswordViewController.h"
#import "SessionManager.h"

@interface ForgotPasswordViewController ()
@property(strong) NSDictionary *forgotPassres ;

@end

@implementation ForgotPasswordViewController

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
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    _forgotButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    _forgotButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
    _forgotButton.shadowHeight = 1;
    _forgotButton.shadowColor = [UIColor colorWithRed:49.0f/255.0f green:163.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [_forgotButton setCornerRadius:3.0f];
}

- (IBAction) forgotButtonClicked : (id) sender
{
    NSString *email = _emailTextField.text;
    
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( email == nil || [email isEqualToString:@""]  )
    {
        [_emailTextField becomeFirstResponder];
        return;
    }
   if(![Utility isValidEmailAddress:email])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter  email in valid format" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    
    [_emailTextField resignFirstResponder];
    
    [SVProgressHUD showWithStatus:@"Requesting..." maskType:SVProgressHUDMaskTypeBlack];
    SessionManager *manager = [SessionManager sharedManager];
    NSDictionary *parameters = @{@"emailId":email};
    
    [manager POST:@"v1/mobileAppForgotPassword" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.forgotPassres = (NSDictionary *)responseObject;
        
        
        [[[UIAlertView alloc] initWithTitle:@"Please check your email to reset your password" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        [SVProgressHUD dismiss];
        

        
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid user id/email" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        self->_emailTextField.text = @"";
         [SVProgressHUD dismiss];

        
    }];
  
   
}

- (IBAction) backButtonClicked : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        ResetForgotPasswordViewController *resetforgotPassVc = [[ResetForgotPasswordViewController alloc] init];
        
        [self.navigationController pushViewController:resetforgotPassVc animated:YES];
        
    }
    else
    {
        //Do something else
    }
}


@end
