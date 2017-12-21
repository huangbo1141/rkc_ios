//
//  LogModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LogModel.h"
#import "SettingModel.h"

@implementation LogModel

- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"capture_datetime"] != nil) self.mCaptureDateTime = [dict objectForKey:@"capture_datetime"];
    if([dict objectForKey:@"capture_value"] != nil) self.mCaptureValue = [dict objectForKey:@"capture_value"];
    if([dict objectForKey:@"capture_note"] != nil) self.mCaptureNote = [dict objectForKey:@"capture_note"];
    if([dict objectForKey:@"big_file"] != nil) self.mBigFile = [dict objectForKey:@"big_file"];
    if([dict objectForKey:@"thumb_file"] != nil) self.mThumbFile = [dict objectForKey:@"thumb_file"];
    if([dict objectForKey:@"location_code"] != nil) self.mLocationCode = [dict objectForKey:@"location_code"];
    if([dict objectForKey:@"location"] != nil) self.mLocation = [dict objectForKey:@"location"];
    if([dict objectForKey:@"operator"] != nil) self.mOperator = [dict objectForKey:@"operator"];
    if([dict objectForKey:@"item"] != nil) self.mItem = [dict objectForKey:@"item"];
    if([dict objectForKey:@"item_code"] != nil) self.mItemCode = [dict objectForKey:@"item_code"];
    if([dict objectForKey:@"item_id"] != nil) self.mItemId = [dict objectForKey:@"item_id"];
    
    
    
}
-(NSString*) getCaptureDatetime{
    if(self.mCaptureDateTime == nil)
        return nil;
    return [[SettingModel shared] getSystemDatetimeString:self.mCaptureDateTime];
}
-(NSString*) getMysqlCaptureDatetime {
    return self.mCaptureDateTime;
}

-(void) setCaptureDatetime:(NSString*) captureDatetime {
    self.mCaptureDateTime = [[SettingModel shared] getMysqlDatetimeString:captureDatetime];
}
-(void) setMysqlCaptureDatetime:(NSString*) captureDatetime {
    self.mCaptureDateTime = captureDatetime;
}
@end
