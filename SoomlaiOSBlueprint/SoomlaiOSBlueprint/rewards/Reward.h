//
//  Reward.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

// TODOL document abstract class
@interface Reward : NSObject {
    
    @private
    NSString* rewardId;
    NSString* name;
}

@property (strong, nonatomic) NSString* rewardId;
@property (strong, nonatomic) NSString* name;


- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

- (void)give;

- (void)take;

- (BOOL)isOwned;

// Abstract method
- (BOOL)giveInner;

@end
