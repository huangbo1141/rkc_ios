//
//  TransportModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogModel.h"
@interface TransportModel : LogModel
@property (nonatomic, strong) NSString* mStatus;
@property (nonatomic, strong) NSString* mNumber;
@property (nonatomic, strong) NSString* mDepartureOpertator;
@property (nonatomic, strong) NSString* mDepartureArea;
@property (nonatomic, strong) NSString* mDepartureDate;
@property (nonatomic, strong) NSString* mDepartureTime;
@property (nonatomic, strong) NSString* mDepartureTemp;
@property (nonatomic, strong) NSString* mDepartureInvoiceFile;
@property (nonatomic, strong) NSString* mDepartureGoodFile;
@property (nonatomic, strong) NSString* mDepartureComment;
@property (nonatomic, strong) NSString* mDepartureAreaName;
@property (nonatomic, strong) NSString* mDepartureOperatorFirstName;
@property (nonatomic, strong) NSString* mDepartureOperatorLastName;

@property (nonatomic, strong) NSString* mArrivalOperator;
@property (nonatomic, strong) NSString* mArrivalArea;
@property (nonatomic, strong) NSString* mArrivalDate;
@property (nonatomic, strong) NSString* mArrivalTime;
@property (nonatomic, strong) NSString* mArrivalTemp;
@property (nonatomic, strong) NSString* mArrivalComment;

@property (nonatomic, strong) NSString* mArrivalInvoiceFile;
@property (nonatomic, strong) NSString* mArrivalGoodFile;
@property (nonatomic, strong) NSString* mUpdateTime;

@property (nonatomic, strong) NSString* mArrivalAreaName;
@property (nonatomic, strong) NSString* mArrivalOperatorFirstName;
@property (nonatomic, strong) NSString* mArrivalOperatorLastName;
@property (nonatomic, strong) NSString* mItemName;

@property (nonatomic, strong) UIImage* mInvoiceImage;
@property (nonatomic, strong) UIImage* mGoodImage;



-(NSString*) getDepartureTime;
-(NSString*) getMysqlDepartureTime;
-(void) setDepartureTime :(NSString*) departureTime;
-(void) setMysqlDepartureTime :(NSString*) departureTime;

-(NSString*) getArrivalTime;
-(NSString*) getMysqlArrivalTime;
-(void) setArrivalTime :(NSString*) arrivalTime;
-(void) setMysqlArrivalTime :(NSString*) arrivalTime;

-(NSString*) getDepartureDate;
-(NSString*) getMysqlDepartureDate;
-(void) setMysqlDepartureDate :(NSString*) departureDate;
-(void) setDepartureDate :(NSString*) departureDate;

-(NSString*) getArrivalDate;
-(NSString*) getMysqlArrivalDate ;
-(void) setMysqlArrivalDate :(NSString*) arrivalDate;
-(void) setArrivalDate:(NSString*) arrivalDate;

-(NSString*) getUpdateTime;
-(void) setUpdateTime:(NSString*) updateTime;

-(void) parse:(NSDictionary*) dict;

-(BOOL) isDeparture;
-(BOOL) isComplete;
@end
