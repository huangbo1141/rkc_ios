//
//  VCMenuDetailLabel.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryMenuModel.h"
@interface VCMenuDetailLabel : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) DeliveryMenuModel* logModel;
-(void) loadData;
@end
