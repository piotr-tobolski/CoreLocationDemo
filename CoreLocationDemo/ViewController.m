//
//  ViewController.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "StorageManager.h"

#import "ContinuousLocationManager.h"
#import "RegionLocationManager.h"
#import "SignificantLocationManager.h"
#import "VisitMonitoringManager.h"
#import "GeocoderManager.h"
#import "BeaconLocationManager.h"
#import "BeaconManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastLocLabel;

@property (weak, nonatomic) IBOutlet UISwitch *continuousSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *significantSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *regionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *visitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bRegionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *beaconSwitch;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self refreshTouchUpInside:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NotificationHelperNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.alertLabel.text = note.userInfo[NotificationHelperNotificationMessageKey];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[GeocoderManager sharedInstance] localSearch];
    [[GeocoderManager sharedInstance] geocode];
    [[GeocoderManager sharedInstance] reverseGeocode];
    
    [self refreshTouchUpInside:nil];
}

- (IBAction)refreshTouchUpInside:(id)sender {
    self.alertLabel.text = [StorageManager sharedInstance].messages.lastObject;

    //refresh switches
    self.continuousSwitch.on = [ContinuousLocationManager sharedInstance].started;
    self.significantSwitch.on = [SignificantLocationManager sharedInstance].started;
    self.visitSwitch.on = [VisitMonitoringManager sharedInstance].started;
    self.regionSwitch.on = [RegionLocationManager sharedInstance].started;
    self.bRegionSwitch.on = [BeaconLocationManager sharedInstance].started;
    self.beaconSwitch.on = [BeaconManager sharedInstance].advertisingEnabled;
    
    self.continuousSwitch.enabled = [ContinuousLocationManager sharedInstance].available;
    self.significantSwitch.enabled = [SignificantLocationManager sharedInstance].available;
    self.visitSwitch.enabled = [VisitMonitoringManager sharedInstance].available;
    self.regionSwitch.enabled = [RegionLocationManager sharedInstance].available;
    self.bRegionSwitch.enabled = [BeaconLocationManager sharedInstance].available;
    self.beaconSwitch.enabled = [BeaconManager sharedInstance].advertisingAvailable;
    
    //refresh map
    NSArray *locations = [StorageManager sharedInstance].locations;
    Location *lastLocation = locations.lastObject;
    [self.lastLocLabel setText:(lastLocation.name ? : @"none")];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:locations];
    MKMapPoint mapPoint = MKMapPointForCoordinate(lastLocation.coordinate);
    MKMapRect mapRect = MKMapRectMake(mapPoint.x, mapPoint.y, 0, 0);
    double span = MKMapPointsPerMeterAtLatitude(lastLocation.coordinate.latitude) * 50;
    [self.mapView setVisibleMapRect:MKMapRectInset(mapRect, -span, -span) animated:(sender != nil)];
    
}

- (IBAction)clearTouchUpInside:(id)sender {
    [StorageManager sharedInstance].locations = @[];
    [self refreshTouchUpInside:nil];
}

- (IBAction)inUseTouchUpInside:(id)sender {
    static CLLocationManager *locationManager = nil;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        locationManager = nil;
    });
}

- (IBAction)alwaysTouchUpInside:(id)sender {
    static CLLocationManager *locationManager = nil;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        locationManager = nil;
    });
}

- (IBAction)settingsTouchUpInside:(id)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)continuousValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[ContinuousLocationManager sharedInstance] start];
    } else {
        [[ContinuousLocationManager sharedInstance] stop];
    }
}

- (IBAction)significantValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[SignificantLocationManager sharedInstance] start];
    } else {
        [[SignificantLocationManager sharedInstance] stop];
    }
}

- (IBAction)regionValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[RegionLocationManager sharedInstance] start];
    } else {
        [[RegionLocationManager sharedInstance] stop];
    }
}

- (IBAction)visitValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[VisitMonitoringManager sharedInstance] start];
    } else {
        [[VisitMonitoringManager sharedInstance] stop];
    }
}

- (IBAction)bRegionValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[BeaconLocationManager sharedInstance] start];
    } else {
        [[BeaconLocationManager sharedInstance] stop];
    }
}

- (IBAction)beaconValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[BeaconManager sharedInstance] startAdvertising];
    } else {
        [[BeaconManager sharedInstance] stopAdvertising];
    }
}




@end
