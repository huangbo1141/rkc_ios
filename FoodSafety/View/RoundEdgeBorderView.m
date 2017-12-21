//
//  RoundEdgeBorderView.m
//  FoodSafety
//
//  Created by BoHuang on 8/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "RoundEdgeBorderView.h"

@implementation RoundEdgeBorderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
