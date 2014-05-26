//
//  BlueprintEventHandling.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Score;
@class Gate;

// Events
#define EVENT_BP_SCORE_RECORD_CHANGED           @"bp_score_record_changed"
#define EVENT_BP_GATE_OPENED                    @"bp_gate_opened"
#define EVENT_BP_GATE_CAN_BE_OPENED             @"bp_gate_can_be_opened"
#define EVENT_BP_WORLD_COMPLETED                @"bp_world_completed"

// UserInfo Elements
#define DICT_ELEMENT_SCORE                      @"score"
#define DICT_ELEMENT_GATE                       @"gate"
#define DICT_ELEMENT_WORLD                      @"world"


@interface BlueprintEventHandling : NSObject

+ (void)postScoreRecordChanged:(Score *)score;
+ (void)postGateOpened:(Gate *)gate;
+ (void)postGateCanBeOpened:(Gate *)gate;

@end
