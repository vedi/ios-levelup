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

#import "Score.h"
#import "ScoresStorage.h"
#import "BPJSONConsts.h"
#import "BlueprintEventHandling.h"


@implementation Score

@synthesize name, scoreId, startValue, tempScore, higherBetter;


- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName {
    if (self = [super init]) {
        self.scoreId = oScoreId;
        self.name = oName;
        self.startValue = 0;
        self.higherBetter = YES;

    }
    return self;
}

- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter {
    if (self = [super init]) {
        self.scoreId = oScoreId;
        self.name = oName;
        self.startValue = 0;
        self.higherBetter = oHigherBetter;
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.scoreId = [dict objectForKey:BP_SCORE_SCOREID];
        self.name = [dict objectForKey:BP_NAME];
        self.startValue = [[dict objectForKey:BP_SCORE_STARTVAL] doubleValue];
        self.higherBetter = [[dict objectForKey:BP_SCORE_HIGHBETTER] boolValue];
    }
    
    return self;
};

- (NSDictionary*)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.scoreId, BP_SCORE_SCOREID,
            self.name, BP_NAME,
            self.startValue, BP_SCORE_STARTVAL,
            self.higherBetter, BP_SCORE_HIGHBETTER,
            nil];
}

- (BOOL)isHigherBetter {
    return higherBetter;
}

- (void)incBy:(double)amount {
    self.tempScore += amount;
}

- (void)decBy:(double)amount {
    self.tempScore -= amount;
}

- (void)saveAndReset {
    double record = [ScoresStorage getRecordScore:self];
    if ([self hasTempScoreReached:record]) {
        [ScoresStorage setRecord:self.tempScore toScore:self];
        [BlueprintEventHandling postScoreRecordChanged:self];
    }
    [ScoresStorage setLatest:self.tempScore toScore:self];
    self.tempScore = self.startValue;
}

- (void)reset {
    self.tempScore = self.startValue;
    [ScoresStorage setRecord:0 toScore:self];
    [ScoresStorage setLatest:0 toScore:self];
}

- (BOOL)hasTempScoreReached:(double)scoreVal {
    return [self hasScore:self.tempScore reached:scoreVal];
}

- (BOOL)hasRecordReachedScore:(double)scoreVal {
    double record = [ScoresStorage getRecordScore:self];
    return [self hasScore:record reached:scoreVal];
}

- (double)getRecord {
    return [ScoresStorage getRecordScore:self];
}

- (double)getLatest {
    return [ScoresStorage getLatestScore:self];
}

- (BOOL)hasScore:(double)scoreValue1 reached:(double)scoreValue2 {
    return [self isHigherBetter] ?
    (scoreValue1 >= scoreValue2) :
    (scoreValue1 <= scoreValue2);
}

@end

