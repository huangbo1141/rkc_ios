//
//  NotificationModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject

@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mKeyCode;

@property (nonatomic, strong) NSString* mTime;
@property (nonatomic, strong) NSString* mToUserId;
@property (nonatomic, strong) NSString* mFrom;
@property (nonatomic, strong) NSString* mFromUserId;
@property (nonatomic, strong) NSString* mMessage;
@property (nonatomic, strong) NSString* mLink;
@property (nonatomic, strong) NSString* mLocation;
@property (nonatomic, strong) NSString* mIsRead;


-(NSString*) getTime;
-(NSString*) getMysqlTime;

-(void) setTime:(NSString*) time;
-(void) setMysqlTime:(NSString*) time;

-(void) parse:(NSDictionary*) dict;

@end
