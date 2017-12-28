//
//  CircleButton.m
//  FoodSafety
//
//  Created by Huang Bo on 12/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setBackMode:(NSInteger)backMode{
    _backMode = backMode;
    switch (backMode) {
        case 1:
            self.backgroundColor = [UIColor redColor];
            break;
        case 2:
            self.backgroundColor = [UIColor greenColor];
            break;
        default:
            break;
    }
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = true;
    
}

-(void) layoutSubviews{
    [super layoutSubviews];
}
@end
