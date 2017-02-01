//
//  GlobalTimer.m
//  Yabbit
//
//  Created by Apple on 07/10/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import "GlobalTimer.h"
#import "NSDate+MTDates.h"
#import "SessionManager.h"
#import <Parse/Parse.h>

static NSString * const kLastUpdateDate = @"lastUpdateDate";


@implementation GlobalTimer
@synthesize timer;
+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static GlobalTimer *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[GlobalTimer alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


-(void) startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:28800
                                             target:self
                                           selector:@selector(performAction:)
                                           userInfo:nil
                                            repeats:YES];
    
}

- (void)performAction:(NSTimer*)theTimer
{
     NSTimeInterval difference=0.0;
    NSDictionary
     *lastLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserLastLocation"];
   
    NSNumber *latitude=[lastLocation objectForKey:@"lat"];
    NSNumber *longitude=[lastLocation objectForKey:@"long"];
    NSString *timestamp=[lastLocation objectForKey:@"timestamp"];
    NSString *currentTimestamp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    double current = [currentTimestamp doubleValue];
    double last=[timestamp doubleValue];
    difference = [[NSDate dateWithTimeIntervalSince1970:current] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:last]];
    NSLog(@"difference: %f", difference);
    long dur=(long)difference;
 NSNumber *duration = [NSNumber numberWithDouble:dur];
    
    SessionManager *sessionmanager = [SessionManager sharedManager];
    
    NSDictionary *parameters = @{@"latitude":latitude ,@"longitude":longitude,@"duration":duration};
    
    [sessionmanager POST:@"v1/patientGPSData" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:timestamp  forKey:@"kLastLocationUpdateTimestamp"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Gps updated"
                                                            message:@"gps updated"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];

    
}


@end
