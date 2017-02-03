//
//  BackgroundHealthApiCall.h
//  Yabbit
//
//  Created by Apple on 19/05/16.
//  Copyright © 2016 projectvision. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface BackgroundApiCall: NSObject

+(void) postHeartRate:(double)hrate;
+(void) postPatientStepCount:(double)steps;
+(void) postPatientCaloriesBurned:(double)calories;
+(void) postPatientWeight:(int)weight;
+(void) postPatientWaist:(int)waist;

@end