//
//  Challenge.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Mission.h"

@interface Challenge : Mission {
    
    @private
    NSArray* missions;
}

@property (strong, nonatomic) NSArray* missions;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andMissions:(NSArray *)oMissions;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andMissions:(NSArray *)oMissions andRewards:(NSArray *)oRewards;

@end
