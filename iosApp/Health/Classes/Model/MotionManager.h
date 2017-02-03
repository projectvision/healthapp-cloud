//
//  MotionManager.h
//  Health
//
//  Created by Alex Volchek on 5/11/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MotionManager : NSObject
{
    CMPedometer *_pedometer;
    NSDate *_lastUpdateDate;
}

+(instancetype)sharedManager;

-(void)stepsForYesterdayWithCompletion:(void(^)(NSNumber* steps))completion;

@end
