//
//  TransportInfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "TransportInfoModel.h"
#import "TransportModel.h"
#import "LocationModel.h"

@implementation TransportInfoModel
- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        self.mLocations = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    [self.mLocations removeAllObjects];
    [self.mLogs removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        for(NSDictionary* obj in logs) {
            TransportModel* logModel = [[TransportModel alloc] init];
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
    
}

@end
