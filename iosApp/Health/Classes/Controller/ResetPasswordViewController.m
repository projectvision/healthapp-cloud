//
//  ResetPasswordViewController.m
//  Yabbit
//
//  Created by Alex Volchek on 5/20/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "SessionManager.h"
#import "utility.h"
#import "SettingViewController.h"

@interface ResetPasswordViewController ()

@end


@implementation ResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initUI
{
    
   _resetButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
  _resetButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
  _resetButton.shadowHeight = 1;
  _resetButton.shadowColor = [UIColor colorWithRed:49.0f/255.0f green:163.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [_resetButton setCornerRadius:3.0f];
}


- (IBAction)resetButtonTapped:(UIButton *)sender
{
    NSString *curr=currentPasswordTextfield.text;
    NSString *new= _newPasswordTextField.text;
    NSString *confirm = _confirmTextField.text;
   
    if(![Utility isValidPassword:curr])
        
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter current password in valid format.Password should contain Atleast One Upper case,Lower case, Number and special symbol.Range should be 8-16 characters.EX: Abcd@123" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if(![Utility isValidPassword:new])

    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter new  password in valid format.Password should contain Atleast One Upper case,Lower case, Number and special symbol.Range should be 8-16 characters.EX: Abcd@123" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if(![Utility isValidPassword:confirm])

    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter confirm password in valid format" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if ( [new isEqualToString:confirm] == NO )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check if password matches." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
   
    
    [SVProgressHUD showWithStatus:@"Resetting..." maskType:SVProgressHUDMaskTypeBlack];
    SessionManager *manager = [SessionManager sharedManager];
    
    NSDictionary *parameters = @{@"currentPassword":curr ,@"newPassword":new};
    
    [manager POST:@"v1/patientResetPassword" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password reset successfully"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@" Error.."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [SVProgressHUD dismiss];
        
    }];
    
}

-(void)tap:(UIGestureRecognizer*)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (IBAction)backButtonTapped:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
