//
//  HistoryCell.h
//  Yabbit
//
//  Created by Dmitry Levsevich on 6/26/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Challenge;

@interface ChallengeHistoryCell : UITableViewCell {
    IBOutlet UILabel            *titleLabel;
}

- (void)setHistoryCellInfo:(nonnull Challenge *)challenge;

@end
