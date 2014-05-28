//
//  BalanceMission.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Mission.h"

@interface BalanceMission : Mission {
    
    @private
    NSString* associatedItemId;
    int desiredBalance;
}

@property (strong, nonatomic) NSString* associatedItemId;
@property int desiredBalance;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
    andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
             andRewards:(NSArray *)oRewards andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance;

@end
