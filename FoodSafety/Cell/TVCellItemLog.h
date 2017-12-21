//
//  TVCellItemLog.h
//  FoodSafety
//
//  Created by BoHuang on 8/24/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellItemLog : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBatch;
@property (weak, nonatomic) IBOutlet UILabel *lblCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblExpire;

@end
