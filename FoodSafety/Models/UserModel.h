//
//  UserModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermissionModel.h"
#import <UIKit/UIKit.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSString* mUserName;
@property (nonatomic, strong) NSString* mPassword;
@property (nonatomic, strong) PermissionModel* mPermissionModel;
@property (nonatomic, strong) NSString* mToken;
@property (nonatomic, strong) NSString* mAPNSToken;
@property (nonatomic, strong) NSString* mFirstName;
@property (nonatomic, strong) NSString* mLastName;
@property (nonatomic, strong) NSString* mEmail;
@property (nonatomic, strong) NSString* mPhoneNumber;
@property (nonatomic, strong) NSString* mAvatar;
@property (nonatomic, strong) NSString* mSignature;

@property (nonatomic, strong) NSString* mUserKey;
@property (nonatomic, strong) NSString* mRoleName;
@property (nonatomic, strong) NSString* mCompanyName;
@property (nonatomic, strong) NSString* mUserPosition;
@property (nonatomic, strong) NSString* mSignUpTime;


@property (nonatomic, strong) UIImage* mImage;

-(BOOL) checkSignature;
-(NSString*) getFullName;
-(NSString*) getIntercomUserId:(NSString*) domain;
@end
