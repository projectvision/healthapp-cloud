//
//  ChallengeCell.m
//  Health
//
//  Created by Administrator on 9/1/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "ChallengeCell.h"
#import "Challenge.h"
#import "NSDate+MTDates.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "SharedData.h"

@interface ChallengeCell() {
    Challenge *challengeInfo;
}

@end

@implementation ChallengeCell

- (void)setChallengeCellInfo:(Challenge *)challenge
{
    challengeInfo = challenge;
    
    if ( challenge.completed == YES ) {
        [icoButton setImage:[UIImage imageNamed:@"ico_challenge_checked.png"] forState:UIControlStateNormal];
    } else {
        [icoButton setImage:[UIImage imageNamed:@"ico_challenge_unchecked.png"] forState:UIControlStateNormal];
    }
        
    titleLabel.text = challenge.challenge;
    
    [badgeButton setBackgroundImage:[[UIImage imageNamed:@"ico_badge.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9] forState:UIControlStateNormal];
    
    [badgeButton setTitle:[NSString stringWithFormat:@"%ld", (long)challenge.point] forState:UIControlStateNormal];
    
    [badgeButton sizeToFit];
    
    CGRect badgeRect = badgeButton.frame;
    CGSize badgeSize = badgeRect.size;
    CGSize newSize = CGSizeMake(badgeSize.width + 10, badgeSize.height + 3);
    badgeRect.size = newSize;
    
    badgeButton.frame = badgeRect;
}

- (void)completeChallenge {
//    PFQuery *query = [PFQuery queryWithClassName:@"UserChallenges"];
//    PFUser *user = [PFUser currentUser];

//    [query getObjectInBackgroundWithId:challengeInfo.objectId block:^(PFObject *object, NSError *error) {
//       
//        object[@"completed"] = [NSNumber numberWithInt:1];
//        object[@"completedAt"] = [NSDate date];
//        
//        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            
//            if ( succeeded == YES ) {
//                
//                SharedData *sharedData = [SharedData sharedData];
//                [sharedData loadCompletedChallengeList];
//                
//                challengeInfo.completed = 1;
//                
//                [icoButton setImage:[UIImage imageNamed:@"ico_challenge_checked"] forState:UIControlStateNormal];
//
//                NSInteger earnedPoint = [user[@"earnedPoint"] integerValue];
//                
//                earnedPoint += challengeInfo.point;
//                
//                user[@"earnedPoint"] = [NSNumber numberWithInteger:earnedPoint];
//                
//                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    
//                    if ( succeeded == YES ) {
//                        
//                    }
//                    
//                    [SVProgressHUD dismiss];
//                    
//                }];
//                
//            } else {
//                
//                [SVProgressHUD dismiss];
//                
//            }
//            
//        }];
//        
//    }];
}

- (IBAction)completeButtonClicked:(id)sender
{
    if (challengeInfo.completed == YES) {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did you complete this challenge?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self.delegate completeChallenge:challengeInfo];
    }
}

@end
