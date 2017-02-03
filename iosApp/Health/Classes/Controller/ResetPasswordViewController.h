//
//  ResetPasswordViewController.h
//  Yabbit
//
//  Created by Alex Volchek on 5/20/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface ResetPasswordViewController : UIViewController<UIAlertViewDelegate>

{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_newPasswordLabel;
    IBOutlet UILabel *_confirmLabel;
    
    IBOutlet UITextField *currentPasswordTextfield;
    IBOutlet UITextField *_newPasswordTextField;

    __weak IBOutlet UITextField * _confirmTextField;
    IBOutlet FUIButton *_resetButton;
}

- (IBAction)resetButtonTapped:(UIButton *)sender;
- (IBAction)backButtonTapped:(UIButton *)sender;

@end
