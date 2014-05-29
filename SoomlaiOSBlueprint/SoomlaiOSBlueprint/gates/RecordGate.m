//
//  RecordGate.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "RecordGate.h"
#import "Score.h"
#import "Blueprint.h"
#import "BPJSONConsts.h"
#import "BlueprintEventHandling.h"
#import "StoreUtils.h"

@implementation RecordGate

@synthesize associatedScoreId, desiredRecord;

static NSString* TAG = @"SOOMLA RecordGate";

- (id)initWithGateId:(NSString *)oGateId andScoreId:(NSString *)oScoreId andDesiredRecord:(double)oDesiredRecord {
    if ([self initWithGateId:oGateId]) {
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
    [toReturn setValue:@"record" forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)canPass {
    
    Score* score = [[Blueprint getInstance] getScoreWithScoreId:self.associatedScoreId];
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
        [BlueprintEventHandling postGateCanBeOpened:self];
    }
};

@end
