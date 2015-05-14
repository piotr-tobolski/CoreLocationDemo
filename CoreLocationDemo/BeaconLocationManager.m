//
//  BeaconLocationManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 04.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "BeaconLocationManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeaconLocationManager ()
@property (nonatomic) CLProximity lastProximity;
@end

@implementation BeaconLocationManager

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
        _lastProximity = CLProximityUnknown;
    }
    return self;
}

- (CLBeaconRegion *)beaconRegion {
    static CLBeaconRegion *region = nil;
    if (region == nil) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"];
        region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:13 minor:9 identifier:@"beacon.identifier"];
        region.notifyEntryStateOnDisplay = YES;
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
    }
    return region;
}

- (void)start {
    if (self.locationManager.monitoredRegions.count == 0) {
        CLBeaconRegion *region = [self beaconRegion];
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

- (void)stop {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        if ([region isKindOfClass:[CLBeaconRegion class]]) {
            [self.locationManager stopMonitoringForRegion:region];
        }
    }
    
    for (CLBeaconRegion *region in self.locationManager.rangedRegions) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

- (BOOL)started {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        if ([region isKindOfClass:[CLBeaconRegion class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)available {
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        return [super available];
    }
    return NO;
}

#pragma mark -
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [NotificationHelper showAlert:@"STARTED B REGION"];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [NotificationHelper showAlert:[NSString stringWithFormat:@"B REGION FAILED %@", error]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [NotificationHelper showAlert:@"ENTER B REGION"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [NotificationHelper showAlert:@"LEAVE B REGION"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        if (state == CLRegionStateInside) {
            [NotificationHelper showAlert:@"B REGION INSIDE"];
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            
        } else if (state == CLRegionStateOutside) {
            [NotificationHelper showAlert:@"B REGION OUTSIDE"];
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            
        } else {
            [NotificationHelper showAlert:@"B REGION STATE UNKNOWN"];
        }
    }
}

#pragma mark -
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    [NotificationHelper showAlert:[NSString stringWithFormat:@"RANGING FAILED %@", error]];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, beacons);
    
    CLBeacon *beacon = beacons.firstObject;
    if (beacon.proximity != self.lastProximity) {
        self.lastProximity = beacon.proximity;
        switch (self.lastProximity) {
            case CLProximityFar:
                [NotificationHelper showAlert:@"FAR"];
                break;
            case CLProximityNear:
                [NotificationHelper showAlert:@"NEAR"];
                break;
            case CLProximityImmediate:
                [NotificationHelper showAlert:@"IMMEDIATE"];
                break;
            default:
                [NotificationHelper showAlert:@"PROXIMITY UNKNOWN"];
                break;
        }
    }
}


@end
