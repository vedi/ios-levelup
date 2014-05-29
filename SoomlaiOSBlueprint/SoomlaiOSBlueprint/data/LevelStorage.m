//
//  LevelStorage.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/29/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "LevelStorage.h"
#import "Level.h"
#import "Blueprint.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"



@implementation LevelStorage


+ (void)setSlowestDuration:(double)duration forLevel:(Level *)level {
    NSString* key = [self keySlowestDurationWithLevelId:level.worldId];
    NSString* val = [[NSNumber numberWithDouble:duration] stringValue];
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
}

+ (double)getSlowestDurationForLevel:(Level *)level {
    NSString* key = [self keySlowestDurationWithLevelId:level.worldId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0) ? [val doubleValue] : DBL_MIN;
}

+ (void)setFastestDuration:(double)duration forLevel:(Level *)level {
    NSString* key = [self keyFastestDurationWithLevelId:level.worldId];
    NSString* val = [[NSNumber numberWithDouble:duration] stringValue];
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
}

+ (double)getFastestDurationforLevel:(Level *)level {
    NSString* key = [self keyFastestDurationWithLevelId:level.worldId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0) ? [val doubleValue] : DBL_MAX;
}

+ (int)incTimesStartedForLevel:(Level *)level {
    int started = [self getTimesStartedForLevel:level];
    if (started < 0) { /* can't be negative */
        started = 0;
    }
    started++;
    
    NSString* key = [self keyTimesStartedWithLevelId:level.worldId];
    NSString* val = [[NSNumber numberWithInt:started] stringValue];
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
    return started;
}

+ (int)decTimesStartedForLevel:(Level *)level {
    int started = [self getTimesStartedForLevel:level];
    if (started <= 0) { /* can't be negative or zero */
        return 0;
    }
    started--;
    
    NSString* key = [self keyTimesStartedWithLevelId:level.worldId];
    NSString* val = [[NSNumber numberWithInt:started] stringValue];
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
    return started;
}

+ (int)getTimesStartedForLevel:(Level *)level {
    NSString* key = [self keyTimesStartedWithLevelId:level.worldId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0) ? [val intValue] : 0;
}

+ (int)incTimesPlayedForLevel:(Level *)level {
    int played = [self getTimesPlayedForLevel:level];
    if (played < 0) { /* can't be negative */
        played = 0;
    }
    played++;
    
    NSString* key = [self keyTimesPlayedWithLevelId:level.worldId];
    NSString* val = [[NSNumber numberWithInt:played] stringValue];
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
    return played;
}

+ (int)decTimesPlayedForLevel:(Level *)level {
    int played = [self getTimesPlayedForLevel:level];
    if (played <= 0) { /* can't be negative or zero */
        return 0;
    }
    played--;
    
    NSString* key = [self keyTimesPlayedWithLevelId:level.worldId];
    NSString* val = [[NSNumber numberWithInt:played] stringValue];
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
    return played;
}

+ (int)getTimesPlayedForLevel:(Level *)level {
    NSString* key = [self keyTimesPlayedWithLevelId:level.worldId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0) ? [val intValue] : 0;
}


// Private

+ (NSString *)keyLevelsWithLevelId:(NSString *)levelId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@level.%@.%@", BP_DB_KEY_PREFIX, levelId, postfix];
}

+ (NSString *)keyTimesStartedWithLevelId:(NSString *)levelId {
    return [self keyLevelsWithLevelId:levelId andPostfix:@"started"];
}

+ (NSString *)keyTimesPlayedWithLevelId:(NSString *)levelId {
    return [self keyLevelsWithLevelId:levelId andPostfix:@"played"];
}

+ (NSString *)keySlowestDurationWithLevelId:(NSString *)levelId {
    return [self keyLevelsWithLevelId:levelId andPostfix:@"slowest"];
}

+ (NSString *)keyFastestDurationWithLevelId:(NSString *)levelId {
    return [self keyLevelsWithLevelId:levelId andPostfix:@"fastest"];
}


@end
