//
//  LaboratoryModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LaboratoryModel.h"
#import "SettingModel.h"

@implementation LaboratoryModel

- (id)init
{
    if((self = [super init])) {
       
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
      if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
      if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
      if([dict objectForKey:@"operator"] != nil) self.mOperatorId = [dict objectForKey:@"operator"];
      if([dict objectForKey:@"operator_name"] != nil) self.mOperatorName = [dict objectForKey:@"operator_name"];
      if([dict objectForKey:@"log_date"] != nil) self.mLogDate = [dict objectForKey:@"log_date"];
      if([dict objectForKey:@"title"] != nil) self.mTitle  = [dict objectForKey:@"title"];
      if([dict objectForKey:@"comment"] != nil) self.mComment  = [dict objectForKey:@"comment"];
      if([dict objectForKey:@"update_time"] != nil) self.mUpdateTime  = [dict objectForKey:@"update_time"];
}

-(NSString*) getLogDate {
    if(self.mLogDate == nil) return nil;
    return [[SettingModel shared] getSystemDateString:self.mLogDate];
}
-(void) setLogDate:(NSString*) logDate {
    self.mLogDate = [[SettingModel shared] getMysqlDateString:logDate];
    
}

-(NSString*) getMysqlLogDate {
    return self.mLogDate;
}
-(void) setMysqlLogDate:(NSString*) logDate {
    self.mLogDate = logDate;
}
-(NSString*) getUpdateTime {
    if(self.mLogDate == nil) return nil;
    return [[SettingModel shared] getSystemDatetimeString:self.mLogDate];
}
-(void) setMysqlUpdateTime:(NSString*) updateTime {
    self.mLogDate = updateTime;
}
@end
