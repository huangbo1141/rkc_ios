//
//  TransportInfoModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportInfoModel : NSObject
@property (nonatomic, strong) NSMutableArray* mLogs;
@property (nonatomic, strong) NSMutableArray* mLocations;

-(void) parse:(NSDictionary*) dict;
@end
