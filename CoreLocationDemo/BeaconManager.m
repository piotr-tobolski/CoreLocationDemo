//
//  BeaconManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 04.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "BeaconManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconLocationManager.h"

@interface BeaconManager () <CBPeripheralManagerDelegate>
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (nonatomic) BOOL shouldAdvertise;
@end


@implementation BeaconManager

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
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)startAdvertising {
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        self.shouldAdvertise = YES;
        
    } else {
        NSDictionary *peripheralData = [[BeaconLocationManager sharedInstance].beaconRegion peripheralDataWithMeasuredPower:nil];
        [self.peripheralManager startAdvertising:peripheralData];
        [NotificationHelper showAlert:@"STARTING ADVERTISING"];
    }
}

- (void)stopAdvertising {
    [self.peripheralManager stopAdvertising];
    self.shouldAdvertise = NO;
}

- (BOOL)advertisingEnabled {
    return (self.peripheralManager.isAdvertising || self.shouldAdvertise);
}

- (BOOL)advertisingAvailable {
    if (self.peripheralManager.state == CBPeripheralManagerStateUnknown ||
        self.peripheralManager.state == CBPeripheralManagerStateResetting ||
        self.peripheralManager.state == CBPeripheralManagerStatePoweredOff||
        self.peripheralManager.state == CBPeripheralManagerStateUnsupported) {
        return NO;
    }
    return YES;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, @(peripheral.state));
    if (peripheral.state == CBPeripheralManagerStatePoweredOn && self.shouldAdvertise) {
        self.shouldAdvertise = NO;
        [self startAdvertising];
    }
}

@end
