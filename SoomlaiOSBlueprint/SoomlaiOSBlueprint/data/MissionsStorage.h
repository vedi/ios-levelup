//
//  MissionsStorage.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Mission;

@interface MissionsStorage : NSObject

+ (void)setCompleted:(BOOL)completed forMission:(Mission *)mission;

+ (void)setCompleted:(BOOL)completed forMission:(Mission *)mission andNotify:(BOOL)notify;

+ (BOOL)isMissionCompleted:(Mission *)mission;

@end
