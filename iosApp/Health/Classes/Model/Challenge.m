//
//  Challenge.m
//  Health
//
//  Created by Administrator on 9/7/14.
//  Copyright (c) 2014 projectvision. All rights reserved.
//

#import "Challenge.h"
#import "SharedData.h"

@implementation Challenge
@synthesize insertId;
@synthesize challengeId;
@synthesize focusId;
@synthesize level;
@synthesize challenge;
@synthesize point;
@synthesize acceptedAt;
@synthesize expiredAt;
@synthesize completed;
@synthesize accepted;

- (id) init {
    
    if ( self = [super init] ) {
        
    }
    
    return self;
}

+ (Challenge *) initChallengeWithTodayChallengeObject :(PFObject *) object
{
    SharedData *sharedData = [SharedData sharedData];
    
    Challenge *newChallenge = [[Challenge alloc] init];
    newChallenge.challengeId = [object[@"challengeId"] integerValue];
    newChallenge.focusId = [object[@"focusId"] integerValue];
    newChallenge.level = [object[@"level"] integerValue];
    newChallenge.challenge = object[@"challenge"];
    newChallenge.point = [object[@"points"] integerValue];
    newChallenge.objectId = object[@"id"];
    if(object[@"completionDate"]==(id)[NSNull null])
        newChallenge.completed = NO;
    else
        newChallenge.completed = YES;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ";
    NSDate *acceptedDate=[formatter dateFromString:object[@"acceptanceDate"]];
    newChallenge.acceptedAt=[acceptedDate timeIntervalSince1970];
    
    
    /*
    
   newChallenge.acceptedAt=[object[@"acceptanceDate"] timeIntervalSince1970];
   newChallenge.expiredAt = [object[@"expiredAt"] timeIntervalSince1970];*/
    
    return newChallenge;
}

+ (Challenge *) initChallengeWithParseObject : (PFObject *) object
{
    Challenge *challenge= [[Challenge alloc] init];
    
    challenge.challengeId = [object[@"challengeId"] integerValue];
    challenge.focusId = [object[@"focusId"] integerValue];
    challenge.level = [object[@"level"] integerValue];
    challenge.challenge = object[@"challenge"];
    challenge.point = [object[@"points"] integerValue];
   // challenge.acceptedAt = [object[@"acceptedAt"] timeIntervalSince1970];
    return challenge;
}

- (NSComparisonResult) compare : (Challenge *) other_challenge
{
    NSNumber *firstPoint = [NSNumber numberWithInteger:self.point];
    NSNumber *secondPoint = [NSNumber numberWithInteger:other_challenge.point];
    
    if ( [firstPoint compare:secondPoint] == NSOrderedAscending )
        return NSOrderedDescending;
    else if ( [firstPoint compare:secondPoint] == NSOrderedDescending )
        return NSOrderedAscending;
    
    return NSOrderedSame;
}

- (NSComparisonResult) compareByFocus : (Challenge *) other_challenge
{
    NSNumber *firstPoint = [NSNumber numberWithInteger:self.focusId];
    NSNumber *secondPoint = [NSNumber numberWithInteger:other_challenge.focusId];
    
    return [firstPoint compare:secondPoint];
    /*
    NSNumber *firstPoint = [NSNumber numberWithInteger:self.focusId];
    NSNumber *secondPoint = [NSNumber numberWithInteger:other_challenge.focusId];
    
    if ( [firstPoint compare:secondPoint] == NSOrderedAscending )
        return NSOrderedDescending;
    else if ( [firstPoint compare:secondPoint] == NSOrderedDescending )
        return NSOrderedAscending;
    
    return NSOrderedSame;
     */
    
}

@end
