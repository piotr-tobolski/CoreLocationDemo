//
//  NotificationHelper.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const NotificationHelperNotification;
extern NSString *const NotificationHelperNotificationMessageKey;

@interface NotificationHelper : NSObject

+ (void)registerForNotifications;
+ (void)showAlert:(NSString *)message;

@end
