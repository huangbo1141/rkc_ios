//
//  SupplierModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "SupplierModel.h"

@implementation SupplierModel
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
    
}
@end
