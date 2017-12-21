//
//  RoundUISegmentedControl.m
//  VirtualTrainR
//
//  Created by BoHuang on 12/22/16.
//  Copyright © 2016 ITLove. All rights reserved.
//

#import "RoundUISegmentedControl.h"

@implementation RoundUISegmentedControl
@dynamic borderColor,borderWidth;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.layer.frame.size.height /2;
    self.layer.borderWidth = 1.0f;
    self.layer.masksToBounds = YES;
    
}
@end
