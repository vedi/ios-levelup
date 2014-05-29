//
//  BalanceGate.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "BalanceGate.h"
#import "BPJSONConsts.h"
#import "EventHandling.h"
#import "BlueprintEventHandling.h"
#import "GateStorage.h"
#import "StoreInventory.h"
#import "VirtualItemNotFoundException.h"
#import "StoreUtils.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"

@implementation BalanceGate

@synthesize associatedItemId, desiredBalance;
    
static NSString* TAG = @"SOOMLA BalanceGate";

- (id)initWithGateId:(NSString *)oGateId andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance {
    if (self = [super initWithGateId:oGateId]) {
        self.associatedItemId = oAssociatedItemId;
        self.desiredBalance = oDesiredBalance;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodBalanceChanged:) name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    }
   
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedItemId = [dict objectForKey:BP_ASSOCITEMID];
        self.desiredBalance = [[dict objectForKey:BP_DESIRED_BALANCE] intValue];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodBalanceChanged:) name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    }
    
    return self;
}


- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.associatedItemId forKey:BP_ASSOCITEMID];
    [toReturn setValue:[NSNumber numberWithInt:self.desiredBalance] forKey:BP_DESIRED_BALANCE];
    [toReturn setValue:@"balance" forKey:BP_TYPE];
    
    return toReturn;
}


- (BOOL)canPass {
    if ([GateStorage isOpen:self]) {
        return YES;
    }
    
    @try {
        if ([StoreInventory getItemBalance:self.associatedItemId] < self.desiredBalance) {
            return NO;
        }
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"(canPass) Couldn't find itemId. itemId: %@", self.associatedItemId]));
        return NO;
    }

    return YES;
}

- (void)tryOpenInner {
    
    if ([self canPass]) {
        @try {
            [StoreInventory takeAmount:self.desiredBalance ofItem:self.associatedItemId];
        }
        @catch (NSException *exception) {
            LogError(TAG, ([NSString stringWithFormat:@"(open) Couldn't find itemId. itemId: %@", self.associatedItemId]));
            return;
        }
        
        [self forceOpen:YES];
    }
}

- (void)currencyBalanceChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    VirtualCurrency* currency = [userInfo objectForKey:DICT_ELEMENT_CURRENCY];
    int balance = [[userInfo objectForKey:DICT_ELEMENT_BALANCE] intValue];

    [self checkBalance:balance forItemId:currency.itemId];
}

- (void)goodBalanceChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    VirtualGood* good = [userInfo objectForKey:DICT_ELEMENT_GOOD];
    int balance = [[userInfo objectForKey:DICT_ELEMENT_BALANCE] intValue];
    
    [self checkBalance:balance forItemId:good.itemId];
}


// Private

- (void)checkBalance:(int)balance forItemId:(NSString*)itemId {
    if ([itemId isEqualToString:self.associatedItemId] && balance >= self.desiredBalance) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [BlueprintEventHandling postGateCanBeOpened:self];
    }
}

@end
