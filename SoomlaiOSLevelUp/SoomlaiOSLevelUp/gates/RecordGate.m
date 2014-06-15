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
#import "StoreUtils.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreRecordChanged:) name:EVENT_BP_SCORE_RECORD_CHANGED object:nil];
    }
    
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedScoreId = [dict objectForKey:BP_ASSOCSCOREID];
        self.desiredRecord = [[dict objectForKey:BP_DESIRED_RECORD] doubleValue];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreRecordChanged:) name:EVENT_BP_SCORE_RECORD_CHANGED object:nil];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.associatedScoreId forKey:BP_ASSOCSCOREID];
    [toReturn setValue:[NSNumber numberWithDouble:self.desiredRecord] forKey:BP_DESIRED_RECORD];
    [toReturn setValue:TYPE_NAME forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)canPass {
    
    Score* score = [[LevelUp getInstance] getScoreWithScoreId:self.associatedScoreId];
    if (!score) {
        LogError(TAG, ([NSString stringWithFormat:@"(canPass) couldn't find score with scoreId: %@", self.associatedScoreId]));
        return NO;
    }
    
    return [score hasRecordReachedScore:self.desiredRecord];
}

- (void)tryOpenInner {
    if ([self canPass]) {
        [self forceOpen:YES];
    }
}

// Private

- (void)scoreRecordChanged:(NSNotification *)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    Score* score = [userInfo objectForKey:DICT_ELEMENT_SCORE];
    
    if ([score.scoreId isEqualToString:self.associatedScoreId] && [score hasRecordReachedScore:self.desiredRecord]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [LevelUpEventHandling postGateCanBeOpened:self];
    }
};

@end
