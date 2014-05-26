//
//  GatesList.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/25/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Gate.h"

// TODO: Document abstract class
@interface GatesList : Gate {
    
    @private
    NSMutableArray* gates;
}

@property (strong, nonatomic) NSMutableArray* gates;


- (id)initWithId:(NSString *)oGateId andSingleGate:(Gate *)oSingleGate;

- (id)initWithId:(NSString *)oGateId andGates:(NSArray*)oGates;

- (void)addGate:(Gate *)gate;

- (int)size;


@end
