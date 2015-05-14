//
//  GeocoderManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "GeocoderManager.h"
#import <MapKit/MapKit.h>

@interface GeocoderManager ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation GeocoderManager

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
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)localSearch {
    NSLog(@"LOCAL SEARCH START");
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"BLStream szczecin";
    request.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(51.2649728, 22.5622065), MKCoordinateSpanMake(1, 1));
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSLog(@"LOCAL SEARCH FINISH\n mapItems: %@\nregion lat: %@ lon: %@ spanLat %@ spanLon: %@\nerror: %@", response.mapItems, @(response.boundingRegion.center.latitude), @(response.boundingRegion.center.longitude), @(response.boundingRegion.span.latitudeDelta), @(response.boundingRegion.span.longitudeDelta), error);
    }];
}

- (void)geocode {
    NSLog(@"GEOCODE START");
    [[[CLGeocoder alloc] init] geocodeAddressString:@"Plac Hołdu Pruskiego 9, Szczecin, Polska" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        NSLog(@"GEOCODE FINISH\ncount: %@\nfirst: %@\nerror: %@", @(placemarks.count), placemark.addressDictionary, error);
    }];
}

- (void)reverseGeocode {
    NSLog(@"REVERSE GEOCODE START");
    CLLocation *location = [[CLLocation alloc] initWithLatitude:51.2649728 longitude:22.5622065];
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        NSLog(@"GEOCODE FINISH\ncount: %@\nfirst: %@\nerror: %@", @(placemarks.count), placemark.addressDictionary, error);
    }];
}

@end
