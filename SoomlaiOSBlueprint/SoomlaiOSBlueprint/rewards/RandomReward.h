//
//  RandomReward.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Reward.h"

@interface RandomReward : Reward {
    
    @private
    NSMutableArray* rewards;
}

@property (strong, nonatomic) NSMutableArray* rewards;

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andRewards:(NSArray *)oRewards;

@end
