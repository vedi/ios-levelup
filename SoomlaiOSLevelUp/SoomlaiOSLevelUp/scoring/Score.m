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
#import "RangeScore.h"
#import "VirtualItemScore.h"
#import "ScoreStorage.h"
#import "JSONConsts.h"
#import "BPJSONConsts.h"
#import "DictionaryFactory.h"


@implementation Score

@synthesize name, scoreId, startValue, tempScore, higherBetter;

static NSString* TYPE_NAME = @"score";
static DictionaryFactory* dictionaryFactory;


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
        self.scoreId = dict[LEVELUP_SCORE_SCOREID];
        self.name = dict[LEVELUP_NAME];
        self.startValue = [dict[LEVELUP_SCORE_STARTVAL] doubleValue];
        self.higherBetter = [dict[LEVELUP_SCORE_HIGHBETTER] boolValue];
    }
    
    return self;
};

- (NSDictionary*)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            NSStringFromClass([self class]), SOOM_CLASSNAME,
            self.scoreId, LEVELUP_SCORE_SCOREID,
            self.name, LEVELUP_NAME,
            self.startValue, LEVELUP_SCORE_STARTVAL,
            self.higherBetter, LEVELUP_SCORE_HIGHBETTER,
            TYPE_NAME, LEVELUP_TYPE,
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
    double record = [ScoreStorage getRecordScore:self];
    if ([self hasTempScoreReached:record]) {
        [ScoreStorage setRecord:self.tempScore toScore:self];
    }
    
    [self performSaveActions];
    
    [ScoreStorage setLatest:self.tempScore toScore:self];
    self.tempScore = self.startValue;
}

- (void)reset {
    self.tempScore = self.startValue;

    // 0 doesn't work well (confusing) for descending score
    // if someone set higherBetter(false) and a start value of 100
    // I think they expect reset to go back to 100, otherwise
    // 0 is the best and current record and can't be beat
    [ScoreStorage setRecord:self.startValue toScore:self]; // startValue is 0
    [ScoreStorage setLatest:self.startValue toScore:self]; // startValue is 0
}

- (BOOL)hasTempScoreReached:(double)scoreVal {
    return [self hasScore:self.tempScore reached:scoreVal];
}

- (BOOL)hasRecordReachedScore:(double)scoreVal {
    double record = [ScoreStorage getRecordScore:self];
    return [self hasScore:record reached:scoreVal];
}

- (double)getRecord {
    return [ScoreStorage getRecordScore:self];
}

- (double)getLatest {
    return [ScoreStorage getLatestScore:self];
}

- (BOOL)hasScore:(double)scoreValue1 reached:(double)scoreValue2 {
    return [self isHigherBetter] ?
    (scoreValue1 >= scoreValue2) :
    (scoreValue1 <= scoreValue2);
}

- (void)performSaveActions {}


// Static methods

+ (Score *)fromDictionary:(NSDictionary *)dict {
    return (Score *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (NSString *)getTypeName {
    return TYPE_NAME;
}


+ (void)initialize {
    if (self == [Score self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}


@end

