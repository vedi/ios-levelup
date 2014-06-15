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

#import "PurchasableGate.h"
#import "BPJSONConsts.h"
#import "LevelUpEventHandling.h"
#import "EventHandling.h"
#import "PurchasableVirtualItem.h"
#import "PurchaseWithMarket.h"
#import "StoreController.h"
#import "StoreInfo.h"
#import "StoreUtils.h"
#import "VirtualItemNotFoundException.h"


@implementation PurchasableGate

@synthesize associatedItemId;

static NSString* TYPE_NAME = @"purchasable";
static NSString* TAG = @"SOOMLA PurchasableGate";

- (id)initWithGateId:(NSString *)oGateId andAssociatedItemId:(NSString *)oAssociatedItemId {
    if (self = [super initWithGateId:oGateId]) {
        self.associatedItemId = oAssociatedItemId;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(marketPurchased:) name:EVENT_MARKET_PURCHASED object:nil];
    }

    return self;
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedItemId = dict[BP_ASSOCITEMID];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(marketPurchased:) name:EVENT_MARKET_PURCHASED object:nil];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.associatedItemId forKey:BP_ASSOCITEMID];
    [toReturn setValue:TYPE_NAME forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)tryOpenInner {
    
    @try {
        
        PurchasableVirtualItem* pvi = (PurchasableVirtualItem*)[[StoreInfo getInstance] virtualItemWithId:self.associatedItemId];
        PurchaseWithMarket* ptype = (PurchaseWithMarket*)[pvi purchaseType];
        
        // TODO: Change ios-store to accept custom payload string when buying with market item
        // For reference, in Android it is:
        //      StoreController.getInstance().buyWithMarket(ptype.getMarketItem(), getGateId());
        [[StoreController getInstance] buyInMarketWithMarketItem:ptype.marketItem];
        return YES;

    } @catch (VirtualItemNotFoundException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"The item needed for purchase doesn't exist. itemId: %@", self.associatedItemId]));
    } @catch (NSException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"The associated item is not a purchasable item. itemId: %@", self.associatedItemId]));
        @throw ex;
    }
    
    return NO;
}

- (BOOL)canOpen {
    return YES;
}

// Private

- (void)marketPurchased:(NSNotification*)notification {

    NSDictionary* userInfo = notification.userInfo;
    
    // TODO: How to get the payload?
    // Java: if (marketPurchaseEvent.getPayload().equals(getGateId())) {
    NSString* gateId = userInfo[DICT_ELEMENT_GATE];
    
    if ([gateId isEqualToString:self.gateId]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self forceOpen:YES];
    }
}

@end
