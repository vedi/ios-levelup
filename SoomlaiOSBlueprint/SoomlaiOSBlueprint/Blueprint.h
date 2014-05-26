//
//  Blueprint.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/22/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#define BP_DB_KEY_PREFIX @"soomla.blueprint"

@class Score;
@class World;

@interface Blueprint : NSObject

- (Score*) getScoreForScoreId:(NSString*)scoreId;

- (World*) getWorldWithWorldId:(NSString*)worldId;


+ (Blueprint*)getInstance;

@end
