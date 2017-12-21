//
//  SettingModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject


@property (nonatomic, strong) NSString* mDateFormat;
@property (nonatomic, strong) NSString* mTimeFormat;
@property (nonatomic, strong) NSString* mDatetimeFormat;
@property (nonatomic, strong) NSString* mShowDatetimeFormat;

+ (instancetype)shared;

-(NSString*) getSystemDateStringFromValues:(int) year withMonth:(int) month withDay:(int) day;
-(NSString*) getSystemTimeStringFromValues:(int) hourOfDay withMinute:(int) minute withSecond:(int) second;
-(NSString*) getSystemTimeString:(NSString*) mysqlFormatStr;
-(NSString*) getMysqlTimeString:(NSString*) systemFormatStr;

-(NSString*) getSystemDateString:(NSString*) mysqlFormatStr;
-(NSString*) getMysqlDateString:(NSString*) mysqlFormatStr;

-(NSString*) getSystemDatetimeString:(NSString*) mysqlFormatStr;
-(NSString*) getMysqlDatetimeString:(NSString*) systemFormatStr;


-(NSString*) getMysqlDateStringFromDate:(NSDate*) date;
-(NSString*) getMysqlDateTimeStringFromDate:(NSDate*) date;
-(NSString*) getMysqlTimeStringFromDate:(NSDate*) date;

-(void) parse:(NSDictionary*) dict;


@end
