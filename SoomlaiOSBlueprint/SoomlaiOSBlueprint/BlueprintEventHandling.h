//
//  BlueprintEventHandling.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Score;

// Events
#define EVENT_BP_SCORE_RECORD_CHANGED           @"bp_score_record_changed"

// UserInfo Elements
#define DICT_ELEMENT_SCORE                      @"score"


@interface BlueprintEventHandling : NSObject

+ (void)postScoreRecordChanged:(Score *)score;

@end
