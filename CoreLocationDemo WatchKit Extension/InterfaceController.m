//
//  InterfaceController.m
//  CoreLocationDemo WatchKit Extension
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "InterfaceController.h"
#import "StorageManager.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *label;
@property (weak, nonatomic) IBOutlet WKInterfaceMap *map;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    Location *location = [StorageManager sharedInstance].locations.lastObject;
    [self.label setText:location.name];
    [self.map removeAllAnnotations];
    [self.map addAnnotation:location.coordinate withPinColor:WKInterfaceMapPinColorRed];
    MKMapPoint mapPoint = MKMapPointForCoordinate(location.coordinate);
    MKMapRect mapRect = MKMapRectMake(mapPoint.x, mapPoint.y, 0, 0);
    double span = MKMapPointsPerMeterAtLatitude(location.coordinate.latitude) * 50;
    [self.map setVisibleMapRect:MKMapRectInset(mapRect, -span, -span)];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



