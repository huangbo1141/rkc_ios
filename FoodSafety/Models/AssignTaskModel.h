//
//  AssignTaskModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignTaskModel : NSObject
@property (nonatomic, strong) NSString* mItemType;
@property (nonatomic, strong) NSString* mTaskType;
@property (nonatomic, strong) NSMutableDictionary* mParams;
@property (nonatomic, assign) int mIndex;

- (void) setItemType:(BOOL) isSection withTaskType:(NSString*) taskType;
- (NSString*) getSectionTitle;
- (void) parse:(NSString*) sectionType withDict:(NSDictionary*) dict;
- (NSString*) getSectionTitle:(NSString*) taskType;
- (NSString*) getLogoImageName;
@end
