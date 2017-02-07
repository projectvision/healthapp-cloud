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

+(void)clearNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+(void)scheduleNotifications
{
    [self clearNotifications];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
    NSDate *today = [calendar dateFromComponents:nowComponents];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.hour = 8; // 8am
    NSDate *morning = [calendar dateByAddingComponents:components toDate:today options:0];
    UILocalNotification *morningReminder = self.notificationTemplate;
    morningReminder.fireDate = morning;
    morningReminder.alertBody = @"It's time to accept new challenges. The old challenges will be expired.";
    morningReminder.category = @"NEW_CHALLENGES";
    [[UIApplication sharedApplication] scheduleLocalNotification:morningReminder];
    
    components.hour = 14; // 2pm
    NSDate *afternoon = [calendar dateByAddingComponents:components toDate:today options:0];
    UILocalNotification *afternoonReminder = self.notificationTemplate;
    afternoonReminder.fireDate = afternoon;
    afternoonReminder.alertBody = @"Don't forget to complete your challenges for today.";
    afternoonReminder.category = @"DONT_FORGET";
    [[UIApplication sharedApplication] scheduleLocalNotification:afternoonReminder];
    
    components.hour = 20; // 8pm
    NSDate *evening = [calendar dateByAddingComponents:components toDate:today options:0];
    UILocalNotification *eveningReminder = self.notificationTemplate;
    eveningReminder.fireDate = evening;
    eveningReminder.alertBody = @"Don't forget to complete your challenges for today.";
    eveningReminder.category = @"DONT_FORGET";
    [[UIApplication sharedApplication] scheduleLocalNotification:eveningReminder];
}

+(UILocalNotification *)notificationTemplate
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSCalendarUnitDay;
    notification.applicationIconBadgeNumber = 1;
    
    return notification;
}




@end
