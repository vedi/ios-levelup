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

#import "RecordGate.h"
#import "Score.h"
#import "LevelUp.h"
#import "BPJSONConsts.h"
#import "LevelUpEventHandling.h"
#import "SoomlaUtils.h"

@implementation RecordGate

@synthesize associatedScoreId, desiredRecord;

static NSString* TYPE_NAME = @"record";
static NSString* TAG = @"SOOMLA RecordGate";

- (id)initWithGateId:(NSString *)oGateId andScoreId:(NSString *)oScoreId andDesiredRecord:(double)oDesiredRecord {
    if (self = [super initWithGateId:oGateId]) {
        self.associatedScoreId = oScoreId;
        self.desiredRecord = oDesiredRecord;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreRecordChanged:) name:EVENT_SCORE_RECORD_CHANGED object:nil];
    }
    
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedScoreId = dict[LEVELUP_ASSOCSCOREID];
        self.desiredRecord = [dict[LEVELUP_DESIRED_RECORD] doubleValue];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreRecordChanged:) name:EVENT_SCORE_RECORD_CHANGED object:nil];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:self.associatedScoreId forKey:LEVELUP_ASSOCSCOREID];
    [toReturn setObject:[NSNumber numberWithDouble:self.desiredRecord] forKey:LEVELUP_DESIRED_RECORD];
    [toReturn setObject:TYPE_NAME forKey:LEVELUP_TYPE];
    
    return toReturn;
}

- (BOOL)canOpen {
    
    Score* score = [[LevelUp getInstance] getScoreWithScoreId:self.associatedScoreId];
    if (!score) {
        LogError(TAG, ([NSString stringWithFormat:@"(canOpen) couldn't find score with scoreId: %@", self.associatedScoreId]));
        return NO;
    }
    
    return [score hasRecordReachedScore:self.desiredRecord];
}

- (BOOL)tryOpenInner {
    if ([self canOpen]) {
        [self forceOpen:YES];
        return YES;
    }
    return NO;
}

// Private

- (void)scoreRecordChanged:(NSNotification *)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    Score* score = userInfo[DICT_ELEMENT_SCORE];
    
    if ([score.scoreId isEqualToString:self.associatedScoreId] && [score hasRecordReachedScore:self.desiredRecord]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        // gate can now open
    }
};

@end
