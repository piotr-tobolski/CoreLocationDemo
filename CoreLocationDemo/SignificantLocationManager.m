//
//  SignificantLocationManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "SignificantLocationManager.h"

@implementation SignificantLocationManager

+ (instancetype)sharedInstance {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[[self class] alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    if (self = [super init]) {
//        [self.locationManager requestAlwaysAuthorization];
        if ([StorageManager sharedInstance].significantMonitoringEnabled) {
            [self start];
        }
    }
    return self;
}

- (void)start {
    [self.locationManager startMonitoringSignificantLocationChanges];
    [StorageManager sharedInstance].significantMonitoringEnabled = YES;
}

- (void)stop {
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [StorageManager sharedInstance].significantMonitoringEnabled = NO;
}

- (BOOL)started {
    return [StorageManager sharedInstance].significantMonitoringEnabled;
}

- (BOOL)available {
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        return [super available];
    }
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        Location *loc = [[Location alloc] initWithCLLocation:location];
        NSString *time = [NSDateFormatter localizedStringFromDate:location.timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        loc.name = [NSString stringWithFormat:@"S %@", time];
        [[StorageManager sharedInstance] appendLocation:loc];
        [NotificationHelper showAlert:[NSString stringWithFormat:@"SIGNIFICANT %@", location]];
    }
}

@end
