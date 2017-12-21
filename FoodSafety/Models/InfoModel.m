//
//  InfoModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "InfoModel.h"
#import "LogModel.h"
#import "LocationModel.h"
#import "AssignModel.h"
#import "CalendarAssignModel.h"
#import "AssignTableCellModel.h"

@implementation InfoModel

- (id)init
{
    if((self = [super init])) {
        self.mLogs = [[NSMutableArray alloc] init];
        self.mAssigns = [[NSMutableArray alloc] init];
        self.mLocations = [[NSMutableArray alloc] init];
        self.mCalendarAssigns = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) parse:(NSDictionary*) dict {
    
    [self.mLogs removeAllObjects];
    [self.mLocations removeAllObjects];
    if([dict objectForKey:@"logs"] != nil) {
        NSArray* logs = [dict objectForKey:@"logs"];
        if([logs isKindOfClass:[NSArray class]]) {
            for(NSDictionary* obj in logs) {
                LogModel* logModel = [[LogModel alloc] init];
                [logModel parse:obj];
                [self.mLogs addObject:logModel];
            }
        }

    }
    if([dict objectForKey:@"assigns"] != nil) {
        NSDictionary* assigns = [dict objectForKey:@"assigns"];
        if([assigns isKindOfClass:[NSDictionary class]]) {
            for(NSString* day in assigns.allKeys) {
                NSDictionary* dayData = [assigns objectForKey:day];
                for(NSString* time in dayData.allKeys) {
                    NSDictionary* taskData =[dayData objectForKey:time];
                    AssignTableCellModel* model = [[AssignTableCellModel alloc] init];
                    model.mDay = day;
                    model.mTime = time;
                    for(NSString* keyCode in taskData.allKeys){
                        NSDictionary* assignData = [taskData objectForKey:keyCode];
                        AssignModel* assignModel = [[AssignModel alloc] init];
                        [assignModel parse:keyCode withDict:assignData];
                        [model.mAssigns addObject:assignModel];
                    }
                    [self.mAssigns addObject:model];
                }
            }
        }
        
    }
    [self.mLocations removeAllObjects];
    if([dict objectForKey:@"locations"] != nil) {
        NSArray* locations = [dict objectForKey:@"locations"];
        if([locations isKindOfClass:[NSArray class]]) {
            for(NSDictionary* obj in locations) {
                LocationModel* locationModel = [[LocationModel alloc] init];
                [locationModel parse:obj];
                [self.mLocations addObject:locationModel];
            }
        }
    }
    
    
    

    if([dict objectForKey:@"calendar_assigns"] != nil) {
        NSArray* cAssigns = [dict objectForKey:@"calendar_assigns"];
        if([cAssigns isKindOfClass:[NSArray class]]) {
            for(NSDictionary* obj in cAssigns) {
                CalendarAssignModel* model = [[CalendarAssignModel alloc] init];
                [model parse:obj];
                [self.mCalendarAssigns addObject:model];
            }
        }

    }
    
    
    
}
-(int) getLocationIndexById:(NSString*) locationId {
    int i=0;
    for(LocationModel* locationModel in self.mLocations) {
        if([locationModel.mId isEqualToString:locationId]) {
            return i;
        }
        i++;
    }
    return 0;
}
@end
