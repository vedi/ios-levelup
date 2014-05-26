//
//  World.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface World : NSObject {
    
    @private
    NSString* worldId;
}

@property (strong, nonatomic) NSString* worldId;

- (BOOL)isCompleted;

@end
