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
    NSLog(@"%@", [now description]);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
    NSDate *today = [calendar dateFromComponents:nowComponents];
    NSLog(@"%@", [today description]);
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.hour = 8;
    NSDate *morning = [calendar dateByAddingComponents:components toDate:today options:0];
    NSLog(@"%@", [morning description]);
    UILocalNotification *morningReminder = self.template;
    morningReminder.fireDate = morning;
    morningReminder.alertBody = @"It's time to accept new challenges. The old challenges will be expired.";
    [[UIApplication sharedApplication] scheduleLocalNotification:morningReminder]; // 8am
    
    components.hour = 14;
    NSDate *afternoon = [calendar dateByAddingComponents:components toDate:today options:0];
    NSLog(@"%@", [afternoon description]);
    UILocalNotification *afternoonReminder = self.template;
    afternoonReminder.fireDate = afternoon;
    afternoonReminder.alertBody = @"Don't forget to complete your challenges for today";
    [[UIApplication sharedApplication] scheduleLocalNotification:afternoonReminder]; // 2pm
    
    components.hour = 20;
//    components.hour = 17;
//    components.minute = 15;
    NSDate *evening = [calendar dateByAddingComponents:components toDate:today options:0];
    NSLog(@"%@", [evening description]);
    UILocalNotification *eveningReminder = self.template;
    eveningReminder.fireDate = evening;
    eveningReminder.alertBody = @"Don't forget to complete your challenges for today";
    [[UIApplication sharedApplication] scheduleLocalNotification:eveningReminder]; //8pm
}

+(UILocalNotification *)template
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSCalendarUnitDay;
    
    return notification;
}




@end
