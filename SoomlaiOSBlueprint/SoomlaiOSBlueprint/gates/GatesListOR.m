//
//  GatesListOR.m
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "GatesListOR.h"
#import "BPJSONConsts.h"


@implementation GatesListOR

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:@"listOR" forKey:BP_TYPE];
    
    return toReturn;
}

- (BOOL)isOpen {
    for (Gate* gate in self.gates) {
        if (![gate isOpen]) {
            return YES;
        }
    }
    return NO;
}

@end
