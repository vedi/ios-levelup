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

#import "WorldCompletionGate.h"
#import "World.h"
#import "LevelUp.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "LevelUpEventHandling.h"
#import "SoomlaUtils.h"

@implementation WorldCompletionGate

@synthesize associatedWorldId;


- (id)initWithGateId:(NSString *)oGateId andAssociatedWorldId:(NSString *)oAssociatedWorldId {
    if (self = [super initWithGateId:oGateId]) {
        self.associatedWorldId = oAssociatedWorldId;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldCompleted:) name:EVENT_WORLD_COMPLETED object:nil];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedWorldId = dict[LU_ASSOCWORLDID];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldCompleted:) name:EVENT_WORLD_COMPLETED object:nil];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:self.associatedWorldId forKey:LU_ASSOCWORLDID];
    
    return toReturn;
}

- (BOOL)canOpen {
    World* world = [[LevelUp getInstance] getWorldWithWorldId:self.associatedWorldId];
    return (world && [world isCompleted]);
}

- (BOOL)tryOpenInner {
    if ([self canOpen]) {
        [self forceOpen:YES];
        return YES;
    }
    return NO;
}

// Private

- (void)worldCompleted:(NSNotification *)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    World* world = userInfo[DICT_ELEMENT_WORLD];
    
    if ([world.worldId isEqualToString:self.associatedWorldId]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        // gate can now open
    }
};

@end
