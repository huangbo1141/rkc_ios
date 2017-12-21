//
//  TVCellTransportLog.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellTransportLog : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblArrivalTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblDepartureTemp;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
