//
//  WorldStorage.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/29/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "WorldStorage.h"
#import "World.h"
#import "Blueprint.h"
#import "BlueprintEventHandling.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"

@implementation WorldStorage

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world {
    [self setCompleted:completed forWorld:world andNotify:YES];
}

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world andNotify:(BOOL)notify {
    NSString* key = [self keyWorldCompletedWithWorldId:world.worldId];
    
    if (completed) {
        [[[StorageManager getInstance] keyValueStorage] setValue:@"yes" forKey:key];
        
        if (notify) {
            [BlueprintEventHandling postWorldCompleted:world];
        }
    } else {
        [[[StorageManager getInstance] keyValueStorage] deleteValueForKey:key];
    }
}

+ (BOOL)isWorldCompleted:(World *)world {
    NSString* key = [self keyWorldCompletedWithWorldId:world.worldId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0);
}


// Private
+ (NSString *)keyWorldsWithWorldId:(NSString *)worldId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@world.%@.%@", BP_DB_KEY_PREFIX, worldId, postfix];
}

+ (NSString *)keyWorldCompletedWithWorldId:(NSString *)worldId {
    return [self keyWorldsWithWorldId:worldId andPostfix:@"completed"];
}

@end
