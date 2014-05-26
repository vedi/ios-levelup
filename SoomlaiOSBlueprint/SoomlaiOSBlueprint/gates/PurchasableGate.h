//
//  PurchasableGate.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Gate.h"

@interface PurchasableGate : Gate {
    
    @private
    NSString* associatedItemId;
}

@property (strong, nonatomic) NSString* associatedItemId;

- (id)initWithId:(NSString *)oGateId andAssociatedItemId:(NSString *)oAssociatedItemId;

@end
