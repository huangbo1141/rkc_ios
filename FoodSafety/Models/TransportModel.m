//
//  TransportModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "TransportModel.h"
#import "SettingModel.h"

@implementation TransportModel
- (id)init
{
    if((self = [super init])) {
        
        
    }
    return self;
}
-(NSString*) getDepartureTime {
    if(self.mDepartureTime == nil)
        return nil;
    return [[SettingModel shared] getSystemTimeString:self.mDepartureTime];
}
-(NSString*) getMysqlDepartureTime {
    return self.mDepartureTime;
}
-(void) setDepartureTime :(NSString*) departureTime {
    self.mDepartureTime = [[SettingModel shared] getMysqlTimeString:departureTime];
}

-(void) setMysqlDepartureTime :(NSString*) departureTime {
    self.mDepartureTime = departureTime;
}

-(NSString*) getArrivalTime {
    if(self.mArrivalTime == nil)
        return nil;
    return [[SettingModel shared] getSystemTimeString:self.mArrivalTime];
}
-(NSString*) getMysqlArrivalTime {
    return self.mArrivalTime;
}
-(void) setArrivalTime :(NSString*) arrivalTime {
    self.mArrivalTime = [[SettingModel shared] getMysqlTimeString:arrivalTime];
}

-(void) setMysqlArrivalTime :(NSString*) arrivalTime {
        self.mArrivalTime = arrivalTime;
}

-(NSString*) getDepartureDate {
    if(self.mDepartureDate == nil)
        return nil;
    return [[SettingModel shared] getSystemDateString:self.mDepartureDate];
}
-(NSString*) getMysqlDepartureDate {
    return self.mDepartureDate;
}
-(void) setMysqlDepartureDate :(NSString*) departureDate {
    self.mDepartureDate = departureDate;
}
-(void) setDepartureDate :(NSString*) departureDate {
    self.mDepartureDate = [[SettingModel shared] getMysqlDateString:departureDate];
}


-(NSString*) getArrivalDate {
    if(self.mDepartureDate == nil)
        return nil;
    return [[SettingModel shared] getSystemDateString:self.mArrivalDate];
}

-(NSString*) getMysqlArrivalDate {
    return self.mArrivalDate;
}
-(void) setMysqlArrivalDate :(NSString*) arrivalDate {
    self.mArrivalDate = arrivalDate;
}
-(void) setArrivalDate:(NSString*) arrivalDate {
    self.mArrivalDate = [[SettingModel shared] getMysqlDateString:arrivalDate];

}

-(NSString*) getUpdateTime {
    if(self.mUpdateTime == nil)
        return nil;
    return [[SettingModel shared] getSystemDatetimeString:self.mUpdateTime];
}
-(void) setUpdateTime:(NSString*) updateTime {
    
    self.mUpdateTime = updateTime;
}

-(void) parse:(NSDictionary*) dict {
    if (self) {
        if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
        
        if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
        if([self.mKeyCode isKindOfClass:[NSNull class]]) self.mKeyCode = nil;
        
        if([dict objectForKey:@"item"] != nil) self.mItem = [dict objectForKey:@"item"];
        if([self.mItem isKindOfClass:[NSNull class]]) self.mItem = nil;
        
        if([dict objectForKey:@"number"] != nil) self.mNumber = [dict objectForKey:@"number"];
        if([self.mItem isKindOfClass:[NSNull class]]) self.mNumber = nil;
       
        if([dict objectForKey:@"departure_operator"] != nil) self.mDepartureOpertator = [dict objectForKey:@"departure_operator"];
        if([self.mDepartureOpertator isKindOfClass:[NSNull class]]) self.mDepartureOpertator = nil;
        
        if([dict objectForKey:@"departure_area"] != nil) self.mDepartureArea = [dict objectForKey:@"departure_area"];
        if([self.mDepartureArea isKindOfClass:[NSNull class]]) self.mDepartureArea = nil;
        
        if([dict objectForKey:@"departure_date"] != nil) self.mDepartureDate = [dict objectForKey:@"departure_date"];
        if([self.mDepartureDate isKindOfClass:[NSNull class]]) self.mDepartureDate = nil;
        
        if([dict objectForKey:@"departure_time"] != nil) self.mDepartureTime = [dict objectForKey:@"departure_time"];
        if([self.mDepartureTime isKindOfClass:[NSNull class]]) self.mDepartureTime = nil;
        
        if([dict objectForKey:@"departure_temp"] != nil) self.mDepartureTemp = [dict objectForKey:@"departure_temp"];
        if([self.mDepartureTemp isKindOfClass:[NSNull class]]) self.mDepartureTemp = nil;
        
        if([dict objectForKey:@"departure_operator_first_name"] != nil) self.mDepartureOperatorFirstName = [dict objectForKey:@"departure_operator_first_name"];
        if([self.mDepartureOperatorFirstName isKindOfClass:[NSNull class]]) self.mDepartureOperatorFirstName = nil;
        
        
        if([dict objectForKey:@"departure_operator_last_name"] != nil) self.mDepartureOperatorLastName = [dict objectForKey:@"departure_operator_last_name"];
        if([self.mDepartureOperatorLastName isKindOfClass:[NSNull class]]) self.mDepartureOperatorLastName = nil;
        
        if([dict objectForKey:@"departure_area_name"] != nil) self.mDepartureAreaName = [dict objectForKey:@"departure_area_name"];
        if([self.mDepartureAreaName isKindOfClass:[NSNull class]]) self.mDepartureAreaName = nil;
        
        if([dict objectForKey:@"departure_good_file"] != nil) self.mDepartureGoodFile = [dict objectForKey:@"departure_good_file"];
        if([self.mDepartureGoodFile isKindOfClass:[NSNull class]]) self.mDepartureGoodFile = nil;
        
        if([dict objectForKey:@"departure_invoice_file"] != nil) self.mDepartureInvoiceFile = [dict objectForKey:@"departure_invoice_file"];
        if([self.mDepartureInvoiceFile isKindOfClass:[NSNull class]]) self.mDepartureInvoiceFile = nil;
        
        if([dict objectForKey:@"departure_comment"] != nil) self.mArrivalOperator = [dict objectForKey:@"departure_comment"];
        if([self.mArrivalOperator isKindOfClass:[NSNull class]]) self.mArrivalOperator = nil;
        
        
        if([dict objectForKey:@"arrival_operator"] != nil) self.mDepartureComment = [dict objectForKey:@"arrival_operator"];
        if([self.mDepartureComment isKindOfClass:[NSNull class]]) self.mDepartureComment = nil;
        
        
        if([dict objectForKey:@"arrival_area"] != nil) self.mArrivalArea = [dict objectForKey:@"arrival_area"];
        if([self.mArrivalArea isKindOfClass:[NSNull class]]) self.mArrivalArea = nil;
        
        if([dict objectForKey:@"arrival_date"] != nil) self.mArrivalDate = [dict objectForKey:@"arrival_date"];
        if([self.mArrivalDate isKindOfClass:[NSNull class]]) self.mArrivalDate = nil;
        
        if([dict objectForKey:@"arrival_temp"] != nil) self.mArrivalTemp = [dict objectForKey:@"arrival_temp"];
        if([self.mArrivalTemp isKindOfClass:[NSNull class]]) self.mArrivalTemp = nil;
        
        if([dict objectForKey:@"arrival_time"] != nil) self.mArrivalTime = [dict objectForKey:@"arrival_time"];
        if([self.mArrivalTime isKindOfClass:[NSNull class]]) self.mArrivalTime = nil;
        
        if([dict objectForKey:@"arrival_comment"] != nil) self.mArrivalComment = [dict objectForKey:@"arrival_comment"];
        if([self.mArrivalComment isKindOfClass:[NSNull class]]) self.mArrivalComment = nil;
        
        
        
        if([dict objectForKey:@"status"] != nil) self.mStatus = [dict objectForKey:@"status"];
        if([self.mStatus isKindOfClass:[NSNull class]]) self.mStatus = nil;
        
        if([dict objectForKey:@"arrival_operator_first_name"] != nil) self.mArrivalOperatorFirstName = [dict objectForKey:@"arrival_operator_first_name"];
        if([self.mArrivalOperatorFirstName isKindOfClass:[NSNull class]]) self.mArrivalOperatorFirstName = nil;
        
        if([dict objectForKey:@"arrival_operator_last_name"] != nil) self.mArrivalOperatorLastName = [dict objectForKey:@"arrival_operator_last_name"];
        if([self.mArrivalOperatorLastName isKindOfClass:[NSNull class]]) self.mArrivalOperatorLastName = nil;
        
        if([dict objectForKey:@"arrival_invoice_file"] != nil) self.mArrivalInvoiceFile = [dict objectForKey:@"arrival_invoice_file"];
        if([self.mArrivalInvoiceFile isKindOfClass:[NSNull class]]) self.mArrivalInvoiceFile = nil;
        
        if([dict objectForKey:@"arrival_good_file"] != nil) self.mArrivalGoodFile = [dict objectForKey:@"arrival_good_file"];
        if([self.mArrivalGoodFile isKindOfClass:[NSNull class]]) self.mArrivalGoodFile = nil;
        
        if([dict objectForKey:@"arrival_area_name"] != nil) self.mArrivalAreaName = [dict objectForKey:@"arrival_area_name"];
        if([self.mArrivalAreaName isKindOfClass:[NSNull class]]) self.mArrivalAreaName = nil;
        
        if([dict objectForKey:@"item_name"] != nil) self.mItemName = [dict objectForKey:@"item_name"];
        if([self.mItemName isKindOfClass:[NSNull class]]) self.mItemName = nil;
        
        if([dict objectForKey:@"update_time"] != nil) self.mUpdateTime = [dict objectForKey:@"update_time"];
        if([self.mUpdateTime isKindOfClass:[NSNull class]]) self.mUpdateTime = nil;
        
        
    }
}


-(BOOL) isDeparture {
    if(self.mStatus == nil)
        return true;
    return false;
}
-(BOOL) isComplete {
    if(self.mStatus == nil)
        return true;
    if([self.mStatus isEqualToString:@"0"])
        return false;
    else
        return true;
}
@end
