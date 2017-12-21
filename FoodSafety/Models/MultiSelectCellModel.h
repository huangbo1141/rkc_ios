//
//  MultiSelectCellModel.h
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiSelectCellModel : NSObject
@property (nonatomic, strong) NSString* mValue;
@property (nonatomic, strong) NSString* mText;
@property (nonatomic, assign) BOOL isSelected;
@end
