//
//  WorldCompletionGate.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "WorldCompletionGate.h"
#import "World.h"
#import "Blueprint.h"
#import "BPJSONConsts.h"
#import "BlueprintEventHandling.h"
#import "StoreUtils.h"

@implementation WorldCompletionGate

@synthesize associatedWorldId;

- (id)initWithGateId:(NSString *)oGateId andAssociatedWorldId:(NSString *)oAssociatedWorldId {
    if ([self initWithGateId:oGateId]) {
        self.associatedWorldId = oAssociatedWorldId;
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldCompleted:) name:EVENT_BP_WORLD_COMPLETED object:nil];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedWorldId = [dict objectForKey:BP_ASSOCWORLDID];
    }
    
    if (![self isOpen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldCompleted:) name:EVENT_BP_WORLD_COMPLETED object:nil];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.associatedWorldId forKey:BP_ASSOCWORLDID];
    [toReturn setValue:@"worldCompletion" forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)canPass {
    World* world = [[Blueprint getInstance] getWorldWithWorldId:self.associatedWorldId];
    return (world && [world isCompleted]);
}

- (void)tryOpenInner {
    if ([self canPass]) {
        [self forceOpen:YES];
    }
}

// Private

- (void)worldCompleted:(NSNotification *)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    World* world = [userInfo objectForKey:DICT_ELEMENT_WORLD];
    
    if ([world.worldId isEqualToString:self.associatedWorldId]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [BlueprintEventHandling postGateCanBeOpened:self];
    }
};

@end
