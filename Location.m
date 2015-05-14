//
//  Location.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "Location.h"

@implementation Location

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:@(self.lat) forKey:@"lat"];
    [aCoder encodeObject:@(self.lon) forKey:@"lon"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _lat = [[aDecoder decodeObjectForKey:@"lat"] doubleValue];
        _lon = [[aDecoder decodeObjectForKey:@"lon"] doubleValue];
    }
    return self;
}

- (instancetype)initWithCLLocation:(CLLocation *)cllocation {
    if (self = [self init]) {
        self.lat = cllocation.coordinate.latitude;
        self.lon = cllocation.coordinate.longitude;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.lat, self.lon);
}

- (NSString *)title {
    return self.name;
}

@end
