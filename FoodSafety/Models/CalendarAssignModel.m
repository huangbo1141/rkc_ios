//
//  CalendarAssignModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "CalendarAssignModel.h"
#import "Global.h"

@implementation CalendarAssignModel
- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"user"] != nil) self.mUser = [dict objectForKey:@"user"];
    if([dict objectForKey:@"item"] != nil) self.mItem = [dict objectForKey:@"item"];
    if([dict objectForKey:@"color"] != nil) self.mColor = [dict objectForKey:@"color"];
    if([dict objectForKey:@"date"] != nil) self.mDate = [dict objectForKey:@"date"];
    if([dict objectForKey:@"times"] != nil) self.mTimes = [dict objectForKey:@"times"];
    
    if([dict objectForKey:@"item_id"] != nil) self.mItemId  = [dict objectForKey:@"item_id"];
    if([dict objectForKey:@"location"] != nil) self.mLocation  = [dict objectForKey:@"location"];
    if([dict objectForKey:@"location_id"] != nil) self.mLocationId  = [dict objectForKey:@"location_id"];
    
}

-(NSString*) getTimeString {
    if(self.mTimes != nil) {
        NSString*  result = @"";
        NSDictionary* dict = [Global jsonToDict:self.mTimes];
        if(dict == nil)
            return @"";
        for (NSString* time in dict){
            if([time isEqualToString:@"1"])
                result = [result stringByAppendingString:@"Morning, "];
            
            if([time isEqualToString:@"2"])
                result = [result stringByAppendingString:@"Afternoon, "];
            
            if([time isEqualToString:@"3"])
                result = [result stringByAppendingString:@"Evening, "];
        }
        if(dict.count > 0)
            result = [result substringToIndex:result.length -2];
        return result;
    }
    return @"";
}
@end
