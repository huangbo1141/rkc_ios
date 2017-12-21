//
//  DeliveryInfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "DeliveryInfoModel.h"
#import "DeliveryModel.h"
#import "SupplierModel.h"
@implementation DeliveryInfoModel
- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        self.mSuppliers = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    [self.mSuppliers removeAllObjects];
    [self.mLogs removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        for(NSDictionary* obj in logs) {
            DeliveryModel* logModel = [[DeliveryModel alloc] init];
            [logModel parse:obj];
            [self.mLogs addObject:logModel];
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
