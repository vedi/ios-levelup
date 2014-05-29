//
//  Blueprint.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/22/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Blueprint.h"
#import "BPJSONConsts.h"
#import "Score.h"
#import "World.h"
#import "StoreUtils.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"

@implementation Blueprint

static NSString* TAG = @"SOOMLA Blueprint";


- (void)initializeWithInitialWorlds:(NSArray *)oInitialWorlds {
    NSDictionary* worlds = [NSMutableDictionary dictionary];
    for (World* world in initialWorlds) {
        [worlds setValue:world forKey:world.worldId];
    }
    initialWorlds = worlds;
    [self save];
}

- (void)save {
    NSString* key = [NSString stringWithFormat:@"%@model", BP_DB_KEY_PREFIX];
    NSString* value = [StoreUtils dictToJsonString:[self toDictionary]];
    LogDebug(TAG, ([NSString stringWithFormat:@"saving Blueprint to DB. json is: %@", value]));
    [[[StorageManager getInstance] keyValueStorage] setValue:value forKey:key];
}

- (Score*) getScoreWithScoreId:(NSString*)scoreId {
    return [self fetchScoreWithScoreId:scoreId fromWorlds:initialWorlds];
}

- (World*) getWorldWithWorldId:(NSString*)worldId {
    return [self fetchWorldWithWorldId:worldId andWorlds:initialWorlds];
}


// private

+ (Blueprint*)getInstance {
    static Blueprint* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[Blueprint alloc ] init];
        }
    }
    
    return _instance;
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
