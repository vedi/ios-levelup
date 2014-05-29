//
//  MissionStorage.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "MissionStorage.h"
#import "Mission.h"
#import "Blueprint.h"
#import "BlueprintEventHandling.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"

@implementation MissionStorage


+ (void)setCompleted:(BOOL)completed forMission:(Mission *)mission {
    [self setCompleted:completed forMission:mission andNotify:YES];
}

+ (void)setCompleted:(BOOL)completed forMission:(Mission *)mission andNotify:(BOOL)notify {
    
    NSString* key = [self keyMissionsCompletedWithMissionId:mission.missionId];
    
    if (completed) {
        [[[StorageManager getInstance] keyValueStorage] setValue:@"yes" forKey:key];
        
        if (notify) {
            [BlueprintEventHandling postMissionCompleted:mission];
        }
    } else {
        [[[StorageManager getInstance] keyValueStorage] deleteValueForKey:key];
    }
}

+ (BOOL)isMissionCompleted:(Mission *)mission {
    NSString* key = [self keyMissionsCompletedWithMissionId:mission.missionId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0);
}


// Private
+ (NSString *)keyMissionsWithMissionId:(NSString *)missionId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@missiona.%@.%@", BP_DB_KEY_PREFIX, missionId, postfix];
}

+ (NSString *)keyMissionsCompletedWithMissionId:(NSString *)missionId {
    return [self keyMissionsWithMissionId:missionId andPostfix:@"completed"];
}


@end
