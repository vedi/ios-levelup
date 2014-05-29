/*
 Copyright (C) 2012-2014 Soomla Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "Mission.h"
#import "MissionStorage.h"
#import "Reward.h"
#import "BadgeReward.h"
#import "RandomReward.h"
#import "VirtualItemReward.h"
#import "BPJSONConsts.h"

// TODO: Replace StoreUtils imports with a private instance of LogDebug macro (???)
#import "StoreUtils.h"

@implementation Mission

@synthesize missionId, name, rewards;

static NSString* TAG = @"SOOMLA Mission";


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName {
    self = [super init];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }

    if (self) {
        self.missionId = oMissionId;
        self.name = oName;
    }
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andRewards:(NSArray *)oRewards {
    self = [super init];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.missionId = oMissionId;
        self.name = oName;
        self.rewards = oRewards;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        
        NSMutableArray* tmpRewards = [NSMutableArray array];
        NSArray* rewardDicts = [dict objectForKey:BP_REWARDS];
        
        // Iterate over all rewards in the JSON array and for each one create
        // an instance according to the reward type
        for (NSDictionary* rewardDict in rewardDicts) {
            
            NSString* type = [rewardDict objectForKey:BP_TYPE];
            if ([type isEqualToString:@"badge"]) {
                [tmpRewards addObject:[[BadgeReward alloc] initWithDictionary:rewardDict]];
            } else if ([type isEqualToString:@"item"]) {
                [tmpRewards addObject:[[VirtualItemReward alloc] initWithDictionary:rewardDict]];
            } else if ([type isEqualToString:@"random"]) {
                [tmpRewards addObject:[[RandomReward alloc] initWithDictionary:rewardDict]];
            } else {
                LogError(TAG, ([NSString stringWithFormat:@"Unknown reward type: %@", type]));
            }
        }
        
        self.rewards = tmpRewards;
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary* dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          self.missionId, BP_MISSION_MISSIONID,
                          self.name, BP_NAME,
                          nil];
    
    NSMutableArray* rewardsArr = [NSMutableArray array];
    for (Reward* reward in self.rewards) {
        [rewardsArr addObject:[reward toDictionary]];
    }
    [dict setValue:rewardsArr forKey:BP_REWARDS];
    
    return dict;
}

- (BOOL)isCompleted {
    return [MissionStorage isMissionCompleted:self];
}

- (void)setCompleted:(BOOL)completed {
    [MissionStorage setCompleted:completed forMission:self];
    if (completed) {
        for (Reward* reward in self.rewards) {
            [reward give];
        }
    }
}

- (BOOL)isEqualToMission:(Mission *)mission {
    if (!mission) {
        return NO;
    }
    
    return [self.missionId isEqualToString:mission.missionId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Mission class]]) {
        return NO;
    }
    
    return [self isEqualToMission:(Mission *)object];
}

- (NSUInteger)hash {
    return [self.missionId hash];
}


@end
