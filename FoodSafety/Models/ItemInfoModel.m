//
//  ItemInfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ItemInfoModel.h"
#import "ItemModel.h"

@implementation ItemInfoModel

- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        self.mAllergens = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    [self.mAllergens removeAllObjects];
    [self.mLogs removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        for(NSDictionary* obj in logs) {
            ItemModel* logModel = [[ItemModel alloc] init];
            [logModel parse:obj];
            [self.mLogs addObject:logModel];
        }
    }
    
    if([dict objectForKey:@"allergens"] != nil) {
        NSArray* allergens = [dict objectForKey:@"allergens"];
        if([allergens isKindOfClass:[NSArray class]]) {
            for(NSDictionary* obj in allergens) {
                NSString* key = @"";
                NSString* value = @"";
                if([obj objectForKey:@"key"] != nil)
                    key = [obj objectForKey:@"key"];
                if([obj objectForKey:@"value"] != nil)
                    value = [obj objectForKey:@"value"];
                self.mAllergens[key] = value;
            }
        }

    }
    
}
@end
