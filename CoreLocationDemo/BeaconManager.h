//
//  BeaconManager.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 04.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconManager : NSObject

+ (instancetype)sharedInstance;

- (void)startAdvertising;
- (void)stopAdvertising;

- (BOOL)advertisingEnabled;
- (BOOL)advertisingAvailable;

@end
