//
//  PurchasableGate.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "PurchasableGate.h"
#import "BPJSONConsts.h"
#import "BlueprintEventHandling.h"
#import "EventHandling.h"
#import "PurchasableVirtualItem.h"
#import "PurchaseWithMarket.h"
#import "StoreController.h"
#import "StoreInfo.h"
#import "StoreUtils.h"
#import "VirtualItemNotFoundException.h"


@implementation PurchasableGate

@synthesize associatedItemId;

static NSString* TAG = @"SOOMLA PurchasableGate";

- (id)initWithId:(NSString *)oGateId andAssociatedItemId:(NSString *)oAssociatedItemId {
    if ([self initWithId:oGateId]) {
        self.associatedItemId = oAssociatedItemId;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(marketPurchased:) name:EVENT_MARKET_PURCHASED object:nil];
    }

    return self;
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedItemId = [dict objectForKey:BP_ASSOCITEMID];
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
    [toReturn setValue:@"purchasable" forKey:BP_TYPE];
    
    return toReturn;
}

- (void)tryOpenInner {
    
    @try {
        
        PurchasableVirtualItem* pvi = (PurchasableVirtualItem*)[[StoreInfo getInstance] virtualItemWithId:self.associatedItemId];
        PurchaseWithMarket* ptype = (PurchaseWithMarket*)[pvi purchaseType];
        
        // TODO: Change ios-store to accept custom payload string when buying with market item
        // For reference, in Android it is:
        //      StoreController.getInstance().buyWithMarket(ptype.getMarketItem(), getGateId());
        [[StoreController getInstance] buyInMarketWithMarketItem:ptype.marketItem];

    } @catch (VirtualItemNotFoundException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"The item needed for purchase doesn't exist. itemId: %@", self.associatedItemId]));
    } @catch (NSException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"The associated item is not a purchasable item. itemId: %@", self.associatedItemId]));
        @throw ex;
    }
}

// Private

- (void)marketPurchased:(NSNotification*)notification {

    NSDictionary* userInfo = notification.userInfo;
    
    // TODO: How to get the payload?
    // Java: if (marketPurchaseEvent.getPayload().equals(getGateId())) {
    NSString* gateId = [userInfo objectForKey:DICT_ELEMENT_GATE];
    
    if ([gateId isEqualToString:self.gateId]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self forceOpen:YES];
    }
}

@end
