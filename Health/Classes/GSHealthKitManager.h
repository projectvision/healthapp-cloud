//
//  GSHealthKitManager.h
//  HealthBasics
//
//  Created by Lukas Petr on 24/07/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
@interface GSHealthKitManager : NSObject

+ (GSHealthKitManager *)sharedManager;
@property double stepcount;
- (void)requestAuthorization;

- (NSDate *)readBirthDate;
- (void)writeWeightSample:(CGFloat)weight;

- (void)writeWorkoutDataFromModelObject:(id)workoutModelObject;
-(double)readStepCount;
- (void)readEnergyBurned;
- (void)queryHealthDataHeart;
-(HKUnit *)heartBeatsPerMinuteUnit;

@end
