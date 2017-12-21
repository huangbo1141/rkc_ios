//
//  UserInfo.h
//  FitMusic
//
//  Created by BoHuang on 7/20/16.
//  Copyright © 2016 Jong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserInfo.h"
#import "InfoModel.h"
#import "LaboratoryInfoModel.h"
#import "ItemInfoModel.h"
#import "NotificationInfoModel.h"
#import "SettingModel.h"
#import "DeliveryInfoModel.h"
#import "TransportInfoModel.h"
#import "MenuInfoModel.h"
#import "UserModel.h"
#import <UIKit/UIKit.h>
#import <Intercom/Intercom.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) UserModel * mAccount;
@property (nonatomic, strong) InfoModel* mInfoStore;
@property (nonatomic, strong) LaboratoryInfoModel* mLaboratoryInfoStore;
@property (nonatomic, strong) ItemInfoModel* mItemInfoStore;
@property (nonatomic, strong) MenuInfoModel* mMenuInfoStore;
@property (nonatomic, strong) DeliveryInfoModel* mDeliveryInfoStore;
@property (nonatomic, strong) NotificationInfoModel* mNotificationInfoStore;
@property (nonatomic, strong) TransportInfoModel* mTransportInfoStore;
@property (nonatomic, strong) NSObject* captureObject;
@property (nonatomic, strong) NSObject* selectedObject;
@property (nonatomic, strong) NSMutableDictionary* printInfo;
@property (nonatomic, strong) NSString* currentLogic;
@property (nonatomic, strong) UIViewController* mSavedController;
@property (nonatomic, strong) NSString* mCurrentScreen;

@property (nonatomic, strong) NSString* mApnsToken;


+ (instancetype)shared;
-(void) loadDefaults;
-(void) setLogined:(bool)logined;
-(bool) getLogined;
-(void) setToken:(NSString*) token;
-(NSString*) getToken;
-(void) setSignatureSaved:(bool) isSaved;
-(bool) getSignatureSaved;
-(void) setDomain:(NSString*) domain;
-(NSString*) getDomain;
-(void) intercomUpdatePagePosition:(NSString*) pageTitle;

-(BOOL) intercomCreateUser;
-(void) intercomCreateEvent:(NSString*) title;

@end
