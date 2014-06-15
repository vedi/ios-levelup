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

#import "Level.h"
#import "LevelStorage.h"
#import "Score.h"
#import "BPJSONConsts.h"
#import "LevelUpEventHandling.h"
#import "VirtualItemScore.h"
#import "VirtualItemNotFoundException.h"
#import "StoreInventory.h"
#import "StoreUtils.h"


@implementation Level

//@synthesize startTime;

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
    startTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    
    // Notify level has started
    [LevelUpEventHandling postLevelStarted:self];
    
    return YES;
}

- (void)pause {
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    currentTime = now - startTime;
    paused = YES;
}

- (void)resume {
    startTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    paused = NO;
}

- (void)end:(BOOL)completed {
    
    // check end() called without matching start()
    if (	startTime == 0) {
        LogDebug(TAG, @"end() called without prior start()! ignoring.");
        return;
    }
    
    // Count number of times this level was played
    [LevelStorage incTimesPlayedForLevel:self];
    
    // Calculate the slowest \ fastest durations of level play
    long long _startTime = paused ? currentTime : (long long)([[NSDate date] timeIntervalSince1970] * 1000) - startTime;
    long long endTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    double duration = (endTime - _startTime) / 1000.0;
    
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
    [LevelUpEventHandling postLevelEnded:self];
    
    // reset timers
    startTime = 0;
    currentTime = 0;
    paused = NO;
    
    if(completed) {
        [self setCompleted:YES];
    }
}


@end
