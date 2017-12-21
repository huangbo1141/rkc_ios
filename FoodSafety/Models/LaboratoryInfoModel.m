//
//  LaboratoryInfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LaboratoryInfoModel.h"
#import "LaboratoryModel.h"
#import "OperatorModel.h"

@implementation LaboratoryInfoModel
- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        self.mOperators = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    [self.mOperators removeAllObjects];
    [self.mLogs removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        for(NSDictionary* obj in logs) {
            LaboratoryModel* logModel = [[LaboratoryModel alloc] init];
            [logModel parse:obj];
            [self.mLogs addObject:logModel];
        }
    }
    
    if([dict objectForKey:@"operators"] != nil) {
        NSArray* operators = [dict objectForKey:@"operators"];
        for(NSDictionary* obj in operators) {
            OperatorModel* operatorModel = [[OperatorModel alloc] init];
            [operatorModel parse:obj];
            [self.mOperators addObject:operatorModel];
        }
    }
    
}
@end
