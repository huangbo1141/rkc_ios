//
//  AssignModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AssignModel.h"

@implementation AssignModel
- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

-(void) parse:(NSString*) keyCode withDict:(NSDictionary*) dict {
    self.mKeyCode = keyCode;
    if([dict objectForKey:@"color"] != nil) self.mColor = [dict objectForKey:@"color"];
    if([dict objectForKey:@"location"] != nil) self.mLocation = [dict objectForKey:@"location"];
    if([dict objectForKey:@"fullname"] != nil) self.mFullname = [dict objectForKey:@"fullname"];
    if([dict objectForKey:@"group"] != nil) self.mGroup = [dict objectForKey:@"group"];
    if([dict objectForKey:@"item"] != nil) self.mItem = [dict objectForKey:@"item"];
    if([dict objectForKey:@"item_id"] != nil) self.mItemId = [dict objectForKey:@"item_id"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"location_key_code"] != nil) self.mLocationKeyCode = [dict objectForKey:@"location_key_code"];
    if([dict objectForKey:@"location_id"] != nil) self.mLocationId = [dict objectForKey:@"location_id"];
    
    
}

-(NSString*) getTaskText {
    if(self.mItem != nil && [self.mItem isEqualToString:@""]) return _mItem;
    else
        return _mLocation;
}
@end
