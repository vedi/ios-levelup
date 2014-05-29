//
//  World.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "World.h"
#import "Level.h"
#import "Challenge.h"
#import "Score.h"
#import "RangeScore.h"
#import "VirtualItemScore.h"
#import "GatesList.h"
#import "GatesListAND.h"
#import "GatesListOR.h"
#import "WorldStorage.h"
#import "BPJSONConsts.h"
#import "StoreUtils.h"

@implementation World

@synthesize worldId, gates, innerWorlds, scores, challenges;

static NSString* TAG = @"SOOMLA World";

- (id)initWithWorldId:(NSString *)oWorldId {
    if (self = [super init]) {
        worldId = oWorldId;
        gates = nil;
        innerWorlds = [NSMutableDictionary dictionary];
        scores = [NSMutableDictionary dictionary];
        challenges = [NSMutableArray array];
    }
    return self;
}

- (id)initWithWorldId:(NSString *)oWorldId andGates:(GatesList *)oGates
       andInnerWorlds:(NSDictionary *)oInnerWorlds andScores:(NSDictionary *)oScores andChallenges:(NSArray *)oChallenges {
    if (self = [super init]) {
        worldId = oWorldId;
        gates = oGates;
        innerWorlds = oInnerWorlds;
        scores = oScores;
        challenges = [NSMutableArray arrayWithArray:oChallenges];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        
        worldId = [dict objectForKey:BP_WORLD_WORLDID];
        
        NSMutableDictionary* tmpInnerWorlds = [NSMutableDictionary dictionary];
        NSArray* innerWorldDicts = [dict objectForKey:BP_WORLDS];
        
        // Iterate over all inner worlds in the JSON array and for each one create
        // an instance according to the world type
        for (NSDictionary* innerWorldDict in innerWorldDicts) {
            
            World* world;
            NSString* type = [innerWorldDict objectForKey:BP_TYPE];
            if ([type isEqualToString:@"world"]) {
                world = [[World alloc] initWithDictionary:innerWorldDict];
                [tmpInnerWorlds setValue:world forKey:world.worldId];
            } else if ([type isEqualToString:@"level"]) {
                world = [[Level alloc] initWithDictionary:innerWorldDict];
                [tmpInnerWorlds setValue:world forKey:world.worldId];
            } else {
                LogError(TAG, ([NSString stringWithFormat:@"Unknown world type: %@", type]));
            }
        }
        
        innerWorlds = tmpInnerWorlds;
        
        
        NSMutableDictionary* tmpScores = [NSMutableDictionary dictionary];
        NSArray* scoreDicts = [dict objectForKey:BP_SCORES];
        
        // Iterate over all scores in the JSON array and for each one create
        // an instance according to the score type
        for (NSDictionary* scoreDict in scoreDicts) {
            
            Score* score;
            NSString* type = [scoreDict objectForKey:BP_TYPE];
            if ([type isEqualToString:@"range"]) {
                score = [[RangeScore alloc] initWithDictionary:scoreDict];
                [tmpScores setValue:score forKey:score.scoreId];
            } else if ([type isEqualToString:@"item"]) {
                score = [[VirtualItemScore alloc] initWithDictionary:scoreDict];
                [tmpScores setValue:score forKey:score.scoreId];
            } else {
                LogError(TAG, ([NSString stringWithFormat:@"Unknown score type: %@", type]));
            }
        }

        scores = tmpScores;
        
        
        NSMutableArray* tmpChallenges = [NSMutableArray array];
        NSArray* challengeDicts = [dict objectForKey:BP_CHALLENGES];
        
        // Iterate over all challenges in the JSON array and create an instance for each one
        for (NSDictionary* challengeDict in challengeDicts) {
            [tmpChallenges addObject:[[Challenge alloc] initWithDictionary:challengeDict]];
        }
        
        challenges = tmpChallenges;

        
        NSDictionary* gateListDict = [dict objectForKey:BP_GATES];
        if (gateListDict) {
            NSString* type = [gateListDict objectForKey:BP_TYPE];
            if ([type isEqualToString:@"listOR"]) {
                gates = [[GatesListOR alloc] initWithDictionary:gateListDict];
            } else if ([type isEqualToString:@"listAND"]) {
                gates = [[GatesListAND alloc] initWithDictionary:dict];
            } else {
                LogError(TAG, ([NSString stringWithFormat:@"Unknown gate-list type: %@", type]));
                gates = nil;
            }
        } else {
            gates = nil;
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:self.worldId forKey:BP_WORLD_WORLDID];
    
    NSMutableArray* innerWorldsArr = [NSMutableArray array];
    for (NSString* innerWorldId in self.innerWorlds) {
        [innerWorldsArr addObject:[self.innerWorlds[innerWorldId] toDictionary]];
    }
    [dict setValue:innerWorldsArr forKey:BP_WORLDS];
    
    NSMutableArray* scoresArr = [NSMutableArray array];
    for (NSString* scoreId in self.scores) {
        [innerWorldsArr addObject:[self.scores[scoreId] toDictionary]];
    }
    [dict setValue:scoresArr forKey:BP_SCORES];
    
    NSMutableArray* challengesArr = [NSMutableArray array];
    for (Challenge* challenge in self.challenges) {
        [challengesArr addObject:[challenge toDictionary]];
    }
    [dict setValue:challengesArr forKey:BP_CHALLENGES];
    
    [dict setValue:self.gates.toDictionary forKey:BP_GATES];
    
    return dict;
}

- (void)addChallenge:(Challenge *)challenge {
    [self.challenges addObject:challenge];
}

- (NSDictionary *)getRecordScores {
    NSMutableDictionary* recordScores = [NSMutableDictionary dictionary];
    for (Score* score in self.scores) {
        [recordScores setValue:[NSNumber numberWithDouble:[score getRecord]] forKey:score.scoreId];
    }
    return recordScores;
}

- (NSDictionary *)getLatestScores {
    NSMutableDictionary* latestScores = [NSMutableDictionary dictionary];
    for (Score* score in self.scores) {
        [latestScores setValue:[NSNumber numberWithDouble:[score getLatest]] forKey:score.scoreId];
    }
    return latestScores;
}

- (void)setValue:(double)scoreVal toScoreWithScoreId:(NSString *)scoreId {
    Score* score = [self.scores objectForKey:scoreId];
    if (!score) {
        LogError(TAG, ([NSString stringWithFormat:@"(setScore) Can't find scoreId: %@  worldId: %@", scoreId, self.worldId]));
        return;
    }
    [score setTempScore:scoreVal];
}

- (void)addScore:(Score *)score {
    [self.scores setValue:score forKey:score.scoreId];
}

- (void)addGate:(Gate *)gate {
    if (!self.gates) {
        gates = [[GatesListAND alloc] initWithGateId:[[NSUUID UUID] UUIDString]];
    }
    [self.gates addGate:gate];
}

- (void)addInnerWorld:(World *)world {
    [self.innerWorlds setValue:world forKey:world.worldId];
}

- (BOOL)isCompleted {
    return [WorldStorage isWorldCompleted:self];
}

- (void)setCompleted:(BOOL)completed {
    [self setCompleted:completed recursively:NO];
}

- (void)setCompleted:(BOOL)completed recursively:(BOOL)recursive {
    
    if (recursive) {
        for (World* world in self.innerWorlds) {
            [world setCompleted:completed recursively:YES];
        }
    }
    [WorldStorage setCompleted:completed forWorld:self];
}

- (BOOL)canStart {
    return !self.gates || [self.gates isOpen];
}


@end
