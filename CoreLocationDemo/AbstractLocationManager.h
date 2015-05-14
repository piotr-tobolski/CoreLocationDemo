//
//  AbstractLocationManager.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "StorageManager.h"
#import "NotificationHelper.h"

@interface AbstractLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

- (BOOL)started;
- (BOOL)available;

@end
