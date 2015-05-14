//
//  ContinuousLocationManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "ContinuousLocationManager.h"

@interface ContinuousLocationManager ()
@property (nonatomic) BOOL started;
@end

@implementation ContinuousLocationManager

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
//        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
        
//        self.locationManager.distanceFilter = 100;
//        self.locationManager.desiredAccuracy = 1000;
        
//        self.locationManager.activityType = CLActivityTypeFitness;
//   self.locationManager.pausesLocationUpdatesAutomatically = YES;
    }
    return self;
}

- (void)start {
    [self.locationManager startUpdatingLocation];
    self.started = YES;
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
    self.started = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        Location *loc = [[Location alloc] initWithCLLocation:location];
        NSString *time = [NSDateFormatter localizedStringFromDate:location.timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        loc.name = [NSString stringWithFormat:@"C %@", time];
        [[StorageManager sharedInstance] appendLocation:loc];
        [NotificationHelper showAlert:[NSString stringWithFormat:@"CONTINUOUS %@", location]];
    }
    
[manager allowDeferredLocationUpdatesUntilTraveled:5000 timeout:60];
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    [NotificationHelper showAlert:@"LOCATIONS PAUSED"];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    [NotificationHelper showAlert:@"LOCATIONS RESUMED"];
}

@end
