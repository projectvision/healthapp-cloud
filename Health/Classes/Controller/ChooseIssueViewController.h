//
//  ChooseIssueViewController.h
//  Health
//
//  Created by Administrator on 9/15/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface ChooseIssueViewController : UIViewController
{
    IBOutlet UIPickerView   *issuePickerView;
    IBOutlet FUIButton      *chooseButton;
    NSMutableArray          *issueList;
}

@end
