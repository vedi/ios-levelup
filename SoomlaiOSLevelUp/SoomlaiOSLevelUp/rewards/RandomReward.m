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

#import "RandomReward.h"
#import "LUJSONConsts.h"
#import "BadgeReward.h"
#import "VirtualItemReward.h"
#import "SoomlaUtils.h"

@implementation RandomReward

@synthesize rewards;

static NSString* TYPE_NAME = @"random";
static NSString* TAG = @"SOOMLA RandomReward";


- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andRewards:(NSArray *)oRewards {
    if (self = [super initWithRewardId:oRewardId andName:oName]) {
        
        if (![oRewards count]) {
            LogError(TAG, @"this reward doesn't make sense without items");
        }
        
        self.rewards = oRewards;
        self.repeatable = YES;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        NSMutableArray* tmpRewards = [NSMutableArray array];
        NSArray* rewardsArr = dict[LU_REWARDS];
        
        if (!rewardsArr) {
            LogDebug(TAG, @"reward has no meaning without children");
            rewardsArr = [NSMutableArray array];
        }
        
        // Iterate over all rewards in the JSON array and for each one create
        // an instance according to the reward type
        for (NSDictionary* rewardDict in rewardsArr) {
            
            Reward* reward = [Reward fromDictionary:rewardDict];
            if (reward) {
                [tmpRewards addObject:reward];
            }
        }
        
        self.rewards = tmpRewards;
    }
    self.repeatable = YES;
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableArray* rewardsArr = [NSMutableArray array];
    for (Reward* reward in self.rewards) {
        [rewardsArr addObject:[reward toDictionary]];
    }
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:rewardsArr forKey:LU_REWARDS];
    [toReturn setObject:TYPE_NAME forKey:LU_TYPE];
    
    return toReturn;
}

- (BOOL)giveInner {
    int i = arc4random() % [self.rewards count];
    
    Reward* randomReward = self.rewards[i];
    [randomReward give];
    lastGivenReward = randomReward;

    return true;
}


- (BOOL)takeInner {
    
    // for now is able to take only last given
    if(!lastGivenReward) {
        return NO;
    }
    
    BOOL taken = [lastGivenReward take];
    lastGivenReward = nil;
    
    return taken;
}





@end