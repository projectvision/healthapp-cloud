//
//  ChallengeCell.h
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"

@protocol ChallengeCellDelegate <NSObject>
- (void)completeChallenge:(nonnull Challenge *)challenge;
@end

@interface ChallengeCell : UITableViewCell
{
    IBOutlet UIButton           *icoButton;
    IBOutlet UILabel            *titleLabel;
    IBOutlet UIButton           *badgeButton;
}

@property (nonatomic, weak, nullable) id<ChallengeCellDelegate> delegate;

- (void)setChallengeCellInfo:(nonnull Challenge *)challenge;

@end
