//
//  RecordMission.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Mission.h"

@interface RecordMission : Mission {
    
    @private
    NSString* associatedScoreId;
    double desiredRecord;
}

@property (strong, nonatomic) NSString* associatedScoreId;
@property double desiredRecord;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
   andAssociatedScoreId:(NSString *)oAssociatedScoreId andDesiredRecord:(int)oDesiredRecord;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
             andRewards:(NSArray *)oRewards andAssociatedScoreId:(NSString *)oAssociatedScoreId andDesiredRecord:(int)oDesiredRecord;

@end
