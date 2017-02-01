//
//  ResetForgotPasswordViewController.m
//  Yabbit
//
//  Created by Apple on 31/03/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import "ResetForgotPasswordViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "HealthAppDelegate.h"
#import "Utility.h"
#import  "Common.h"
#import "SessionManager.h"


@interface ResetForgotPasswordViewController()
@property(strong) NSDictionary *resetPass ;

@end


@implementation ResetForgotPasswordViewController

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
   resetButton.buttonColor = [UIColor colorWithRed:79.0f/255.0f green:193.0f/255.0f blue:233.0f/255.0f alpha:1.0];
   resetButton.highlightedColor = [UIColor colorWithRed:59.0f/255.0f green:173.0f/255.0f blue:213.0f/255.0f alpha:1.0];
   resetButton.shadowHeight = 1;
   resetButton.shadowColor = [UIColor colorWithRed:49.0f/255.0f green:163.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [resetButton setCornerRadius:3.0f];
}



- (IBAction)resetClicked:(id)sender
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
    
    if ( [password isEqualToString:retypePass] == NO )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please check if password matches." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
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
    NSString *resetId=resetIdTextField.text;
    if(resetId.length==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset id should not empty" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Resetting..." maskType:SVProgressHUDMaskTypeBlack];
    SessionManager *manager = [SessionManager sharedManager];
   
    NSDictionary *parameters = @{@"userName":email,@"resetCode":resetId,@"password":password};
    
    [manager POST:@"v1/resetPassword" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.resetPass = (NSDictionary *)responseObject;
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
    [SVProgressHUD dismiss];
    
}
- (IBAction) backButtonClicked : (id) sender
{
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
       [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
        
    }
    else
    {
        //Do something else
    }
}


@end
