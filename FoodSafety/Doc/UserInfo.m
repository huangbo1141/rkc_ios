//
//  UserInfo.m
//  FitMusic
//
//  Created by BoHuang on 7/20/16.
//  Copyright © 2016 Jong. All rights reserved.
//


#import "UserInfo.h"
#import "macros.h"

//Userdefault Keys

static NSString * kDefaultLoginedKey = @"LOGINSTATE";
static NSString * kDefaultUserId = @"USERID";
static NSString * kDefaultSignatureSaved = @"SIGNATURESAVED";
static NSString * kDefaultToken = @"Token";
static NSString * kDefaultDomain = @"Domain";
@implementation UserInfo

+ (instancetype)shared
{
    static UserInfo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserInfo alloc] init];
        
    });
    
    return sharedInstance;
}

-(id) init{
    self = [super init];
    if(self != nil)
    {
        self.mAccount = [[UserModel alloc] init];
        [self loadDefaults];
     
    }
    return self;
}
-(void) logOut
{
    [self setLogined:false];
}

- (void)saveDefaults:(NSString *)key value:(id)obj
{
    if (obj != nil)
       UDSetValue(key, obj);
    else
       UDRemove(key);
       UDSync();
}

-(void) loadDefaults
{
}

-(void) setLogined:(bool)logined
{
    
    UDSetBool(kDefaultLoginedKey, logined);
    UDSync();
    if(!logined) {
        [Intercom reset];
    }
    
}

-(bool) getLogined {
    return UDBool(kDefaultLoginedKey);
}
-(void) setSignatureSaved:(bool) isSaved
{
    UDSetBool(kDefaultSignatureSaved, isSaved);
    UDSync();
}
-(bool) getSignatureSaved
{
    return UDBool(kDefaultSignatureSaved);
}
-(NSString*) getToken{
    return UDValue(kDefaultToken);
}

-(void) setToken:(NSString*) token{
    UDSetValue(kDefaultToken, token);
    UDSync();
}

-(void) setDomain:(NSString*) domain {
    UDSetValue(kDefaultDomain, domain);
    UDSync();
}
-(NSString*) getDomain {
    return UDValue(kDefaultDomain);
}
-(void) intercomUpdatePagePosition:(NSString*) pageTitle {
    ICMUserAttributes *userAttributes = [ICMUserAttributes new];
    NSMutableDictionary* customAttrs = [[NSMutableDictionary alloc] init];

    customAttrs[@"latest_access_page"] = pageTitle;
    //userAttributes.userId
    userAttributes.email = self.mAccount.mEmail;
    NSString* domain = [[UserInfo shared] getDomain];
    userAttributes.userId = [self.mAccount getIntercomUserId: domain];
    userAttributes.customAttributes = customAttrs;
    [Intercom updateUser:userAttributes];
}

-(BOOL) intercomCreateUser {
    if(self.mAccount.mEmail != nil) {
        [Intercom reset];
        NSString* domain = [[UserInfo shared] getDomain];
        [Intercom registerUserWithUserId:[self.mAccount getIntercomUserId:domain]];
        ICMCompany *company = [ICMCompany new];
        company.name = self.mAccount.mCompanyName;
        company.companyId = [[UserInfo shared] getDomain];
        NSMutableDictionary* customAttrs = [[NSMutableDictionary alloc] init];
        if(self.mAccount.mUserPosition != nil && ![self.mAccount.mUserPosition isEqualToString:@""]) {
            customAttrs[@"user_position"] = self.mAccount.mUserPosition;
        }
        if(self.mAccount.mRoleName != nil && ![self.mAccount.mRoleName isEqualToString:@""]) {
            customAttrs[@"user_role"] = self.mAccount.mRoleName;
        }
        if(self.mAccount.mSignUpTime != nil) {
            customAttrs[@"sign_up_time"] = self.mAccount.mSignUpTime;
        }
        ICMUserAttributes *userAttributes = [ICMUserAttributes new];
        userAttributes.companies = @[company];
        userAttributes.userId = [self.mAccount getIntercomUserId: domain];
        userAttributes.name=  [self.mAccount getFullName];
        userAttributes.email = self.mAccount.mEmail;
        userAttributes.customAttributes = customAttrs;
        [Intercom updateUser:userAttributes];
        return YES;
    }
    return NO;
}

-(void) intercomCreateEvent:(NSString*) title {
    [Intercom logEventWithName:title];
}

@end
