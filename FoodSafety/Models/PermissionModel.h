//
//  PermissionModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionModel : NSObject
@property (nonatomic, strong) NSDictionary* mPermissionMap;
@property (nonatomic, assign) BOOL mFullAccess;

-(void) parse:(NSDictionary*) dict;
-(void) allowAllPermissions;
-(BOOL) checkPermission:(NSString*)menu withCategory:(NSString*)category withFunction:(NSString*) function;
@end
