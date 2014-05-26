//
//  Blueprint.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/22/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Blueprint.h"
#import "Score.h"

@implementation Blueprint


// private
- (Score*) fetchScoreByScoreId:(NSString*)scoreId fromWorlds:(NSDictionary*)worlds {
    // TODO: Implement
}


+ (Blueprint*)getInstance {
    static Blueprint* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[Blueprint alloc ] init];
        }
    }
    
    return _instance;
}

@end
