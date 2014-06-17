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

#import "BalanceGate.h"
#import "BPJSONConsts.h"
#import "StoreEventHandling.h"
#import "LevelUpEventHandling.h"
#import "GateStorage.h"
#import "StoreInventory.h"
#import "VirtualItemNotFoundException.h"
#import "SoomlaUtils.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"

@implementation BalanceGate

@synthesize associatedItemId, desiredBalance;
    
static NSString* TYPE_NAME = @"balance";
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
        self.associatedItemId = dict[BP_ASSOCITEMID];
        self.desiredBalance = [dict[BP_DESIRED_BALANCE] intValue];
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
    [toReturn setObject:self.associatedItemId forKey:BP_ASSOCITEMID];
    [toReturn setObject:[NSNumber numberWithInt:self.desiredBalance] forKey:BP_DESIRED_BALANCE];
    [toReturn setObject:TYPE_NAME forKey:BP_TYPE];
    
    return toReturn;
}


- (BOOL)canOpen {
    if ([GateStorage isOpen:self]) {
        return YES;
    }
    
    @try {
        if ([StoreInventory getItemBalance:self.associatedItemId] < self.desiredBalance) {
            return NO;
        }
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"(canOpen) Couldn't find itemId. itemId: %@", self.associatedItemId]));
        return NO;
    }

    return YES;
}

- (BOOL)tryOpenInner {
    
    if ([self canOpen]) {
        @try {
            [StoreInventory takeAmount:self.desiredBalance ofItem:self.associatedItemId];
        }
        @catch (NSException *exception) {
            LogError(TAG, ([NSString stringWithFormat:@"(open) Couldn't find itemId. itemId: %@", self.associatedItemId]));
            return NO;
        }
        
        [self forceOpen:YES];
        return YES;
    }

    return NO;
}

- (void)currencyBalanceChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    VirtualCurrency* currency = userInfo[DICT_ELEMENT_CURRENCY];
    int balance = [userInfo[DICT_ELEMENT_BALANCE] intValue];

    [self checkBalance:balance forItemId:currency.itemId];
}

- (void)goodBalanceChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    VirtualGood* good = userInfo[DICT_ELEMENT_GOOD];
    int balance = [userInfo[DICT_ELEMENT_BALANCE] intValue];
    
    [self checkBalance:balance forItemId:good.itemId];
}


// Private

- (void)checkBalance:(int)balance forItemId:(NSString*)itemId {
    if ([itemId isEqualToString:self.associatedItemId] && balance >= self.desiredBalance) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [LevelUpEventHandling postGateCanBeOpened:self];
    }
}

@end
