//
//  Location.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <NSCoding, MKAnnotation>

@property (nonatomic) double lat;
@property (nonatomic) double lon;
@property (strong, nonatomic) NSString *name;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (instancetype)initWithCLLocation:(CLLocation *)cllocation;


@end
