//
//  ForgotPasswordViewController.h
//  Health
//
//  Created by Administrator on 9/12/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface ForgotPasswordViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet FUIButton      *_forgotButton;
    IBOutlet UITextField    *_emailTextField;
}

@end
