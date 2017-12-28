//
//  CircleButton.h
//  FoodSafety
//
//  Created by Huang Bo on 12/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CircleButton : UIButton

@property (nonatomic) IBInspectable NSInteger backMode;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end
