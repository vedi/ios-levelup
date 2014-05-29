//
//  World.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Challenge;
@class Gate;
@class GatesList;
@class Score;

@interface World : NSObject {
    
    @private
    NSString* worldId;
    GatesList* gates;
    NSDictionary* innerWorlds;
    NSDictionary* scores;
    NSMutableArray* challenges;
}

@property (strong, nonatomic, readonly) NSString* worldId;
@property (strong, nonatomic, readonly) GatesList* gates;
@property (strong, nonatomic, readonly) NSDictionary* innerWorlds;
@property (strong, nonatomic, readonly) NSDictionary* scores;
@property (strong, nonatomic, readonly) NSMutableArray* challenges;


- (id)initWithWorldId:(NSString *)oWorldId;

- (id)initWithWorldId:(NSString *)oWorldId andGates:(GatesList *)oGates
     andInnerWorlds:(NSDictionary *)oInnerWorlds andScores:(NSDictionary *)oScores andChallenges:(NSArray *)oChallenges;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (void)addChallenge:(Challenge *)challenge;

- (NSDictionary *)getRecordScores;

- (NSDictionary *)getLatestScores;

- (void)setValue:(double)scoreVal toScoreWithScoreId:(NSString *)scoreId;

- (void)addScore:(Score *)score;

- (void)addGate:(Gate *)gate;

- (void)addInnerWorld:(World *)world;

- (BOOL)isCompleted;

- (void)setCompleted:(BOOL)completed;

- (void)setCompleted:(BOOL)completed recursively:(BOOL)recursive;

- (BOOL)canStart;

@end
