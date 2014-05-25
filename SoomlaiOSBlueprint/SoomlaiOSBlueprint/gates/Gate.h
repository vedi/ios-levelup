//
//  Gate.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <Foundation/Foundation.h>


// TODO: Document abstract class

@interface Gate : NSObject {
    
    @private
    NSString* gateId;
}

@property (strong, nonatomic) NSString* gateId;

- (id)initWithId:(NSString *)oGateId;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (void)tryOpen;

- (void)tryOpenInner;

- (void)forceOpen:(BOOL)open;

- (BOOL)isOpen;


@end