//
//  VCMenuLabelAdd.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "DeliveryMenuModel.h"
#import "MenuInfoModel.h"
@interface VCMenuLabelAdd : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) MenuInfoModel* infoModel;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) DeliveryMenuModel* logModel;
@property (strong, nonatomic) NSDictionary* conditions;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterText;

@end
