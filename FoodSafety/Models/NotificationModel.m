//
//  NotificationModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NotificationModel.h"
#import "SettingModel.h"

@implementation NotificationModel
- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"from_user"] != nil) self.mFromUserId = [dict objectForKey:@"from_user"];
    if([dict objectForKey:@"to_user"] != nil) self.mToUserId = [dict objectForKey:@"to_user"];
    if([dict objectForKey:@"activity"] != nil) self.mMessage = [dict objectForKey:@"activity"];
    if([dict objectForKey:@"link"] != nil) self.mLink = [dict objectForKey:@"link"];
    if([dict objectForKey:@"from_user_name"] != nil) self.mFrom = [dict objectForKey:@"from_user_name"];
    if([dict objectForKey:@"isRead"] != nil) self.mIsRead = [dict objectForKey:@"isRead"];
    if([dict objectForKey:@"create_time"] != nil) self.mTime = [dict objectForKey:@"create_time"];

    
    
    
}
-(NSString*) getTime{
    if(self.mTime == nil)
        return nil;
    return [[SettingModel shared] getSystemDatetimeString:self.mTime];
}
-(NSString*) getMysqlCaptureDatetime {
    return self.mTime;
}

-(void) setTime:(NSString*) time {
    self.mTime = [[SettingModel shared] getMysqlDatetimeString:time];
}
-(void) setMysqlTime:(NSString*) time {
    self.mTime = time;
}
@end
