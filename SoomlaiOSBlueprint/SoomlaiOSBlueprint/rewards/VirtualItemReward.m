//
//  VirtualItemReward.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/27/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "VirtualItemReward.h"
#import "VirtualItem.h"
#import "StoreInventory.h"
#import "BPJSONConsts.h"
#import "VirtualItemNotFoundException.h"
#import "StoreUtils.h"

@implementation VirtualItemReward

@synthesize associatedItemId, amount;

static NSString* TAG = @"SOOMLA VirtualItemReward";

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andAmount:(int)oAmount andAssociatedItemId:(NSString *)oAssociatedItemId {
    if (self = [super initWithRewardId:oRewardId andName:oName]) {
        self.amount = oAmount;
        self.associatedItemId = oAssociatedItemId;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.amount = [[dict objectForKey:BP_REWARD_AMOUNT] intValue];
        self.associatedItemId = [dict objectForKey:BP_ASSOCITEMID];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:[NSNumber numberWithInt:self.amount] forKey:BP_REWARD_AMOUNT];
    [toReturn setValue:self.associatedItemId forKey:BP_ASSOCITEMID];
    [toReturn setValue:@"item" forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)giveInner {
    @try {
        [StoreInventory giveAmount:self.amount ofItem:self.associatedItemId];
    }
    @catch (VirtualItemNotFoundException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"(give) Couldn't find associated itemId: %@", self.associatedItemId]));
        return NO;
    }
    
    return YES;
}

@end
