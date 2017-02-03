//
//  BackgroundHealthApiCall.m
//  Yabbit
//
//  Created by Apple on 19/05/16.
//  Copyright © 2016 projectvision. All rights reserved.
//
#import "BackgroundApiCall.h"
#import "SessionManager.h"
#import "GSHealthKitManager.h"

@implementation BackgroundApiCall

- (id) init {
    
    if ( self = [super init] ) {
        
    }
    
    return self;
}





+(void) postHeartRate:(double)hrate
{
    SessionManager *manager = [SessionManager sharedManager];
     NSNumber *tempHRate = [[NSNumber alloc] initWithDouble:hrate];
    NSInteger hr= [tempHRate intValue];

    NSDictionary *parameters = @{@"heartRate":[NSNumber numberWithInt:hr]};
    
    [manager POST:@"v1/patientHeartRateRecord" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
            
          }];
}

+(void) postPatientStepCount:(double)steps
{
    SessionManager *manager = [SessionManager sharedManager];
    NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:steps];
    NSDictionary *parameters = @{@"stepCount":tempNumber};
    
    [manager POST:@"v1/patientStepCount" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
        }];
    
}

+(void) postPatientCaloriesBurned:(double)calories
{
    SessionManager *manager = [SessionManager sharedManager];
    NSNumber *tempCal= [[NSNumber alloc] initWithDouble:calories];

    NSDictionary *parameters = @{@"caloriesBurned":tempCal};
    
    [manager POST:@"v1/patientCaloriesBurned" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
          }];
}

+(void) postPatientWeight:(int)weight
{
    SessionManager *manager = [SessionManager sharedManager];
    NSNumber *tempWeight= [[NSNumber alloc] initWithInt:weight];

    NSDictionary *parameters = @{@"weight":tempWeight};
    
    [manager POST:@"v1/patientWeightRecord" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
          }];
}
+(void) postPatientWaist:(int)waist
{
    SessionManager *manager = [SessionManager sharedManager];
    NSNumber *tempWaist= [[NSNumber alloc] initWithInt:waist];
    
    NSDictionary *parameters = @{@"waistCircumference":tempWaist};
    
    [manager POST:@"v1/patientWaistSize" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
          }];
}


@end
