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

#import "GatesListOR.h"
#import "BPJSONConsts.h"


@implementation GatesListOR

static NSString* TYPE_NAME = @"listOR";

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:TYPE_NAME forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)isOpen {
    if (self.autoOpenBehavior) {
        for (Gate* gate in self.gates) {
            if (![gate isOpen]) {
                return YES;
            }
        }
        return NO;
    } else {
        return [super isOpen];
    }
}

- (BOOL)canOpen {
    for (Gate* gate in self.gates) {
        if ((self.childrenCanOpenIsEnough && [gate canOpen]) || [gate isOpen]) {
            return YES;
        }
    }
    return NO;
}

/**
 Override parent method to customize the ovserved notifications for `GatesListAND`
 */
- (void)observeNotifications {
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gateCanBeOpened:) name:EVENT_BP_GATE_CAN_BE_OPENED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gateOpened:) name:EVENT_BP_GATE_OPENED object:nil];
    }
}

// Private

/**
 If `canOpen` is defined as `YES` when all sub-gates `canOpen`
 use this subscription
 */
- (void)gateCanBeOpened:(NSNotification *)notification {
    
    Gate* gate = notification.userInfo[DICT_ELEMENT_GATE];
    
    if (!self.childrenCanOpenIsEnough || ![self.gates containsObject:gate]) {
        return; // handled by GateOpenedEvent
    }
    
    int openCounter = 0;
    for (Gate* gate in self.gates) {
        if ([gate canOpen]) {
            openCounter++;
        }
    }
    
    // post event only on first open sub-gate
    if (openCounter == 1) {
        [LevelUpEventHandling postGateCanBeOpened:self];
    }
    
};

/**
 If `canOpen` is defined as `YES` when all sub-gates `isOpen`
 use this subscription
 */
- (void)gateOpened:(NSNotification *)notification {
    
    Gate* gate = notification.userInfo[DICT_ELEMENT_GATE];
    
    if (self.childrenCanOpenIsEnough || ![self.gates containsObject:gate]) {
        return; // handled by GateOpenedEvent
    }
    
    int openCounter = 0;
    for (Gate* gate in self.gates) {
        if ([gate isOpen]) {
            openCounter++;
        }
    }
    
    if (openCounter == 1 && ![GateStorage isOpen:self]) {
        [LevelUpEventHandling postGateCanBeOpened:self];
    }
    
};

@end
