//
//  BlueprintEventHandling.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "BlueprintEventHandling.h"

@implementation BlueprintEventHandling

+ (void)postScoreRecordChanged:(Score *)score {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:score forKey:DICT_ELEMENT_SCORE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BP_SCORE_RECORD_CHANGED object:self userInfo:userInfo];
}

@end
