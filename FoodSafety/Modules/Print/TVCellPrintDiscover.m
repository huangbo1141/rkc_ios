//
//  TVCellPrintDiscover.m
//  FoodSafety
//
//  Created by BoHuang on 9/5/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "TVCellPrintDiscover.h"

@implementation TVCellPrintDiscover

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setChecked:(BOOL) checked {
    if(checked) {
        [self.imgCheck setImage:[UIImage imageNamed:@"ic_check"]];
    }else {
        [self.imgCheck setImage:[UIImage imageNamed:@"ic_uncheck"]];
    }

}

@end
