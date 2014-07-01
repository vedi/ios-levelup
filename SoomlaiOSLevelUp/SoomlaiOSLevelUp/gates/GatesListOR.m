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
    [toReturn setObject:TYPE_NAME forKey:LEVELUP_TYPE];
    
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
        if ([gate isOpen]) {
            return YES;
        }
    }
    return NO;
}

@end
