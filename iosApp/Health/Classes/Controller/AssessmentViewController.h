//
//  AssessmentViewController.h
//  Health
//
//  Created by Yuan on 1/27/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentCell.h"
#import "FUIButton.h"
#import <Parse/Parse.h>
@interface AssessmentViewController : UIViewController<AssessmentCellDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView        *dashboardTableView;
    IBOutlet UINavigationBar    *dateNavigationBar;
    IBOutlet UIView             *titleView;
    IBOutlet UIButton           *badgeButton;
    IBOutlet UILabel            *titleLabel;
    IBOutlet UITableView        *tb;
    
    UIViewController            *_leftDrawerController;
}

@property (weak, nonatomic) IBOutlet FUIButton *submitButton;
@property(strong) NSDictionary *assessmentPercent;

@end
