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

#import "GatesListAND.h"
#import "GateStorage.h"
#import "BPJSONConsts.h"
#import "LevelUpEventHandling.h"


@implementation GatesListAND

static NSString* TYPE_NAME = @"listAND";

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
                return NO;
            }
        }
        return YES;
    } else {
        return [super isOpen];
    }
}

- (BOOL)canOpen {
    for (Gate* gate in self.gates) {
        if ((self.childrenCanOpenIsEnough && ![gate canOpen]) || ![gate isOpen]) {
            return NO;
        }
    }
    return YES;
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
    
    BOOL allCanOpen = YES;
    for (Gate* gate in self.gates) {
        if (![gate canOpen]) {
            allCanOpen = NO;
            break;
        }
    }
    
    if (allCanOpen) {
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
    
    BOOL allOpen = YES;
    for (Gate* gate in self.gates) {
        if (/*![gate isOpen]*/ ![GateStorage isOpen:gate]) {
            allOpen = NO;
            break;
        }
    }
    
    if (allOpen && ![GateStorage isOpen:self]) {
        [LevelUpEventHandling postGateCanBeOpened:self];
    }
    
};

@end
