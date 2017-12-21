//
//  SettingModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

+ (instancetype)shared
{
    static SettingModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SettingModel alloc] init];
        
    });
    
    return sharedInstance;
}

-(id) init{
    self = [super init];
    if(self != nil)
    {
        self.mDatetimeFormat = @"yyyy-MM-dd HH:mm:ss";
        self.mDateFormat = @"yyyy-MM-dd";
        self.mShowDatetimeFormat = @"YYYY-MM-DD h:m:s";
    }
    return self;
}

-(NSString*) getSystemDateStringFromValues:(int) year withMonth:(int) month withDay:(int) day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: day];
    [components setMonth:month - 1];
    [components setYear:year];
    NSDate *_date = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.mDateFormat];
    return [formatter stringFromDate:_date];
}
-(NSString*) getSystemTimeStringFromValues:(int) hourOfDay withMinute:(int) minute withSecond:(int) second {
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hourOfDay, minute, second];
}
-(NSString*) getSystemTimeString:(NSString*) mysqlFormatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate * date =  [formatter dateFromString:mysqlFormatStr];
    NSDateFormatter *outFormat =  [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:self.mTimeFormat];
    return [outFormat stringFromDate:date];
    
    
}
-(NSString*) getMysqlTimeString:(NSString*) systemFormatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.mTimeFormat];
    
    NSDate * date =  [formatter dateFromString:systemFormatStr];
    NSDateFormatter *outFormat =  [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"HH:mm:ss"];
    return [outFormat stringFromDate:date];
}

-(NSString*) getSystemDateString:(NSString*) mysqlFormatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date =  [formatter dateFromString: mysqlFormatStr];
    NSDateFormatter *outFormat =  [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:self.mDateFormat];
    return [outFormat stringFromDate:date];
}
-(NSString*) getMysqlDateString:(NSString*) systemFormatStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.mDateFormat];
    
    NSDate * date =  [formatter dateFromString: systemFormatStr];
    NSDateFormatter *outFormat =  [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"yyyy-MM-dd"];
    return [outFormat stringFromDate:date];
}

-(NSString*) getSystemDatetimeString:(NSString*) mysqlFormatStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date =  [formatter dateFromString: mysqlFormatStr];
    NSDateFormatter *outFormat =  [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:self.mDatetimeFormat];
    return [outFormat stringFromDate:date];
}
-(NSString*) getMysqlDatetimeString:(NSString*) systemFormatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.mDatetimeFormat];
    
    NSDate * date =  [formatter dateFromString: systemFormatStr];
    NSDateFormatter *outFormat =  [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [outFormat stringFromDate:date];
}


-(NSString*) getMysqlDateStringFromDate:(NSDate*) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

-(NSString*) getMysqlTimeStringFromDate:(NSDate*) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter stringFromDate:date];
}

-(NSString*) getMysqlDateTimeStringFromDate:(NSDate*) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}


-(void) parse:(NSDictionary*) dict{
    
    if (self) {
        if([dict objectForKey:@"dateformat"] != nil)
        {
            NSDictionary* dateformat = (NSDictionary*)[dict objectForKey:@"dateformat"];
            if([dateformat objectForKey:@"ios_format"]) {
                self.mDatetimeFormat = [dateformat objectForKey:@"ios_format"];
                NSArray<NSString*>* formats = [self.mDatetimeFormat componentsSeparatedByString:@" "];
                if(formats.count == 2) {
                    self.mDateFormat = formats[0];
                    self.mTimeFormat = formats[1];
                }
             }
            if([dateformat objectForKey:@"show_format"]) {
                self.mShowDatetimeFormat = [dateformat objectForKey:@"show_format"];
            }
        }
        
    }
    
}

@end
