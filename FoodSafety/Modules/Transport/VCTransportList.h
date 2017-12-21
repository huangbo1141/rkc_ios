//
//  VCTransportList.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "TransportInfoModel.h"
@interface VCTransportList : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet BorderButton *btnCreate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TransportInfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* transportLogItems;
@end
