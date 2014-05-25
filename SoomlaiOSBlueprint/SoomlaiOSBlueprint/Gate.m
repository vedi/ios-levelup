//
//  Gate.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Gate.h"
#import "BPJSONConsts.h"
#import "GatesStorage.h"

@implementation Gate

@synthesize gateId;

- (id)initWithId:(NSString *)oGateId {
    self = [super init];
    if ([self class] == [Gate class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.gateId = oGateId;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([self class] == [Gate class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.gateId = [dict objectForKey:BP_GATE_GATEID];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            self.gateId, BP_GATE_GATEID,
            nil];
}

- (void)tryOpen {
    if ([GatesStorage isOpen:self]) return;
    
    [self tryOpenInner];
}

- (void)tryOpenInner {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)forceOpen:(BOOL)open {
    [GatesStorage setOpen:self withFlag:open];
}

- (BOOL)isOpen {
    return [GatesStorage isOpen:self];
}


@end
