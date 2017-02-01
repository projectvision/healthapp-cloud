//
//  RewardsCell.h
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FUIButton.h"

@protocol RewardCellDelegate <NSObject>

- (void) didSelectRewardCell : (NSInteger) index;

@end

@interface RewardsCell : UITableViewCell
{
    IBOutlet UILabel                    *titleLabel;
    IBOutlet UIButton                   *badgeButton;
    IBOutlet FUIButton                  *selectButton;
    IBOutlet UIActivityIndicatorView    *indicatorView;
}

@property (nonatomic, retain) IBOutlet UILabel                  *titleLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *indicatorView;

@property (nonatomic, assign) id<RewardCellDelegate>    delegate;
@property (nonatomic, assign) NSInteger     cellIndex;

- (void) setRewardsCellInfo : (PFObject *) reward;

@end
