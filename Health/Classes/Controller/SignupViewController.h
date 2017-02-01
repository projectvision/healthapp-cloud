//
//  SignupViewController.h
//  Health
//
//  Created by Administrator on 9/11/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface SignupViewController : UIViewController
{
    IBOutlet UITextField        *emailTextField;
    IBOutlet UITextField        *retypePasswordTextField;
    IBOutlet UITextField        *invitationCodeTextfield;
    IBOutlet UITextField        *passwordTextField;
    IBOutlet FUIButton          *loginButton;
    IBOutlet FUIButton          *signupButton;
}

@end
