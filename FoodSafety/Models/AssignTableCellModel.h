//
//  AssignTableCellModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssignModel.h"

@interface AssignTableCellModel : NSObject
@property (nonatomic, strong) NSString* mDay;
@property (nonatomic, strong) NSString* mTime;
@property (nonatomic, strong) NSMutableArray* mAssigns;

- (NSString*) getTableCellText;
- (NSString*) getTableCellLocationKeyCode;
- (NSString*) getTableCellLocationId;
- (AssignModel*) getTableCellModel;
- (int) getTableCellIndex;
@end
