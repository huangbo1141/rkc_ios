//
//  LocationModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel
- (id)init
{
    if((self = [super init])) {

    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"name"] != nil) self.mName = [dict objectForKey:@"name"];
    if([dict objectForKey:@"description"] != nil) self.mDescription = [dict objectForKey:@"description"];
    if([dict objectForKey:@"is_deleted"] != nil) self.mIsDeleted = [dict objectForKey:@"is_deleted"];
    if([dict objectForKey:@"area_name"] != nil) self.mName = [dict objectForKey:@"area_name"];
    
}
@end
