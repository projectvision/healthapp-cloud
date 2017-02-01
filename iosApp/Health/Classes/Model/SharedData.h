//
//  SharedData.h
//  GiftMe
//
//  Created by Chenggong Huang on 5/17/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Challenge.h"
#import "Common.h"

@interface SharedData : NSObject
{
    BOOL        _loadFocusCompleted;
    BOOL        _loadChallengeCompleted;
    BOOL        _loadRewardCompleted;
    BOOL        _refreshCompleted;
}

@property (nonatomic, retain) NSMutableDictionary       *challengeList;
@property (nonatomic, retain) NSMutableDictionary       *acceptedChallengeList;;
@property (nonatomic, retain) NSMutableArray            *focusList;
@property (nonatomic, retain) NSMutableArray            *todayChallengeList;

@property (nonatomic, retain) NSMutableArray            *completedChallengeList;

+ (SharedData *) sharedData;

- (void) loadChallengesWithCompletion:(void (^)(NSDictionary *challenges))completion;
- (void) loadChallengestoday:(void (^)(NSDictionary *challenges))completion;
- (void) loadTodayChallenges : (BOOL) showLoading;
- (BOOL) checkExistInTodayChallengeList : (Challenge *) challenge;

- (void) loadFocus;

- (NSArray*) acceptedChallengeList;

- (BOOL) areTodayChallengesValid;
- (void) loadCompletedChallengeList;
- (void) scheduleNotification;
- (NSMutableDictionary *) randomSortedChallenges;

-(void)updateAcceptedChallengedWithExpirationTime:(NSDate*)epirationTime;

- (void) logoutUser;
@end
