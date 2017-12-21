//
//  LogModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssignModel.h"
#import <UIKit/UIKit.h>
@interface LogModel : NSObject

@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mKeyCode;

@property (nonatomic, strong) NSString* mCaptureDateTime;
@property (nonatomic, strong) NSString* mCaptureValue;
@property (nonatomic, strong) NSString* mCaptureNote;
@property (nonatomic, strong) NSString* mBigFile;
@property (nonatomic, strong) NSString* mThumbFile;
@property (nonatomic, strong) NSString* mLocationCode;
@property (nonatomic, strong) NSString* mLocation;
@property (nonatomic, strong) NSString* mLocationId;
@property (nonatomic, strong) NSString* mOperator;
@property (nonatomic, strong) NSString* mItem;
@property (nonatomic, strong) NSString* mItemCode;
@property (nonatomic, strong) NSString* mItemId;
@property (nonatomic, strong) NSString* mItemName;
@property (nonatomic, strong) NSString* mAreaId;
@property (nonatomic, strong) NSString* mAreaName;
@property (nonatomic, strong) AssignModel* mAssignModel;
@property (nonatomic, strong) UIImage* mImage;

-(NSString*) getCaptureDatetime;
-(NSString*) getMysqlCaptureDatetime;

-(void) setCaptureDatetime:(NSString*) captureDatetime;
-(void) setMysqlCaptureDatetime:(NSString*) captureDatetime;

-(void) parse:(NSDictionary*) dict;



@end
