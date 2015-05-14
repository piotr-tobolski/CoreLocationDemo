//
//  StorageManager.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 03.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "StorageManager.h"

@interface StorageManager ()
@property (strong, nonatomic) NSUserDefaults *defaults;
@end


@implementation StorageManager

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
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.applewatch.blstream"];
    }
    return self;
}

- (NSArray *)locations {
    NSData *data = [self.defaults objectForKey:@"locations"];
    if (data == nil) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setLocations:(NSArray *)locations {
    [self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:locations] forKey:@"locations"];
    [self.defaults synchronize];
}

- (void)appendLocation:(Location *)location {
    NSMutableArray *array = self.locations.mutableCopy;
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:location];
    self.locations = array;
}

- (NSArray *)messages {
    NSData *data = [self.defaults objectForKey:@"messages"];
    if (data == nil) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setMessages:(NSArray *)messages {
    [self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:messages] forKey:@"messages"];
    [self.defaults synchronize];
}

- (void)appendMessage:(NSString *)message {
    NSMutableArray *array = self.messages.mutableCopy;
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:message];
    self.messages = array;
}

- (BOOL)significantMonitoringEnabled {
    return [[self.defaults objectForKey:@"significant"] boolValue];
}

- (void)setSignificantMonitoringEnabled:(BOOL)significantMonitoringEnabled {
    [self.defaults setObject:@(significantMonitoringEnabled) forKey:@"significant"];
}

- (BOOL)visitMonitoringEnabled {
    return [[self.defaults objectForKey:@"visit"] boolValue];
}

- (void)setVisitMonitoringEnabled:(BOOL)visitMonitoringEnabled {
    [self.defaults setObject:@(visitMonitoringEnabled) forKey:@"visit"];
}

@end
