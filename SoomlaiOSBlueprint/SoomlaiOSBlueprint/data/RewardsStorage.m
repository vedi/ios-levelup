//
//  RewardsStorage.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "RewardsStorage.h"
#import "Blueprint.h"
#import "BlueprintEventHandling.h"

@implementation RewardsStorage


+ (void)setStatus:(BOOL)status forReward:(Reward *)reward {
    [self setStatus:status forReward:reward andNotify:YES];
}

+ (void)setStatus:(BOOL)status forReward:(Reward *)reward andNotify:(BOOL)notift {
    NSString* key = [self keyRewardGivenWithRewardId:reward.rewardId];
    
    if (status) {
        [[[StorageManager getInstance] keyValueStorage] setValue:@"yes" forKey:key];
        
        if (notify) {
            [BlueprintEventHandling postRewardGiven:reward];
        }
    } else {
        [[[StorageManager getInstance] keyValueStorage] deleteValueForKey:key];
    }
}

+ (BOOL)isRewardGiven:(Reward *)reward {
    NSString* key = [self keyRewardGivenWithRewardId:reward.rewardId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    return (val && [val length] > 0);
}

+ (int)getLastSeqIdxGivenForReward:(Reward *)reward {
    NSString* key = [self keyRewardIdxSeqGivenWithRewardId:reward.rewardId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    
    if (!val || [val length] == 0){
        return -1;
    }
    
    return [val intValue];
}

+ (void)setLastSeqIdxGiven:(int)idx ForReward:(Reward *)reward {
    NSString* key = [self keyRewardIdxSeqGivenWithRewardId:reward.rewardId];
    NSString* val = [[NSNumber numberWithInt:idx] stringValue];
    
    [[[StorageManager getInstance] keyValueStorage] setValue:val forKey:key];
}


// Private

+ (NSString *)keyRewardsWithRewardId:(NSString *)rewardId AndPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@rewards.%@.%@", BP_DB_KEY_PREFIX, rewardId, postfix];
}

+ (NSString *)keyRewardGivenWithRewardId:(NSString *)rewardId {
    return [self keyRewardGivenWithRewardId:rewardId AndPostfix:@"given"];
}

+ (NSString *)keyRewardIdxSeqGivenWithRewardId:(NSString *)rewardId {
    return [self keyRewardGivenWithRewardId:rewardId AndPostfix:@"seq.idx"];
}


@end
