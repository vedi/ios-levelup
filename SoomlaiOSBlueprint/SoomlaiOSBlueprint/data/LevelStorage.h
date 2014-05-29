//
//  LevelStorage.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/29/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Level;

@interface LevelStorage : NSObject

+ (void)setSlowestDuration:(double)duration forLevel:(Level *)level;

+ (double)getSlowestDurationForLevel:(Level *)level;

+ (void)setFastestDuration:(double)duration forLevel:(Level *)level;

+ (double)getFastestDurationforLevel:(Level *)level;

+ (int)incTimesStartedForLevel:(Level *)level;

+ (int)decTimesStartedForLevel:(Level *)level;

+ (int)getTimesStartedForLevel:(Level *)level;

+ (int)incTimesPlayedForLevel:(Level *)level;

+ (int)decTimesPlayedForLevel:(Level *)level;

+ (int)getTimesPlayedForLevel:(Level *)level;

@end
