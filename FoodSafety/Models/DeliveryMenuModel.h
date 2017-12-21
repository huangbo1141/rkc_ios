//
//  DeliveryMenuModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryMenuModel : NSObject
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mTitle;
@property (nonatomic, strong) NSString* mLogTime;
@property (nonatomic, strong) NSString* mLogDate;
@property (nonatomic, strong) NSString* mLocation;
@property (nonatomic, strong) NSString* mItems;
@property (nonatomic, strong) NSString* mLocationName;
@property (nonatomic, strong) NSString* mUpdateTime;


@property (nonatomic, strong) NSMutableArray* mTimeTypes;
@property (nonatomic, strong) NSMutableArray* mLabels;
@property (nonatomic, strong) NSMutableArray* mItemModels;

-(void) parse:(NSDictionary*) dict;

-(NSString*) getAllergensString;
-(void) setDate:(NSString*) date;
-(NSString*) getDate;



-(NSString*) getItemsJson;
-(void) parseLogTime:(NSString*) jsonString;
-(NSString*) getLogTimeJson;
-(NSString*) getLogTimeUserFriendly;
-(NSString*) getLabelsJson;
-(NSString*) getMysqlLogDate;
@end
