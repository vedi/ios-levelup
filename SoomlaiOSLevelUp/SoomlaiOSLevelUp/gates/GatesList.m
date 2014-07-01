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
#import "GatesListAND.h"
#import "GatesListOR.h"
#import "DictionaryFactory.h"
#import "SoomlaUtils.h"
#import "LevelUpEventHandling.h"


// TODO: Document ABSTRACT class
@implementation GatesList

@synthesize gates;

static NSString* TAG = @"SOOMLA GatesList";
static DictionaryFactory* dictionaryFactory;
static NSDictionary* typeMap;

- (id)initWithGateId:(NSString *)oGateId {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray array];
        [self observeNotifications];
    }
    return self;
}

- (id)initWithGateId:(NSString *)oGateId andSingleGate:(Gate *)oSingleGate {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray array];
        [self addGate:oSingleGate];
        [self observeNotifications];
    }
    
    return self;
}

- (id)initWithGateId:(NSString *)oGateId andGates:(NSArray*)oGates {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray arrayWithArray:oGates];
        [self observeNotifications];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        NSMutableArray* tmpGates = [NSMutableArray array];
        NSArray* gateDicts = dict[BP_GATES];

        // Iterate over all gates in the JSON array and for each one create
        // an instance according to the gate type
        for (NSDictionary* gateDict in gateDicts) {
            
            Gate* gate = [Gate fromDictionary:gateDict];
            if (gate) {
                [tmpGates addObject:gate];
            }
        }
        
        self.gates = tmpGates;
        [self observeNotifications];
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
    [toReturn setObject:gatesArr forKey:BP_GATES];
    
    return toReturn;
}

- (void)addGate:(Gate *)gate {
    [self.gates addObject:gate];
}

- (int)size {
    return (int)[self.gates count];
}

- (BOOL)tryOpenInner {
    for (Gate* gate in self.gates) {
        [gate tryOpen];
    }
    return [self isOpen];
}

- (void)observeNotifications {
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gateOpened:) name:EVENT_BP_GATE_OPENED object:nil];
    }
}

- (void)stopObservingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gateOpened:(NSNotification *)notification {
    if ([self tryOpen]) {
        [self stopObservingNotifications];
    }
}



// Static methods

+ (GatesList *)fromDictionary:(NSDictionary *)dict {
    return (GatesList *)[dictionaryFactory createObjectWithDictionary:dict andTypeMap:typeMap];
}

+ (void)initialize {
    if (self == [GatesList self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
        typeMap = @{
                    [GatesListAND getTypeName]: [GatesListAND class],
                    [GatesListOR getTypeName] : [GatesListOR class]
                    };
    }
}


@end
