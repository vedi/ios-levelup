//
//  BalanceMission.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "BalanceMission.h"
#import "BPJSONConsts.h"
#import "EventHandling.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"


@implementation BalanceMission

@synthesize associatedItemId, desiredBalance;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
    andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance {
    
    if (self = [super initWithMissionId:oMissionId andName:oName]) {
        self.associatedItemId = oAssociatedItemId;
        self.desiredBalance = oDesiredBalance;
    }
    
    if (![self isCompleted]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodBalanceChanged:) name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    }
    
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
             andRewards:(NSArray *)oRewards andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance{
    
    if (self = [super initWithMissionId:oMissionId andName:oName andRewards:oRewards]) {
        self.associatedItemId = oAssociatedItemId;
        self.desiredBalance = oDesiredBalance;
    }
    
    if (![self isCompleted]) {
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
    
    if (![self isCompleted]) {
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



// Private Methods

- (void)checkBalance:(int)balance forItemId:(NSString*)itemId {
    if ([itemId isEqualToString:self.associatedItemId] && balance >= self.desiredBalance) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self setCompleted:YES];
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



@end
