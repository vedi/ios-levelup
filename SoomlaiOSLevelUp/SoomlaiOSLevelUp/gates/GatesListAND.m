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
#import "LUJSONConsts.h"


@implementation GatesListAND

static NSString* TYPE_NAME = @"listAND";

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:TYPE_NAME forKey:LU_TYPE];
    
    return toReturn;
}

- (BOOL)isOpen {

    // this flag is required since `World` / `Level`
    // actually creates a fake AND gate (list) even for a single gate
    // it means that it should answer `YES` when the (only) child subgate is open
    // without being required to open the (anonymous) AND parent
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
        if (![gate isOpen]) {
            return NO;
        }
    }
    return YES;
}

@end
