//
//  LocalNotificationHelper.h
//  Yabbit
//
//  Created by Fatih Ozkul on 1/31/17.
//  Copyright © 2017 projectvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationHelper : NSObject

+(void)notifyUserWithMessage:(NSString *)message inSeconds:(NSTimeInterval)inSeconds;
+(void)scheduleNotifications;
@end
