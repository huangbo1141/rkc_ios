//
//  AssignTaskModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AssignTaskModel.h"
#import "Language.h"

@implementation AssignTaskModel
- (id)init
{
    if((self = [super init])) {
        
        self.mParams = [[NSMutableDictionary alloc] init];
    }
    
    
    return self;
}

- (void) setItemType:(BOOL) isSection withTaskType:(NSString*) taskType{
    self.mTaskType = taskType;
    if(isSection){
        self.mItemType =@"section";
        self.mParams[@"section_title"] = [self getSectionTitle: taskType];
    }else {
        self.mItemType = @"item";
    }
}
- (NSString*) getSectionTitle {
    if([self.mItemType isEqualToString:@"section"])
        return [self.mParams objectForKey:@"section_title"];
    else
        return @"";
}

- (void) parse:(NSString*) taskType withDict:(NSDictionary*) dict{
    self.mTaskType = taskType;
    self.mItemType   = @"item";
    NSArray* keys = dict.allKeys;
    for(NSString* key in keys) {
        NSString* value = [dict objectForKey:key];
        self.mParams[key] = value;
    }
    
}
- (NSString*) getSectionTitle:(NSString*) taskType {
    if([taskType isEqualToString:@"fridge"])
        return kLang(@"fridge_assign");
    else if([taskType isEqualToString:@"freezer"])
        return kLang(@"freeezer_assign");
    else if([taskType isEqualToString:@"oil"])
        return kLang(@"oil_assign");
    else if([taskType isEqualToString:@"cleaning"])
        return kLang(@"clean_assign");
    else if([taskType isEqualToString:@"expire"])
        return kLang(@"expired_assign");
    else
        return @"Other";
    
}
- (NSString*) getLogoImageName {
    if([self.mTaskType isEqualToString:@"fridge"])
        return @"ic_fridge";
    else if([self.mTaskType isEqualToString:@"freezer"])
        return @"ic_freeze";
    else if([self.mTaskType isEqualToString:@"oil"])
        return @"ic_oil";
    else if([self.mTaskType isEqualToString:@"cleaning"])
        return @"ic_cleaning";
    else if([self.mTaskType isEqualToString:@"expire"])
        return @"ic_expire";
    else
        return @"ic_expire";
    
}
@end
