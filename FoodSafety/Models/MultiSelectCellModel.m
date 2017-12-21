//
//  MultiSelectCellModel.m
//  FoodSafety
//
//  Created by BoHuang on 8/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "MultiSelectCellModel.h"

@implementation MultiSelectCellModel
- (id)init
{
    if((self = [super init])) {
        self.mValue =  @"";
        self.mText = @"";
        self.isSelected = NO;
    }
    return self;
}

@end
