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

- (id)initWithId:(NSString *)oGateId {
    if (self = [super initWithId:oGateId]) {
        self.gates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithId:(NSString *)oGateId andSingleGate:(Gate *)oSingleGate {
    if (self = [super initWithId:oGateId]) {
        self.gates = [[NSMutableArray alloc] init];
        [self addGate:oSingleGate];
    }
    
    return self;
}

- (id)initWithId:(NSString *)oGateId andGates:(NSArray*)oGates {
    if (self = [super initWithId:oGateId]) {
        self.gates = [NSMutableArray arrayWithArray:oGates];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.gates = [[NSMutableArray alloc] init];
        NSArray* gateDicts = [dict objectForKey:BP_GATES];

        // Iterate over all gates in the JSON array and for each one create
        // an instance according to the gate type
        for (NSDictionary* gateDict in gateDicts) {
            
            NSString* type = [gateDict objectForKey:BP_TYPE];
            if ([type isEqualToString:@"balance"]) {
                [self addGate:[[BalanceGate alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"listAND"]) {
                [self addGate:[[GatesListAND alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"listOR"]) {
                [self addGate:[[GatesListOR alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"record"]) {
                [self addGate:[[RecordGate alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"purchasable"]) {
                [self addGate:[[PurchasableGate alloc] initWithDictionary:gateDict]];
            } else if ([type isEqualToString:@"worldCompletion"]) {
                [self addGate:[[WorldCompletionGate alloc] initWithDictionary:gateDict]];
            } else {
                LogError(TAG, ([NSString stringWithFormat:@"Unknown gate type: %@", type]));
            }
        }
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
