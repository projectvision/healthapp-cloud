//
//  RewardDetailViewController.h
//  Health
//
//  Created by Administrator on 9/15/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RewardDetailViewController : UIViewController
{
    IBOutlet UILabel        *nameLabel;
    IBOutlet UILabel        *locationLabel;
    IBOutlet UILabel        *restrictionLabel;
    IBOutlet UILabel        *pointLabel;
}

@property (nonatomic, retain) PFObject  *reward;

@end
