//
//  RewardsStorage.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reward;

@interface RewardsStorage : NSObject

+ (void)setStatus:(BOOL)status forReward:(Reward *)reward;

+ (void)setStatus:(BOOL)status forReward:(Reward *)reward andNotify:(BOOL)notift;

+ (BOOL)isRewardGiven:(Reward *)reward;

+ (int)getLastSeqIdxGivenForReward:(Reward *)reward;

+ (void)setLastSeqIdxGiven:(int)idx ForReward:(Reward *)reward;

@end