//
//  SettingViewController.h
//  Health
//
//  Created by Administrator on 9/11/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitbitManager.h"
#import "HumanAPIManager.h"


@interface SettingViewController : UIViewController <NSURLConnectionDelegate, UIAlertViewDelegate, HumanAPIManagerDelegate, FitbitManagerDelegate>
{
    IBOutlet UIButton   *_fitbitButton;
    IBOutlet UILabel    *_fitbitLabel;
    
    
    IBOutlet UILabel *_humanAPILabel;
    IBOutlet UIButton *_humanAPIButton;
    
    IBOutlet UILabel                    *fireDateLabel;
    
    IBOutlet UIView                     *pickerBackView;
    IBOutlet UIActivityIndicatorView    *loadingActivityIndicatorView;

    IBOutlet UIView                     *datePickerBackView;
    IBOutlet UIDatePicker               *datePicker;
    
    IBOutlet NSLayoutConstraint         *_datePickerYConstraint;
    UIView                              *_transparentView;
    IBOutlet UIButton                   *_datePickerButton;

    IBOutlet UIButton                   *_MRNButton;
    IBOutlet UILabel                    *_MRNLabel;
}


@end
