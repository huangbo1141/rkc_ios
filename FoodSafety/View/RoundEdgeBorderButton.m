//
//  RoundEdgeBorderButton.m
//  FoodSafety
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "RoundEdgeBorderButton.h"

@implementation RoundEdgeBorderButton

@dynamic borderColor,borderWidth, radius;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}


-(void)setRadius:(CGFloat)radius{
    self.layer.cornerRadius = radius;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
}
@end
