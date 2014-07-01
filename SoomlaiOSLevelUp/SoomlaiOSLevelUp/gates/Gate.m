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

#import "Gate.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "GateStorage.h"
#import "DictionaryFactory.h"
#import "BalanceGate.h"
#import "GatesListAND.h"
#import "GatesListOR.h"
#import "PurchasableGate.h"
#import "RecordGate.h"
#import "WorldCompletionGate.h"


@implementation Gate

@synthesize gateId;

static NSString* TYPE_NAME = @"gate";
static DictionaryFactory* dictionaryFactory;


- (id)initWithGateId:(NSString *)oGateId {
    self = [super init];
    if ([self class] == [Gate class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.gateId = oGateId;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([self class] == [Gate class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.gateId = dict[LU_GATE_GATEID];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            NSStringFromClass([self class]), SOOM_CLASSNAME,
            self.gateId, LU_GATE_GATEID,
            nil];
}

- (BOOL)tryOpen {
    if ([GateStorage isOpen:self]) {
        return YES;
    }
    
    return [self tryOpenInner];
}

- (void)forceOpen:(BOOL)open {
    [GateStorage setOpen:open forGate:self];
}

- (BOOL)isOpen {
    return [GateStorage isOpen:self];
}

// Abstract methods

- (BOOL)tryOpenInner {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)canOpen {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


// Static methods

+ (Gate *)fromDictionary:(NSDictionary *)dict {
    return (Gate *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (NSString *)getTypeName {
    return TYPE_NAME;
}


+ (void)initialize {
    if (self == [Gate self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}


@end
