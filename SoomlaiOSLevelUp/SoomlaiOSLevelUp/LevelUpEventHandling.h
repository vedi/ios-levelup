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
#define EVENT_BP_REWARD_TAKEN                   @"bp_reward_taken"
#define EVENT_BP_MISSION_COMPLETED              @"bp_mission_completed"
#define EVENT_BP_MISSION_COMPLETION_REVOKED     @"bp_mission_completeion_revoked"
#define EVENT_BP_WORLD_COMPLETED                @"bp_world_completed"
#define EVENT_BP_LEVEL_STARTED                  @"bp_level_started"
#define EVENT_BP_LEVEL_ENDED                    @"bp_level_ended"

// UserInfo Elements
#define DICT_ELEMENT_SCORE                      @"score"
#define DICT_ELEMENT_GATE                       @"gate"
#define DICT_ELEMENT_REWARD                     @"reward"
#define DICT_ELEMENT_WORLD                      @"world"
#define DICT_ELEMENT_MISSION                    @"mission"
#define DICT_ELEMENT_LEVEL                      @"level"
#define DICT_ELEMENT_IS_CHALLENGE               @"isChallenge"
#define DICT_ELEMENT_IS_BADGE                   @"isBadge"


@interface LevelUpEventHandling : NSObject


+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector;

+ (void)postScoreRecordChanged:(Score *)score;

+ (void)postGateOpened:(Gate *)gate;

+ (void)postGateCanBeOpened:(Gate *)gate;

+ (void)postRewardGiven:(Reward *)reward;

+ (void)postRewardTaken:(Reward *)reward;

+ (void)postMissionCompleted:(Mission *)mission;

+ (void)postMissionCompletionRevoked:(Mission *)mission;

+ (void)postWorldCompleted:(World *)world;

+ (void)postLevelStarted:(Level *)level;

+ (void)postLevelEnded:(Level *)level;


@end
