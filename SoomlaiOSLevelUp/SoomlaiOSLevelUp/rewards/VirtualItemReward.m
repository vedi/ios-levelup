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
