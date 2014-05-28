//
//  GatesList.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "GatesList.h"
#import "BPJSONConsts.h"
#import "BalanceGate.h"
#import "GatesListAND.h"
#import "GatesListOR.h"
#import "RecordGate.h"
#import "PurchasableGate.h"
#import "WorldCompletionGate.h"
#import "StoreUtils.h"


// TODO: Document ABSTRACT class
@implementation GatesList

@synthesize gates;

static NSString* TAG = @"SOOMLA GatesList";

- (id)initWithGateId:(NSString *)oGateId {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray array];
    }
    return self;
}

- (id)initWithGateId:(NSString *)oGateId andSingleGate:(Gate *)oSingleGate {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray array];
        [self addGate:oSingleGate];
    }
    
    return self;
}

- (id)initWithGateId:(NSString *)oGateId andGates:(NSArray*)oGates {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray arrayWithArray:oGates];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.gates = [NSMutableArray array];
        
        NSMutableArray* tmpGates = [NSMutableArray array];
        NSArray* gateDicts = [dict objectForKey:BP_GATES];

        // Iterate over all gates in the JSON array and for each one create
        // an instance according to the gate type
        for (NSDictionary* gateDict in gateDicts) {
            
            NSString* type = [gateDict objectForKey:BP_TYPE];
            if ([type isEqualToString:@"balance"]) {
                [tmpGates addObject:[[BalanceGate alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"listAND"]) {
                [tmpGates addObject:[[GatesListAND alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"listOR"]) {
                [tmpGates addObject:[[GatesListOR alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"record"]) {
                [tmpGates addObject:[[RecordGate alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"purchasable"]) {
                [tmpGates addObject:[[PurchasableGate alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"worldCompletion"]) {
                [tmpGates addObject:[[WorldCompletionGate alloc] initWithDictionary:gateDict]];
            } else {
                LogError(TAG, ([NSString stringWithFormat:@"Unknown gate type: %@", type]));
            }
        }
        
        self.gates = tmpGates;
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableArray* gatesArr = [NSMutableArray array];
    for (Gate* gate in self.gates) {
        [gatesArr addObject:[gate toDictionary]];
    }
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:gates forKey:BP_GATES];
    
    return toReturn;
}

- (void)addGate:(Gate *)gate {
    [self.gates addObject:gate];
}

- (int)size {
    return (int)[self.gates count];
}


@end
