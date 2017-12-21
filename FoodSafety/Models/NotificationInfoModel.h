//
//  NotificationInfoModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationInfoModel : NSObject
@property (nonatomic, strong) NSMutableArray* mLogs;

-(void) parse:(NSDictionary*) dict;
@end
