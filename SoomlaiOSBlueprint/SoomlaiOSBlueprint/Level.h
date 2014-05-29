//
//  Level.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/29/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "World.h"

@interface Level : World {

    @private
    long long startTime;
}

@property long long startTime;


- (int)getTimesStarted;

- (int)getTimesPlayed;

- (double)getSlowestDuration;

- (double)getFastestDuration;

- (void)decAmount:(double)amount forScoreWithScoreId:(NSString *)scoreId;

- (void)incAmount:(double)amount forScoreWithScoreId:(NSString *)scoreId;

- (BOOL)start;

- (void)end;

@end
