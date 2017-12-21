//
//  VCItemScan.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogModel.h"
#import "InfoModel.h"
@interface VCItemScan : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) LogModel* logModel;
@property (weak, nonatomic) IBOutlet UITextField *tfItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * items;

@end
