//
//  BlueprintEventHandling.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Score;
@class Gate;
@class Reward;
@class Mission;
@class World;
@class Level;

// Events
#define EVENT_BP_SCORE_RECORD_CHANGED           @"bp_score_record_changed"
#define EVENT_BP_GATE_OPENED                    @"bp_gate_opened"
#define EVENT_BP_GATE_CAN_BE_OPENED             @"bp_gate_can_be_opened"
#define EVENT_BP_REWARD_GIVEN                   @"bp_reward_given"
#define EVENT_BP_WORLD_COMPLETED                @"bp_world_completed"
#define EVENT_BP_MISSION_COMPLETED              @"bp_mission_completed"
#define EVENT_BP_LEVEL_STARTED                  @"bp_level_started"
#define EVENT_BP_LEVEL_ENDED                    @"bp_level_ended"

// UserInfo Elements
#define DICT_ELEMENT_SCORE                      @"score"
#define DICT_ELEMENT_GATE                       @"gate"
#define DICT_ELEMENT_REWARD                     @"reward"
#define DICT_ELEMENT_WORLD                      @"world"
#define DICT_ELEMENT_MISSION                    @"mission"
#define DICT_ELEMENT_LEVEL                      @"level"


@interface BlueprintEventHandling : NSObject

+ (void)postScoreRecordChanged:(Score *)score;
+ (void)postGateOpened:(Gate *)gate;
+ (void)postGateCanBeOpened:(Gate *)gate;
+ (void)postRewardGiven:(Reward *)reward;
+ (void)postMissionCompleted:(Mission *)mission;
+ (void)postWorldCompleted:(World *)world;
+ (void)postLevelStarted:(Level *)level;
+ (void)postLevelEnded:(Level *)level;

@end
