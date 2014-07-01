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

#import "RangeScore.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"


@implementation Range

@synthesize low, high;

- (id)initWithLow:(double)oLow andHigh:(double)oHigh {
    if (self = [super init]) {
        self.low = oLow;
        self.high = oHigh;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.low = [dict[LU_SCORE_RANGE_LOW] doubleValue];
        self.high = [dict[LU_SCORE_RANGE_HIGH] doubleValue];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithDouble:self.low], LU_SCORE_RANGE_LOW,
            [NSNumber numberWithDouble:self.high], LU_SCORE_RANGE_HIGH,
            nil];
}


@end





@implementation RangeScore

@synthesize range;


- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andRange:(Range *)oRange {
    if (self = [super init]) {
        self.scoreId = oScoreId;
        self.name = oName;
        self.range = oRange;
    }
    return self;
}

- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter andRange:(Range *)oRange {
    if (self = [super init]) {
        self.scoreId = oScoreId;
        self.name = oName;
        self.higherBetter = oHigherBetter;
        self.range = oRange;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.scoreId = dict[LU_SCORE_SCOREID];
        self.name = dict[LU_NAME];
        self.higherBetter = [dict[LU_SCORE_HIGHBETTER] boolValue];
        self.range = [[Range alloc] initWithDictionary:dict[LU_SCORE_RANGE]];
    }
    return self;
}
    
- (NSDictionary*)toDictionary {
    NSDictionary* parent = [super toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parent];
    [toReturn setObject:[self.range toDictionary] forKey:LU_SCORE_RANGE];
    [toReturn setObject:NSStringFromClass([self class]) forKey:SOOM_CLASSNAME];
    return toReturn;
}
    
- (void)incBy:(double)amount {
    
    // Don't increment if we've hit the range's highest value
    if ([self tempScore] >= self.range.high) return;
    [super incBy:amount];
}

- (void)decBy:(double)amount {

    // Don't increment if we've hit the range's lowest value
    if ([self tempScore] >= self.range.low) return;
    [super decBy:amount];
}

// TODO: document setter override
// TODO: Consult Refael
- (void)setTempScore:(double)scoreValue {
    if (scoreValue > self.range.high) {
        scoreValue = self.range.high;
    }
    if (scoreValue < self.range.low) {
        scoreValue = self.range.low;
    }
    super.tempScore = scoreValue;
}



@end
