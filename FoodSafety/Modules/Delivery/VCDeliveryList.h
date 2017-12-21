//
//  VCDeliveryList.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "DeliveryInfoModel.h"
@interface VCDeliveryList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BorderButton *btnCreate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DeliveryInfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* deliveryLogItems;
@end
