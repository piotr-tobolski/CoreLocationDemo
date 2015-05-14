//
//  RegionLocationManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 04.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "RegionLocationManager.h"

@implementation RegionLocationManager

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
    }
    return self;
}

- (void)start {
    CLRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(0, 0)
                                                         radius:100
                                                     identifier:@"identifier"];
    
    [self.locationManager startMonitoringForRegion:region];
}

- (void)stop {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        if ([region isKindOfClass:[CLCircularRegion class]]) {
            [self.locationManager stopMonitoringForRegion:region];
        }
    }
}

- (BOOL)started {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        if ([region isKindOfClass:[CLCircularRegion class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)available {
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        return [super available];
    }
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        [NotificationHelper showAlert:@"STARTED REGION"];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        [NotificationHelper showAlert:[NSString stringWithFormat:@"REGION FAILED %@", error]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        [NotificationHelper showAlert:@"ENTER REGION"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        [NotificationHelper showAlert:@"LEAVE REGION"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        if (state == CLRegionStateInside) {
            [NotificationHelper showAlert:@"REGION INSIDE"];
            
        } else if (state == CLRegionStateOutside) {
            [NotificationHelper showAlert:@"REGION OUTSIDE"];
            
        } else {
            [NotificationHelper showAlert:@"REGION STATE UNKNOWN"];
        }
    }
}

@end
