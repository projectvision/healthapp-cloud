//
//  LoginViewController.h
//  Health
//
//  Created by Administrator on 9/11/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "DashboardViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
@import HealthKit;

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField        *emailTextField;
    IBOutlet UITextField        *passwordTextField;
    IBOutlet FUIButton          *loginButton;
    IBOutlet FUIButton          *signupButton;
    
    IBOutlet TPKeyboardAvoidingScrollView *_scrollView;
}
@property (nonatomic) HKHealthStore *healthStore;
-(BOOL)checkAssessment;

@end
