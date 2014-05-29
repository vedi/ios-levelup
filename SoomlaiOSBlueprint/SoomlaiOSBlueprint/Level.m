//
//  Level.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/29/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Level.h"
#import "LevelStorage.h"
#import "Score.h"
#import "BPJSONConsts.h"
#import "BlueprintEventHandling.h"
#import "VirtualItemScore.h"
#import "VirtualItemNotFoundException.h"
#import "StoreInventory.h"
#import "StoreUtils.h"


@implementation Level

@synthesize startTime;

static NSString* TAG = @"SOOMLA Level";


- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:@"level" forKey:BP_TYPE];
    
    return toReturn;
}

    
- (int)getTimesStarted {
    return [LevelStorage getTimesStartedForLevel:self];
}

- (int)getTimesPlayed {
    return [LevelStorage getTimesPlayedForLevel:self];
}

- (double)getSlowestDuration {
    return [LevelStorage getSlowestDurationForLevel:self];
}

- (double)getFastestDuration {
    return [LevelStorage getFastestDurationforLevel:self];
}

- (void)decAmount:(double)amount forScoreWithScoreId:(NSString *)scoreId {
    [self.scores[scoreId] decBy:amount];
}

- (void)incAmount:(double)amount forScoreWithScoreId:(NSString *)scoreId {
    [self.scores[scoreId] incBy:amount];
}

- (BOOL)start {
    
    
    LogDebug(TAG, ([NSString stringWithFormat:@"Starting level with worldId: %@", self.worldId]));
    
    if (![self canStart]) {
        return NO;
    }
    
    [LevelStorage incTimesStartedForLevel:self];
    self.startTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    
    // Notify level has started
    [BlueprintEventHandling postLevelStarted:self];
    
    return YES;
}

- (void)end {
    
    // Count number of times this level was played
    [LevelStorage incTimesPlayedForLevel:self];
    
    // Calulate the slowest \ fastest durations of level play
    long long endTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    double duration = (endTime - self.startTime) / 1000.0;
    
    if (duration > [self getSlowestDuration]) {
        [LevelStorage setSlowestDuration:duration forLevel:self];
    }
    
    if (duration < [self getFastestDuration]) {
        [LevelStorage setFastestDuration:duration forLevel:self];
    }
    
    for (NSString* key in self.scores) {
        if ([self.scores[key] isKindOfClass:[VirtualItemScore class]]) {
            VirtualItemScore* score = self.scores[key];
            @try {
                [StoreInventory giveAmount:score.tempScore ofItem:score.associatedItemId];
            }
            @catch (VirtualItemNotFoundException *ex) {
                LogError(TAG, ([NSString stringWithFormat:@"Couldn't find item associated with a given \
                                VirtualItemScore. itemId: %@", score.associatedItemId]));
            }
        }
        
        // resetting scores
        [(Score*)self.scores[key] saveAndReset];
    }
    
    // Notify level has ended
    [BlueprintEventHandling postLevelEnded:self];
}


@end
