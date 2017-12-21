//
//  LaboratoryModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaboratoryModel : NSObject
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mOperatorId;
@property (nonatomic, strong) NSString* mLogDate;
@property (nonatomic, strong) NSString* mTitle;
@property (nonatomic, strong) NSString* mComment;
@property (nonatomic, strong) NSString* mUpdateTime;
@property (nonatomic, strong) NSString* mOperatorName;
@property (nonatomic, strong) NSString* mFileName;

-(void) parse:(NSDictionary*) dict;
-(NSString*) getLogDate;
-(NSString*) getMysqlLogDate;
-(void) setLogDate:(NSString*) logDate;
-(void) setMysqlLogDate:(NSString*) logDate;
-(NSString*) getUpdateTime;
-(void) setMysqlUpdateTime:(NSString*) updateTime;

@end
