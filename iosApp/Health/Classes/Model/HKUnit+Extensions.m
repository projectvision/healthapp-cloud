//
//  NSObject+HKUnit.m
//  Yabbit
//
//  Created by Apple on 27/05/16.
//  Copyright © 2016 projectvision. All rights reserved.
//

#import "HKUnit+Extensions.h"

@implementation HKUnit (GSHealthKitManager)

+ (HKUnit *)heartBeatsPerMinuteUnit {
    return [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
}
@end
