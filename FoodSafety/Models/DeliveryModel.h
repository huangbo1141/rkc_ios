//
//  TransportModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelModel.h"

@interface DeliveryModel : NSObject
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mOperator;
@property (nonatomic, strong) NSString* mSupplier;
@property (nonatomic, strong) NSString* mNumber;
@property (nonatomic, strong) NSString* mAcceptDatetime;
@property (nonatomic, strong) NSString* mTemperature;
@property (nonatomic, strong) NSString* mTempAccept;
@property (nonatomic, strong) NSString* mCondAccept;
@property (nonatomic, strong) NSString* mDateAccept;
@property (nonatomic, strong) NSString* mAspectAccept;
@property (nonatomic, strong) NSString* mQualityAccept;
@property (nonatomic, strong) NSString* mComment;
@property (nonatomic, strong) NSString* mStatus;
@property (nonatomic, strong) NSString* mBigFile;
@property (nonatomic, strong) NSString* mThumbFile;
@property (nonatomic, strong) NSString* mSupplierName;
@property (nonatomic, strong) NSString* mOperatorFirstName;
@property (nonatomic, strong) NSString* mOperatorLastName;
@property (nonatomic, strong) UIImage* mImage;

@property (nonatomic, strong) NSMutableArray<NSString*>* mGoodTypes;
@property (nonatomic, strong) NSMutableArray<LabelModel*>* mLabels;


-(NSString*) getAcceptDatetime;
-(NSString*) getMysqlAcceptDatetime;
-(void) setAcceptDatetime :(NSString*) acceptDatetime;
-(void) setMysqlAcceptDatetime :(NSString*) acceptDatetime;
-(void) parse:(NSDictionary*) dict;

-(NSString*) getOperatorName;
-(NSString*) getItemsWithComma;
-(NSString*) getItemsJson;
-(NSString*) getGoodType:(NSString*) type;
@end
