//
//  ResetForgotPasswordViewController.h
//  Yabbit
//
//  Created by Apple on 31/03/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface ResetForgotPasswordViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *retypePasswordTextField;
    IBOutlet UITextField *resetIdTextField;
   
    IBOutlet FUIButton *resetButton;
    IBOutlet FUIButton *backLoginButton;
}
- (IBAction)resetClicked:(id)sender;


@end
