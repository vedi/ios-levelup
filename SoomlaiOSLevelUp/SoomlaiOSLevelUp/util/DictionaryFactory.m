//
//  DictionaryFactory.m
//  SoomlaiOSLevelUp
//
//  Created by Gur Dotan on 6/15/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "DictionaryFactory.h"
#import "StoreUtils.h"
#import "BPJSONConsts.h"

@implementation DictionaryFactory

static NSString* TAG = @"SOOMLA DictionaryFactory";

- (id)createObjectWithDictionary:(NSDictionary *)dict andTypeMap:(NSDictionary *)typeMap {
    
    if (!dict) {
        // warn
        return nil;
    }
    
    id obj = nil;
    NSString* type = dict[BP_TYPE];
    Class clazz = typeMap[type];
    
    if (clazz) {
        obj = [[clazz alloc] initWithDictionary:dict];
    } else {
        LogDebug(TAG, ([NSString stringWithFormat:@"Unknown type: %@", type]));
    }
    
    return obj;
}

@end
