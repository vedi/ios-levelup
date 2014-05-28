//
//  VirtualItemReward.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/27/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Reward.h"

@interface VirtualItemReward : Reward {
    
    @private
    int amount;
    NSString* associatedItemId;
}

@property (strong, nonatomic) NSString* associatedItemId;
@property int amount;

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andAmount:(int)oAmount andAssociatedItemId:(NSString *)oAssociatedItemId;

@end
