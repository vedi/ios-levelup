/*
 Copyright (C) 2012-2014 Soomla Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "Score.h"

@interface VirtualItemScore : Score {

    @private
    NSString* associatedItemId;
}

@property (strong, nonatomic) NSString* associatedItemId;


/**
 Constructor
 
 @param scoreId see parent
 @param name see parent
 @param associatedItemId the ID of the virtual item associated with this score
 */
- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andAssociatedItemId:(NSString *)oAssociatedItemId;

/**
 Constructor
 
 @param scoreId see parent
 @param name see parent
 @param higherBetter see parent
 @param associatedItemId the ID of the virtual item associated with this score
 */
- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter andAssociatedItemId:(NSString *)oAssociatedItemId;

/**
 Constructor.
 Generates an instance of `VirtualItemScore` from an `NSDictionary`.
 
 @param dict An `NSDictionary` representation of the wanted `VirtualItemScore`.
 */
- (id)initWithDictionary:(NSDictionary *)dict;

/**
 Converts the current `VirtualItemScore` to an `NSDictionary`.
 
 @return This instance of `VirtualItemScore` as an `NSDictionary`.
 */
- (NSDictionary*)toDictionary;

@end
