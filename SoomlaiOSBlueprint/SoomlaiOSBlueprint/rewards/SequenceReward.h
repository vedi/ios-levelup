//
//  SequenceReward.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/27/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Reward.h"

@interface SequenceReward : Reward {
    
    @private
    NSArray* rewards;
}

@property (strong, nonatomic) NSArray* rewards;

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andRewards:(NSArray *)oRewards;

- (Reward *)getLastGivenReward;

- (BOOL)hasMoreToGive;

- (BOOL)forceGiveNextReward:(Reward *)reward;

@end
