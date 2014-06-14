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
    [toReturn setValue:gatesArr forKey:BP_GATES];
    
    return toReturn;
}

- (void)addGate:(Gate *)gate {
    [self.gates addObject:gate];
}

- (int)size {
    return (int)[self.gates count];
}


@end
