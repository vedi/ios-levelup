//
//  Mission.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/28/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//


// Abstract (not because of unimplemented methods, but in the sense that
// the developer should not instantiate this class directly but only sub-classes)
@interface Mission : NSObject {
    
    @private
    NSString* missionId;
    NSString* name;
    NSArray* rewards;
}

@property (strong, nonatomic) NSString* missionId;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* rewards;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andRewards:(NSArray *)oRewards;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

- (BOOL)isCompleted;

- (void)setCompleted:(BOOL)completed;

- (BOOL)isEqualToMission:(Mission *)mission;

- (BOOL)isEqual:(id)object;

- (NSUInteger)hash;

@end
