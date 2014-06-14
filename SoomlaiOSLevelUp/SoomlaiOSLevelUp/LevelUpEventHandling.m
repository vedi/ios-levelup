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

#import "LevelUpEventHandling.h"
#import "Challenge.h"
#import "BadgeReward.h"

@implementation LevelUpEventHandling

+ (void)postScoreRecordChanged:(Score *)score {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:score forKey:DICT_ELEMENT_SCORE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_SCORE_RECORD_CHANGED object:self userInfo:userInfo];
}

+ (void)postGateOpened:(Gate *)gate {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:gate forKey:DICT_ELEMENT_GATE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_GATE_OPENED object:self userInfo:userInfo];
}

+ (void)postRewardGiven:(Reward *)reward {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              reward, DICT_ELEMENT_REWARD,
                              [reward isKindOfClass:[BadgeReward class]], DICT_ELEMENT_IS_BADGE,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_REWARD_GIVEN object:self userInfo:userInfo];
}

+ (void)postGateCanBeOpened:(Gate *)gate {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:gate forKey:DICT_ELEMENT_GATE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_GATE_CAN_BE_OPENED object:self userInfo:userInfo];
}

+ (void)postMissionCompleted:(Mission *)mission {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              mission, DICT_ELEMENT_MISSION,
                              [mission isKindOfClass:[Challenge class]], DICT_ELEMENT_IS_CHALLENGE,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_MISSION_COMPLETED object:self userInfo:userInfo];
}

+ (void)postWorldCompleted:(Mission *)world {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:world forKey:DICT_ELEMENT_WORLD];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_WORLD_COMPLETED object:self userInfo:userInfo];
}

+ (void)postLevelStarted:(Level *)level {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:level forKey:DICT_ELEMENT_LEVEL];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_LEVEL_STARTED object:self userInfo:userInfo];
}

+ (void)postLevelEnded:(Level *)level {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:level forKey:DICT_ELEMENT_LEVEL];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_LEVEL_ENDED object:self userInfo:userInfo];
}

@end
