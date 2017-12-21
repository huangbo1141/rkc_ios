//
//  DeliveryMenuModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "DeliveryMenuModel.h"
#import "SettingModel.h"
#import "ItemModel.h"
#import "LabelModel.h"
#import "Global.h"
#import "Language.h"
@implementation DeliveryMenuModel
- (id)init
{
    if((self = [super init])) {
        self.mTimeTypes = [[NSMutableArray alloc] init];
        self.mLabels = [[NSMutableArray alloc] init];
        self.mItemModels = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void) parse:(NSDictionary*) dict {
    if([dict objectForKey:@"id"] != nil) self.mId = [dict objectForKey:@"id"];
    if([dict objectForKey:@"key_code"] != nil) self.mKeyCode = [dict objectForKey:@"key_code"];
    if([dict objectForKey:@"title"] != nil) self.mTitle = [dict objectForKey:@"title"];
    
    if([dict objectForKey:@"log_time"] != nil) self.mLogTime = [dict objectForKey:@"log_time"];
    if([dict objectForKey:@"location"] != nil) self.mLocation = [dict objectForKey:@"location"];
    if([dict objectForKey:@"items"] != nil) self.mItems = [dict objectForKey:@"items"];
    if([dict objectForKey:@"lname"] != nil) self.mLocationName = [dict objectForKey:@"lname"];
    if([dict objectForKey:@"update_time"] != nil) self.mUpdateTime = [dict objectForKey:@"update_time"];
    if([dict objectForKey:@"log_date"] != nil) self.mLogDate = [dict objectForKey:@"log_date"];
}


-(NSString*) getAllergensString {
    NSMutableArray* mAllergens = [[NSMutableArray alloc] init];
    for(ItemModel* model in _mItemModels) {
        for(NSString* allergen in model.mAllergens) {
            BOOL isNew = YES;
            for(NSString* myAllergen in mAllergens){
                if([allergen isEqualToString:myAllergen])
                    isNew = NO;
            }
            if(isNew)
                [mAllergens addObject:allergen];
        }
        
    }
    NSString* result = @"";
    for(NSString* allergen in mAllergens) {
        
        [[result stringByAppendingString:[self getAllergenName:allergen]]stringByAppendingString:@", "];
    }
    if(result.length >2)
        result = [result substringToIndex:result.length-2];
    
    return result;
 }

-(NSString*) getAllergenName:(NSString*) value {
    return kLang(value);
}

-(void) setDate:(NSString*) date {
    self.mLogDate = [[SettingModel shared] getMysqlDateString:date];
}
-(NSString*) getDate {
    if(self.mLogDate == nil)
        return nil;
    return [[SettingModel shared] getSystemTimeString:self.mLogDate];
}

-(NSString*) getItemsJson {
    NSMutableArray* mArr =  [[NSMutableArray alloc] init];
    for(ItemModel* item in self.mItemModels) {
        [mArr addObject:item.mId];
    }
    
    NSString*  json =  [Global dictToJson:(NSDictionary *) mArr];
    return json;
}
-(void) parseLogTime:(NSString*) jsonString {
    self.mTimeTypes = [[Global jsonToDict:jsonString] mutableCopy];
}
-(NSString*) getLogTimeJson {
    return [Global dictToJson: (NSDictionary*)self.mTimeTypes];
}
-(NSString*) getLogTimeUserFriendly {
    
    NSString* str = @"";
    for(NSString* timeType in self.mTimeTypes) {
        str = [str stringByAppendingString:timeType];
        str = [str stringByAppendingString:@", "];
        
    }

    if(self.mTimeTypes.count > 0) {
        NSString* timeType = [self.mTimeTypes objectAtIndex:self.mTimeTypes.count-1];
        str = [str stringByAppendingString:timeType];
    }
    return str;
}
-(NSString*) getLabelsJson {
    NSMutableArray* dict = [[NSMutableArray alloc] init];
    
    for(LabelModel* model in self.mLabels){
        [dict addObject:model.mId];
    }
    return [Global dictToJson:dict];
}
-(NSString*) getMysqlLogDate {
    return self.mLogDate;
}
@end
