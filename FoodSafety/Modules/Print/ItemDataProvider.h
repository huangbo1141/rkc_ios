//
//  ItemDataProvider.h
//  FoodSafety
//
//  Created by BoHuang on 9/5/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "LWPrintDataProvider.h"
#import <UIKit/UIKit.h>

@interface ItemDataProvider : LWPrintDataProvider

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *operatorName;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *expireDate;
@property (nonatomic, strong) NSString *qrCodeData;




@end
