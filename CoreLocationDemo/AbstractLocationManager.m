//
//  AbstractLocationManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "AbstractLocationManager.h"

@implementation AbstractLocationManager

+ (instancetype)sharedInstance {
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        NSLog(@"Created instance of class: %@, _locationManager.location: %@", NSStringFromClass([self class]), _locationManager.location);
    }
    return self;
}

- (void)start {
    
}

- (void)stop {
    
}

- (BOOL)started {
    return NO;
}

- (BOOL)available {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    return NO;
}

#pragma mark -
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@ fail with error: %@", NSStringFromClass([self class]), error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%@ authorization status: %@", NSStringFromClass([self class]), @(status));
}

@end
