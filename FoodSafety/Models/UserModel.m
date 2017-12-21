//
//  UserModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


- (id)init
{
    if((self = [super init])) {
        self.mPermissionModel= [[PermissionModel alloc] init];
        
    }
    return self;
}

-(BOOL) checkSignature {
    if(self.mSignature != nil && ![self.mSignature isKindOfClass:[NSNull class]] && ![self.mSignature isEqualToString:@""])
        return YES;
    return NO;

}
-(NSString*) getFullName {
    if(self.mFirstName == nil) self.mFirstName = @"";
    if(self.mLastName == nil) self.mLastName = @"";
    return [[self.mFirstName stringByAppendingString:@" "] stringByAppendingString:self.mLastName];
    
}

-(NSString*) getIntercomUserId:(NSString*) domain {
    
    if(domain == nil  || self.mUserKey == nil)
        return @"";
    else
        return [[domain stringByAppendingString:@"_"] stringByAppendingString:self.mUserKey];
}

@end
