//
//  StorageManager.h
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface StorageManager : NSObject

+ (instancetype)sharedInstance;


@property (strong, nonatomic) NSArray *locations;
- (void)appendLocation:(Location *)location;

@property (strong, nonatomic) NSArray *messages;
- (void)appendMessage:(NSString *)message;

@property (nonatomic) BOOL significantMonitoringEnabled;
@property (nonatomic) BOOL visitMonitoringEnabled;

@end
