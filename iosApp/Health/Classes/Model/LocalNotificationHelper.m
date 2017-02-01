//
//  LocalNotificationHelper.m
//  Yabbit
//
//  Created by Fatih Ozkul on 1/31/17.
//  Copyright © 2017 projectvision. All rights reserved.
//

#import "LocalNotificationHelper.h"

@implementation LocalNotificationHelper
+(void)notifyUserWithMessage:(NSString *)message inSeconds:(NSTimeInterval)inSeconds
{
    NSDate *requestedNotificationDate = [NSDate dateWithTimeIntervalSinceNow:inSeconds];
    NSDate *lastNotificationDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastSentNotification"];
    BOOL userAllowsNotifications = [[NSUserDefaults standardUserDefaults] boolForKey:@"allowsNotifications"];
    
    if (!userAllowsNotifications) {
        return;
    }
    
    if (!lastNotificationDate || [lastNotificationDate compare:requestedNotificationDate] == NSOrderedAscending) {
        
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        notification.alertBody = message;
        notification.fireDate = requestedNotificationDate;
        
        [[NSUserDefaults standardUserDefaults]setObject:requestedNotificationDate forKey:@"lastSentNotification"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    
}
@end
