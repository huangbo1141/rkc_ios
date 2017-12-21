//
//  LabelModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LabelModel.h"

@implementation LabelModel
- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"delivery_id"] != nil) self.mDeliveryId = [dict objectForKey:@"delivery_id"];
    if([dict objectForKey:@"file_name"] != nil) self.mFileName = [dict objectForKey:@"file_name"];
    if([dict objectForKey:@"big_file"] != nil) self.mBigFile = [dict objectForKey:@"big_file"];
    if([dict objectForKey:@"thumb_file"] != nil) self.mThumbFile = [dict objectForKey:@"thumb_file"];
    
}
@end
