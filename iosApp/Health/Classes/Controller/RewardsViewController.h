//
//  RewardsViewController.h
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardsCell.h"

@interface RewardsViewController : UIViewController<RewardCellDelegate>
{
    IBOutlet UITableView        *rewardsTableView;
    IBOutlet UIView             *titleView;
    IBOutlet UIButton           *badgeButton;
    IBOutlet UILabel            *titleLabel;
    
    NSInteger                   selectedIndex;
}

@property (nonatomic, retain) NSMutableArray        *rewardList;

@end
