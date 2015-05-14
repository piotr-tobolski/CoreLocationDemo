//
//  NotificationHelper.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "NotificationHelper.h"
#import "StorageManager.h"

NSString *const NotificationHelperNotification = @"NotificationHelperNotification";
NSString *const NotificationHelperNotificationMessageKey = @"NotificationHelperNotificationMessageKey";

@implementation NotificationHelper

+ (void)registerForNotifications {
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
}

+ (void)showAlert:(NSString *)message {
    NSLog(@"ALERT: %@", message);
    if (message) {
        [[StorageManager sharedInstance] appendMessage:message];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = message;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHelperNotification object:self userInfo:@{NotificationHelperNotificationMessageKey : message}];
    }
}

@end
