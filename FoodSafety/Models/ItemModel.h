//
//  ItemModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mName;
@property (nonatomic, strong) NSString* mBatch;
@property (nonatomic, strong) NSString* mCreateDate;
@property (nonatomic, strong) NSString* mExpireDate;
@property (nonatomic, strong) NSString* mAreaId;
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mCreator;
@property (nonatomic, strong) NSString* mDescription;
@property (nonatomic, strong) NSString* mAlergenString;
@property (nonatomic, strong) NSMutableArray* mAllergens;
@property (nonatomic, strong) NSString* mAreaName;
@property (nonatomic, assign) int sortType;
@property (nonatomic, assign) BOOL isChecked;


-(NSString*) getExpireDate;
-(NSString*) getMysqlExpireDate;

-(void) setExpireDate:(NSString*) expireDate;
-(NSString*) getCreateDate;
-(NSString*) getMysqlCreateDate;
-(void) setCreateDate:(NSString*) createDate;
-(NSString*) getName;
-(void) parse:(NSDictionary*) dict;
@end
