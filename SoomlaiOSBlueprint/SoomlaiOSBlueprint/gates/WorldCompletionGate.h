//
//  WorldCompletionGate.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Gate.h"

@interface WorldCompletionGate : Gate {
    @private
    NSString* associatedWorldId;
}

@property (strong, nonatomic) NSString* associatedWorldId;


- (id)initWithGateId:(NSString *)oGateId andAssociatedWorldId:(NSString *)oAssociatedWorldId;

@end
