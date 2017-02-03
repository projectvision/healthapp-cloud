//
//  MotionManager.m
//  Health
//
//  Created by Alex Volchek on 5/11/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import "MotionManager.h"
#import "NSDate+MTDates.h"
#import <Parse/Parse.h>

static NSString * const kLastUpdateDate = @"lastUpdateDate";
static NSString * const kActivitiesImport = @"ActivitiesImport";

@implementation MotionManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static MotionManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[MotionManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pedometer = [[CMPedometer alloc] init];
        _lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateDate];
    }
    return self;
}


-(void)stepsForYesterdayWithCompletion:(void(^)(NSNumber* steps))completion
{
    NSDate *now = [NSDate date];
    NSDate *yesterday = [now oneDayPrevious];
    NSDate *startOfYesterday = [now startOfPreviousDay];
    NSDate *endOfYesterday = [now endOfPreviousDay];
    BOOL isTodayUpdateDate = [_lastUpdateDate isWithinSameDay:now];
    
    __weak typeof(self) weakSelf = self;
    
    if (_pedometer)
    {
        [_pedometer queryPedometerDataFromDate:startOfYesterday toDate:endOfYesterday withHandler:^(CMPedometerData *pedometerData, NSError *error)
         {
             if (pedometerData)
             {
                 if (!isTodayUpdateDate && [PFUser currentUser])
                 {
                     PFQuery *query = [PFQuery queryWithClassName:kActivitiesImport];
                     [query whereKey:@"user" equalTo:[PFUser currentUser]];
                     [query whereKey:@"Date" greaterThanOrEqualTo:startOfYesterday];
                     [query whereKey:@"Date" lessThanOrEqualTo:endOfYesterday];
                     [query whereKey:@"source" equalTo:@"iphone"];
                     
                     [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                      {
                          if (object)
                          {
                              object[@"Steps"] = pedometerData.numberOfSteps;
                              [object saveInBackground];
                          }
                          else
                          {
                              PFObject *activity = [PFObject objectWithClassName:kActivitiesImport];
                              activity[@"user"] = [PFUser currentUser];
                              activity[@"Date"] = yesterday;
                              activity[@"source"] = @"iphone";
                              activity[@"Steps"] = pedometerData.numberOfSteps;
                              [activity saveInBackground];
                          }
                          
                          __strong typeof(weakSelf) self = weakSelf;
                          self->_lastUpdateDate = now;
                          
                          [[NSUserDefaults standardUserDefaults] setObject:now forKey:kLastUpdateDate];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                      }];
                 }
                 completion(pedometerData.numberOfSteps);
             }
             else
             {
                 completion(@0);
             }
         }];
    }
    else
    {
        completion(@0);
    }
}

@end
