//
//  NotificationInfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NotificationInfoModel.h"
#import "NotificationModel.h"
@implementation NotificationInfoModel

- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        
    }
    return self;
}
-(void) parse:(NSDictionary*) dict {

    [self.mLogs removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        for(NSDictionary* obj in logs) {
            NotificationModel* logModel = [[NotificationModel alloc] init];
            [logModel parse:obj];
            [self.mLogs addObject:logModel];
        }
    }
    
 }
@end
