//
//  TraceabilityModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "DeliveryModel.h"
#import "SettingModel.h"
#import "Global.h"

@implementation DeliveryModel

- (id)init
{
    if((self = [super init])) {
        self.mGoodTypes = [[NSMutableArray alloc] init];
        self.mLabels = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(NSString*) getAcceptDatetime {
    if(self.mAcceptDatetime == nil)
        return nil;
    return [[SettingModel shared] getSystemDatetimeString:self.mAcceptDatetime];
}

-(NSString*) getMysqlAcceptDatetime {
    return self.mAcceptDatetime;
}

-(void) setAcceptDatetime:(NSString *)acceptDatetime{
    self.mAcceptDatetime = [[SettingModel shared] getMysqlTimeString:acceptDatetime];
}

-(void) setMysqlAcceptDatetime :(NSString*) acceptDatetime {
    self.mAcceptDatetime = acceptDatetime;
}
-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"item"] != nil) {
        NSString* item = [dict objectForKey:@"item"];
        self.mGoodTypes = [[Global jsonToDict:item] mutableCopy];
    }
    
    if([dict objectForKey:@"operator"] != nil) self.mOperator = [dict objectForKey:@"operator"];
    if([dict objectForKey:@"supplier"] != nil) self.mSupplier = [dict objectForKey:@"supplier"];
    if([dict objectForKey:@"number"] != nil) self.mNumber = [dict objectForKey:@"number"];
    if([dict objectForKey:@"accept_datetime"] != nil) self.mAcceptDatetime = [dict objectForKey:@"accept_datetime"];
    if([dict objectForKey:@"temperature"] != nil) self.mTemperature = [dict objectForKey:@"temperature"];
    if([dict objectForKey:@"temp_accept"] != nil) self.mTempAccept = [dict objectForKey:@"temp_accept"];
    if([dict objectForKey:@"cond_accept"] != nil) self.mCondAccept = [dict objectForKey:@"cond_accept"];
    if([dict objectForKey:@"date_accept"] != nil) self.mDateAccept = [dict objectForKey:@"date_accept"];
    if([dict objectForKey:@"aspect_accept"] != nil) self.mAspectAccept = [dict objectForKey:@"aspect_accept"];
    if([dict objectForKey:@"quality_accept"] != nil) self.mQualityAccept = [dict objectForKey:@"quality_accept"];
    if([dict objectForKey:@"comment"] != nil) self.mComment = [dict objectForKey:@"comment"];
    if([dict objectForKey:@"status"] != nil) self.mStatus = [dict objectForKey:@"status"];
    if([dict objectForKey:@"big_file"] != nil) self.mBigFile = [dict objectForKey:@"big_file"];
    if([dict objectForKey:@"thumb_file"] != nil) self.mThumbFile = [dict objectForKey:@"thumb_file"];
    if([dict objectForKey:@"supplier_name"] != nil) self.mSupplierName = [dict objectForKey:@"supplier_name"];
    if([dict objectForKey:@"operator_first_name"] != nil) self.mOperatorFirstName = [dict objectForKey:@"operator_first_name"];
    if([dict objectForKey:@"operator_last_name"] != nil) self.mOperatorLastName = [dict objectForKey:@"operator_last_name"];
    
}

-(NSString*) getOperatorName {
    if(self.mOperatorFirstName == nil) _mOperatorFirstName = @"";
    if(self.mOperatorLastName == nil) _mOperatorLastName = @"";
    return [[self.mOperatorFirstName stringByAppendingString:@" "] stringByAppendingString:self.mOperatorLastName];
}
-(NSString*) getItemsWithComma {
    NSString* str = @"";
    for(int i=0; i<self.mGoodTypes.count-1; i++) {
        NSString* goodType = [self getGoodType: [self.mGoodTypes  objectAtIndex:i]];
        str = [str stringByAppendingString:goodType];
        str = [str stringByAppendingString:@", "];
    }
    if(self.mGoodTypes.count > 0) {
        NSString* goodType = [self getGoodType: [self.mGoodTypes  objectAtIndex: self.mGoodTypes.count -1]];
        str = [str stringByAppendingString:goodType];
    }
    return str;
    
}
-(NSString*) getItemsJson {
    return [Global dictToJson:(NSDictionary*)self.mGoodTypes];
}

-(NSString*) getGoodType:(NSString*) type {
    if([type isEqualToString:@"fresh_goods"]) return @"Fresh Goods";
    if([type isEqualToString:@"frozen_goods"]) return @"Frozen Goods";
    if([type isEqualToString:@"dry_goods"]) return @"Dry Goods";
    if([type isEqualToString:@"miscalleneous"]) return @"Miscalleneous";
    return @"";
    
}

@end
