//
//  RecordGate.h
//  SoomlaiOSBlueprint
//
//  Created by Gur Dotan on 5/26/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "Gate.h"

@interface RecordGate : Gate {
    
    @private
    NSString* associatedScoreId;
    double desiredRecord;
}

@property (strong, nonatomic) NSString* associatedScoreId;
@property double desiredRecord;

- (id)initWithGateId:(NSString *)oGateId andScoreId:(NSString *)oScoreId andDesiredRecord:(double)oDesiredRecord;

@end
