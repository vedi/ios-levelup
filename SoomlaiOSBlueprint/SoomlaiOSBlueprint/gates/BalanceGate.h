//
//  BalanceGate.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Gate.h"

@interface BalanceGate : Gate {

    @private
    NSString*   associatedItemId;
    int         desiredBalance;
}

@property (strong, nonatomic) NSString* associatedItemId;
@property int desiredBalance;


- (id)initWithGateId:(NSString *)oGateId andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance;

- (BOOL)canPass;

@end
