//
//  VCItemList.h
//  FoodSafety
//
//  Created by BoHuang on 8/23/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "ItemInfoModel.h"

@interface VCItemList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BorderButton *createItem;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) ItemInfoModel* infoModel;
@property (strong, nonatomic) NSDictionary* conditions;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterText;

@end
