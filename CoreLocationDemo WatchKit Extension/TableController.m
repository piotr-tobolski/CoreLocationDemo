//
//  TableController.m
//  CoreLocationDemo
//
//  Created by Piotr Tobolski on 05.05.2015.
//  Copyright (c) 2015 BLStream. All rights reserved.
//

#import "TableController.h"
#import "StorageManager.h"
#import "RowController.h"

@interface TableController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@end

@implementation TableController

- (void)willActivate {
    [super willActivate];
    [self reloadTable];
}

- (void)reloadTable {
    NSArray *messages = [StorageManager sharedInstance].messages;
    [self.table setNumberOfRows:messages.count withRowType:@"Row"];
    
    for (int i = 0; i < messages.count; i++) {
        RowController *row = [self.table rowControllerAtIndex:i];
        NSString *message = messages[i];
        [row.label setText:message];
    }
}

- (IBAction)clear {
    [StorageManager sharedInstance].messages = nil;
    [self reloadTable];
}

@end
