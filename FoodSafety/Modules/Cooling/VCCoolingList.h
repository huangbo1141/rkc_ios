//
//  VCCoolingList.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface VCCoolingList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) InfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* coolingLogItems;
@end
