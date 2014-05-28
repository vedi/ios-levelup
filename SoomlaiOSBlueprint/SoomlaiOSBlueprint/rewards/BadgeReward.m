//
//  BadgeReward.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "BadgeReward.h"
#import "BPJSONConsts.h"

@implementation BadgeReward

@synthesize iconUrl;


- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andIconUrl:(NSString *)oIconUrl {
    if (self = [super initWithRewardId:oRewardId andName:oName]) {
        self.iconUrl = oIconUrl;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.iconUrl = [dict objectForKey:BP_REWARD_ICONURL];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.iconUrl forKey:BP_REWARD_ICONURL];
    [toReturn setValue:@"badge" forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)giveInner {
    
    // nothing to do here... the parent Reward gives in storage
    return YES;
}


@end
