//
//  PermissionModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "PermissionModel.h"

@implementation PermissionModel
- (id)init
{
    if((self = [super init])) {
        self.mPermissionMap  = [[NSMutableDictionary  alloc] init];
    }
    return self;
}

-(void) parse:(NSDictionary*) dict {
    NSArray* menus =  dict.allKeys;
    
    for(NSString* menu in menus) {
        NSDictionary* menuDict = [dict objectForKey:menu];
        NSArray* categories = menuDict.allKeys;
        for(NSString* category in categories) {
            NSDictionary* categoryDict = [dict objectForKey:category];
            for(NSString* function in categoryDict) {
                NSString* permissionKey = @"";
                permissionKey = [[[permissionKey stringByAppendingString:menu] stringByAppendingString:category] stringByAppendingString:function];
            }
        }
    }
}

-(void) allowAllPermissions {
    self.mFullAccess = YES;
}
-(BOOL) checkPermission:(NSString*)menu withCategory:(NSString*)category withFunction:(NSString*) function {

    if(self.mFullAccess) return YES;
    NSString* permissionKey = @"";
    permissionKey = [[[permissionKey stringByAppendingString:menu] stringByAppendingString:category] stringByAppendingString:function];
    if([self.mPermissionMap objectForKey:permissionKey] == nil)
        return NO;
    else
        return YES;
}

@end
