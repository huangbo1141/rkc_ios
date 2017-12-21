//
//  VCMenuItemAddList.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "DeliveryMenuModel.h"
#import "MenuInfoModel.h"
@interface VCMenuItemAddList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BorderButton *addItem;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) MenuInfoModel* infoModel;
@property (strong, nonatomic) DeliveryMenuModel* logModel;
@end
