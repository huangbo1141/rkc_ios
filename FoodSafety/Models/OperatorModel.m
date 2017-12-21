//
//  OperatorModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "OperatorModel.h"

@implementation OperatorModel
- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"username"] != nil) self.mFullName = [dict objectForKey:@"username"];
   
}
@end
