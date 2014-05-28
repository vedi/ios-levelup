//
//  BadgeReward.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Reward.h"

@interface BadgeReward : Reward {
    
    @private
    NSString* iconUrl;
}

@property (strong, nonatomic) NSString* iconUrl;


- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andIconUrl:(NSString *)oIconUrl;

@end
