//
//  TVCellItem.h
//  FoodSafety
//
//  Created by BoHuang on 9/2/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellItem : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblExpireDate;


@end
