//
//  HistoryViewController.h
//  Health
//
//  Created by Administrator on 9/12/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView        *_historyTableView;
    
    IBOutlet UIButton           *_updateWeightButton;
    IBOutlet UIButton           *_updateWaistButton;
}

- (IBAction)updateWeightButtonTapped:(id)sender;
- (IBAction)updateWaistSizeButtonTapped:(id)sender;

@end
