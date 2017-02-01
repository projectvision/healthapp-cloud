//
//  Challenge.h
//  Health
//
//  Created by Administrator on 9/7/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "EGODatabaseRow.h"

@interface Challenge : NSObject

@property (nonatomic, assign) NSInteger     insertId;
@property (nonatomic, retain) NSString      *objectId;
@property (nonatomic, assign) NSInteger     challengeId;
@property (nonatomic, assign) NSInteger     focusId;
@property (nonatomic, assign) NSInteger     level;
@property (nonatomic, retain) NSString      *challenge;
@property (nonatomic, assign) NSInteger     point;
@property (nonatomic, assign) double        acceptedAt;
@property (nonatomic, assign) double        expiredAt;
@property (nonatomic, assign) BOOL          completed;
@property (nonatomic, assign) BOOL          accepted;

+ (Challenge *) initChallengeWithTodayChallengeObject : (PFObject *) object;
+ (Challenge *) initChallengeWithParseObject : (PFObject *) object;
- (NSComparisonResult) compare : (Challenge *) other_challenge;
- (NSComparisonResult) compareByFocus : (Challenge *) other_challenge;

@end
