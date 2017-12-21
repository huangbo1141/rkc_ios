//
//  CalendarAssignModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssignModel.h"

@interface CalendarAssignModel : AssignModel
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mUser;

@property (nonatomic, strong) NSString* mItem;
@property (nonatomic, strong) NSString* mColor;
@property (nonatomic, strong) NSString* mTimes;
@property (nonatomic, strong) NSString* mDate;

-(void) parse:(NSDictionary*) dict;

-(NSString*) getTimeString;
@end
