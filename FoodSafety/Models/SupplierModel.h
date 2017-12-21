//
//  SupplierModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierModel : NSObject
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mKeyCode;
@property (nonatomic, strong) NSString* mName;

-(void) parse:(NSDictionary*) dict;
@end
