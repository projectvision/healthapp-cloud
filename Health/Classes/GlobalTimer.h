//
//  GlobalTimer.h
//  Yabbit
//
//  Created by Apple on 07/10/16.
//  Copyright © 2016 projectvision. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface GlobalTimer : NSObject
{
   
}
@property() NSTimer* timer;
+(instancetype)sharedManager;

-(void)stepsForYesterdayWithCompletion:(void(^)(NSNumber* steps))completion;
-(void) startTimer;
-(void) stopTimer;

@end
