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

@interface Blueprint : NSObject {

    @private
    NSDictionary* initialWorlds;
}


- (void)initializeWithInitialWorlds:(NSArray *)oInitialWorlds;

- (void)save;

- (Score*) getScoreWithScoreId:(NSString*)scoreId;

- (World*) getWorldWithWorldId:(NSString*)worldId;

+ (Blueprint*)getInstance;

@end
