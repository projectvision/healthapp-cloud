//
//  DashboardViewController.h
//  Health
//
//  Created by Administrator on 8/29/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UINavigationBar    *dateNavigationBar;
    IBOutlet UILabel            *placeholderLabel;
    
    NSDictionary *_humanAPIData;
    NSDictionary *_fitbitData;
}

@end
