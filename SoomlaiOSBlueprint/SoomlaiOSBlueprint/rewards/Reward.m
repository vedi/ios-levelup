//
//  Reward.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Reward.h"
#import "BPJSONConsts.h"
#import "RewardStorage.h"

@implementation Reward

@synthesize rewardId, name;

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName {
    self = [super init];
    if ([self class] == [Reward class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.rewardId = oRewardId;
        self.name = oName;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([self class] == [Reward class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.rewardId = [dict objectForKey:BP_REWARD_REWARDID];
        self.name = [dict objectForKey:BP_NAME];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.rewardId, BP_REWARD_REWARDID,
            self.name, BP_NAME,
            nil];
}

- (void)give {
    if ([self giveInner]) {
        [RewardStorage setStatus:YES forReward:self];
    }
}

- (void)take {
    [RewardStorage setStatus:NO forReward:self];
}

- (BOOL)isOwned {
    return [RewardStorage isRewardGiven:self];
}

- (BOOL)giveInner {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}



@end
