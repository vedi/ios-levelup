//
//  Gate.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//


// TODO: Document abstract class
@interface Gate : NSObject {
    
    @private
    NSString* gateId;
}

@property (strong, nonatomic) NSString* gateId;

- (id)initWithGateId:(NSString *)oGateId;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (void)tryOpen;

// ABSTRACT
- (void)tryOpenInner;

- (void)forceOpen:(BOOL)open;

- (BOOL)isOpen;


@end
