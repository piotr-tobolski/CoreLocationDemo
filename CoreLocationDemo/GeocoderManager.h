//
//  GeocoderManager.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "StorageManager.h"
#import "NotificationHelper.h"

@interface GeocoderManager : NSObject

+ (instancetype)sharedInstance;

- (void)localSearch;
- (void)geocode;
- (void)reverseGeocode;

@end
