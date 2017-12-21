//
//  TVCellPrintDiscover.h
//  FoodSafety
//
//  Created by BoHuang on 9/5/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellPrintDiscover : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
-(void) setChecked:(BOOL) checked;
@end
