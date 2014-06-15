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

#import "LevelUp.h"
#import "BPJSONConsts.h"
#import "Score.h"
#import "World.h"
#import "StoreUtils.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"

@implementation LevelUp

static NSString* TAG = @"SOOMLA LevelUp";


- (void)initializeWithInitialWorlds:(NSArray *)oInitialWorlds {
    NSMutableDictionary* worlds = [NSMutableDictionary dictionary];
    for (World* world in initialWorlds) {
        [worlds setObject:world forKey:world.worldId];
    }
    initialWorlds = worlds;
    [self save];
}

- (Score*) getScoreWithScoreId:(NSString*)scoreId {
    return [self fetchScoreWithScoreId:scoreId fromWorlds:initialWorlds];
}

- (World*) getWorldWithWorldId:(NSString*)worldId {
    return [self fetchWorldWithWorldId:worldId andWorlds:initialWorlds];
}


// private

+ (LevelUp*)getInstance {
    static LevelUp* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[LevelUp alloc ] init];
        }
    }
    
    return _instance;
}

- (void)save {
    NSString* key = [NSString stringWithFormat:@"%@model", BP_DB_KEY_PREFIX];
    NSString* value = [StoreUtils dictToJsonString:[self toDictionary]];
    LogDebug(TAG, ([NSString stringWithFormat:@"saving LevelUp to DB. json is: %@", value]));
    [[[StorageManager getInstance] keyValueStorage] setValue:value forKey:key];
}

- (NSDictionary*)toDictionary {
    NSMutableArray* initialWorldsArr = [NSMutableArray array];
    for (NSString* worldId in initialWorlds) {
        [initialWorldsArr addObject:initialWorlds[worldId]];
    }
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            initialWorldsArr, BP_WORLDS,
            nil];
}

- (Score*)fetchScoreWithScoreId:(NSString *)scoreId fromWorlds:(NSDictionary *)worlds {
    Score* retScore = nil;
    for (NSString* worldId in worlds) {
        World* world = (World*)worlds[worldId];
        retScore = world.scores[scoreId];
        if (!retScore) {
            retScore = [self fetchScoreWithScoreId:scoreId fromWorlds:world.innerWorlds];
        }
        if (retScore) {
            break;
        }
    }
    
    return retScore;
}

- (World*)fetchWorldWithWorldId:(NSString *)worldId andWorlds:(NSDictionary *)worlds {
    World* retWorld = worlds[worldId];
    if (!retWorld) {
        for (NSString* worldId in worlds) {
            retWorld = [self fetchWorldWithWorldId:worldId andWorlds:((World*)worlds[worldId]).innerWorlds];
        }
    }
    
    return retWorld;
}

@end
