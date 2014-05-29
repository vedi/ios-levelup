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
#import "Blueprint.h"
#import "BPJSONConsts.h"
#import "BlueprintEventHandling.h"
#import "StoreUtils.h"

@implementation WorldCompletionGate

@synthesize associatedWorldId;

- (id)initWithGateId:(NSString *)oGateId andAssociatedWorldId:(NSString *)oAssociatedWorldId {
    if ([self initWithGateId:oGateId]) {
        self.associatedWorldId = oAssociatedWorldId;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldCompleted:) name:EVENT_BP_WORLD_COMPLETED object:nil];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedWorldId = [dict objectForKey:BP_ASSOCWORLDID];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldCompleted:) name:EVENT_BP_WORLD_COMPLETED object:nil];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.associatedWorldId forKey:BP_ASSOCWORLDID];
    [toReturn setValue:@"worldCompletion" forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)canPass {
    World* world = [[Blueprint getInstance] getWorldWithWorldId:self.associatedWorldId];
    return (world && [world isCompleted]);
}

- (void)tryOpenInner {
    if ([self canPass]) {
        [self forceOpen:YES];
    }
}

// Private

- (void)worldCompleted:(NSNotification *)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    World* world = [userInfo objectForKey:DICT_ELEMENT_WORLD];
    
    if ([world.worldId isEqualToString:self.associatedWorldId]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [BlueprintEventHandling postGateCanBeOpened:self];
    }
};

@end
