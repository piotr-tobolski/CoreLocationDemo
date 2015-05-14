//
//  VisitMonitoringManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "VisitMonitoringManager.h"

@implementation VisitMonitoringManager

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
    [self.locationManager startMonitoringVisits];
    [StorageManager sharedInstance].visitMonitoringEnabled = YES;
}

- (void)stop {
    [self.locationManager stopMonitoringVisits];
    [StorageManager sharedInstance].visitMonitoringEnabled = NO;
}

- (BOOL)started {
    return [StorageManager sharedInstance].visitMonitoringEnabled;
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    Location *loc = [[Location alloc] init];
    loc.lat = visit.coordinate.latitude;
    loc.lon = visit.coordinate.longitude;
    if ([visit.departureDate isEqual:[NSDate distantFuture]]) {
        loc.name = @"VISIT ENTER";
        [NotificationHelper showAlert:[NSString stringWithFormat:@"VISIT ENTER %@", visit]];
    } else {
        loc.name = @"VISIT LEAVE";
        [NotificationHelper showAlert:[NSString stringWithFormat:@"VISIT LEAVE %@", visit]];
    }
    [[StorageManager sharedInstance] appendLocation:loc];
}

@end
