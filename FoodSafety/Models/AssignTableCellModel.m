//
//  AssignTableCellModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AssignTableCellModel.h"
#import "AssignModel.h"

@implementation AssignTableCellModel

- (id)init
{
    if((self = [super init])) {
        
        self.mAssigns = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString*) getTableCellText {
    if(self.mAssigns.count ==0)
        return @"";
    AssignModel* assign =[self.mAssigns objectAtIndex:0];
    return [assign getTaskText];
}
- (NSString*) getTableCellLocationKeyCode {
    if(self.mAssigns.count ==0)
        return @"";
    AssignModel* assign =[self.mAssigns objectAtIndex:0];
    return assign.mLocationKeyCode;
}
- (NSString*) getTableCellLocationId {
    if(self.mAssigns.count ==0)
        return @"";
    AssignModel* assign =[self.mAssigns objectAtIndex:0];
    return assign.mLocationId;
}
- (AssignModel*) getTableCellModel {
    if(self.mAssigns.count ==0)
        return @"";
    AssignModel* assign =[self.mAssigns objectAtIndex:0];
    return assign;
}
- (int) getTableCellIndex {
    int day =0;
    int time =1;
    if([self.mDay isEqualToString:@"sunday"]) day = 0;
    if([self.mDay isEqualToString:@"monday"]) day = 1;
    if([self.mDay isEqualToString:@"tuesday"]) day = 2;
    if([self.mDay isEqualToString:@"wednsday"]) day = 3;
    if([self.mDay isEqualToString:@"thursday"]) day = 4;
    if([self.mDay isEqualToString:@"friday"]) day = 5;
    if([self.mDay isEqualToString:@"saterday"]) day = 6;
    if([self.mTime isEqualToString:@"morning"]) time = 0;
    if([self.mTime isEqualToString:@"afternoon"]) time = 1;
    if([self.mTime isEqualToString:@"evening"])time =2;
    return day*3*time;
}
@end
