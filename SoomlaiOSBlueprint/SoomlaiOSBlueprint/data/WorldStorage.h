//
//  WorldStorage.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/29/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class World;

@interface WorldStorage : NSObject

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world;

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world andNotify:(BOOL)notify;

+ (BOOL)isWorldCompleted:(World *)world;


@end
