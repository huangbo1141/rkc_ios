//
//  MenuInfoModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuInfoModel : NSObject
@property (nonatomic, strong) NSMutableArray* mLogs;
@property (nonatomic, strong) NSMutableArray* mLocations;
@property (nonatomic, strong) NSMutableArray* mSuppliers;
//@property (nonatomic, strong) NSMutableArray* mOperators;
-(void) parse:(NSDictionary*) dict;
@end
