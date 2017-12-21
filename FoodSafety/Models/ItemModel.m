//
//  ItemModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "Global.h"
#import "ItemModel.h"
#import "SettingModel.h"

@implementation ItemModel

- (id)init
{
    if((self = [super init])) {
        self.mId = @"";
        self.mName = @"";
        self.mBatch = @"";
        self.mCreateDate = @"";
        self.mExpireDate = @"";
        self.sortType = 0;
        self.isChecked = NO;
        self.mAllergens = [[NSMutableArray alloc] init];
    }
    return self;
}


-(NSString*) getExpireDate {
    if(self.mExpireDate == nil)
        return nil;
    return [[SettingModel shared] getSystemDateString:self.mExpireDate];
}
-(NSString*) getMysqlExpireDate {
    return self.mExpireDate;
}

-(void) setExpireDate:(NSString*) expireDate {
    self.mExpireDate = [[SettingModel shared] getMysqlDateString:expireDate];
}
-(NSString*) getCreateDate {
    if(self.mCreateDate == nil)
        return nil;
    return [[SettingModel shared] getSystemDateString: self.mCreateDate];
}
-(NSString*) getMysqlCreateDate {
    return self.mCreateDate;
}
-(void) setCreateDate:(NSString*) createDate {
    self.mCreateDate = [[SettingModel shared] getMysqlDateString:createDate];;
}
-(NSString*) getName {
    return self.mName;
}
-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    
    if([dict objectForKey:@"name"] != nil) self.mName = [dict objectForKey:@"name"];
    if([self.mName isKindOfClass:[NSNull class]])
        self.mName = nil;
    if([dict objectForKey:@"batch"] != nil) self.mBatch  = [dict objectForKey:@"batch"];

    if([dict objectForKey:@"batch_number"] != nil) self.mBatch  = [dict objectForKey:@"batch_number"];
    if([self.mBatch isKindOfClass:[NSNull class]])
        self.mBatch = nil;
    if([dict objectForKey:@"create_date"] != nil) self.mCreateDate  = [dict objectForKey:@"create_date"];
    if([self.mCreateDate isKindOfClass:[NSNull class]])
        self.mCreateDate = nil;
    if([dict objectForKey:@"expire_date"] != nil) self.mExpireDate  = [dict objectForKey:@"expire_date"];
    if([self.mExpireDate isKindOfClass:[NSNull class]])
        self.mExpireDate = nil;
    if([dict objectForKey:@"area_id"] != nil) self.mAreaId  = [dict objectForKey:@"area_id"];
    if([dict objectForKey:@"area_name"] != nil) self.mAreaName  = [dict objectForKey:@"area_name"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode  = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"creator"] != nil) self.mCreator  = [dict objectForKey:@"creator"];
    if([dict objectForKey:@"description"] != nil) self.mDescription  = [dict objectForKey:@"description"];
    if([self.mDescription isKindOfClass:[NSNull class]])
        self.mDescription = nil;
    if([dict objectForKey:@"allergens"] != nil) {
        NSString* allergenStr  = [dict objectForKey:@"allergens"];
        if(![allergenStr isKindOfClass:[NSNull class]]) {
            self.mAllergens = [[Global jsonToDict:allergenStr] mutableCopy];
        }
    }
    
}


@end
