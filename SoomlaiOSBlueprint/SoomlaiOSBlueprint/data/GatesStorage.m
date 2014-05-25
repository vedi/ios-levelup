//
//  GatesStorage.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "GatesStorage.h"
#import "Blueprint.h"
#import "Gate.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"
#import "BlueprintEventHandling.h"


@implementation GatesStorage


+ (void)setOpen:(Gate*)gate withFlag:(BOOL)open {
    [self setOpen:gate withFlag:open];
}

+ (void)setOpen:(Gate*)gate withFlag:(BOOL)open andEvent:(BOOL)notify {
    NSString* key = [self keyGatesWithGateId:gate.gateId];
    
    if (open) {
        [[[StorageManager getInstance] keyValueStorage] setValue:@"yes" forKey:key];
        
        if (notify) {
            [BlueprintEventHandling postGateOpened:gate];
        }
    } else {
        [[[StorageManager getInstance] keyValueStorage] deleteValueForKey:key];
    }
}

+ (BOOL)isOpen:(Gate*)gate {
    NSString* key = [self keyGatesWithGateId:gate.gateId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0);
}



+ (NSString*)keyGatesWithGateId:(NSString*)gateId andPostfix:(NSString*)postfix {
    return [NSString stringWithFormat: @"%@gates.%@.%@", BP_DB_KEY_PREFIX, gateId, postfix];
}

+ (NSString*)keyGatesWithGateId:(NSString*)gateId {
    return [self keyGatesWithGateId:gateId andPostfix:@"open"];
}

@end
