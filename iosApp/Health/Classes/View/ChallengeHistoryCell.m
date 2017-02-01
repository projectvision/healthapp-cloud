//
//  HistoryCell.m
//  Yabbit
//
//  Created by Dmitry Levsevich on 6/26/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "ChallengeHistoryCell.h"
#import "Challenge.h"
#import "NSDate+MTDates.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "SharedData.h"


@interface ChallengeHistoryCell () {
    Challenge *challengeInfo;
}

@end

@implementation ChallengeHistoryCell

- (void)setHistoryCellInfo:(Challenge *)challenge
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:challenge.acceptedAt];
    NSString *timeStr = [date stringFromDateWithFormat:@"MM/dd/yyyy"];

    challengeInfo = challenge;
    titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", challenge.challenge, timeStr];

//    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
//
//    [badgeButton setTitle:[NSString stringWithFormat:@"%ld", (long)challenge.point] forState:UIControlStateNormal];
//
//    [badgeButton sizeToFit];

//    CGRect badgeRect = badgeButton.frame;
//    CGSize badgeSize = badgeRect.size;
//    CGSize newSize = CGSizeMake(badgeSize.width + 10, badgeSize.height + 3);
//    badgeRect.size = newSize;
//
//    badgeButton.frame = badgeRect;
}

@end
