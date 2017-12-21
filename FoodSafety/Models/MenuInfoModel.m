//
//  MenuInfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "MenuInfoModel.h"
#import "DeliveryMenuModel.h"
#import "LocationModel.h"
#import "SupplierModel.h"
@implementation MenuInfoModel
- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        self.mLocations = [[NSMutableArray alloc] init];
        self.mSuppliers = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    [self.mLocations removeAllObjects];
    [self.mLogs removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        for(NSDictionary* obj in logs) {
            DeliveryMenuModel* logModel = [[DeliveryMenuModel alloc] init];
            [logModel parse:obj];
            [self.mLogs addObject:logModel];
        }
    }
    
    if([dict objectForKey:@"locations"] != nil) {
        NSArray* locations = [dict objectForKey:@"locations"];
        for(NSDictionary* obj in locations) {
            LocationModel* locationModel = [[LocationModel alloc] init];
            [locationModel parse:obj];
            [self.mLocations addObject:locationModel];
        }
    }
    
    if([dict objectForKey:@"suppliers"] != nil) {
        NSArray* suppliers = [dict objectForKey:@"suppliers"];
        for(NSDictionary* obj in suppliers) {
            SupplierModel* supplierModel = [[SupplierModel alloc] init];
            [supplierModel parse:obj];
            [self.mSuppliers addObject:supplierModel];
        }
    }
}

@end
