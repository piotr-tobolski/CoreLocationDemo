//
//  BeaconLocationManager.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 04.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "AbstractLocationManager.h"

@interface BeaconLocationManager : AbstractLocationManager

- (CLBeaconRegion *)beaconRegion;

@end
