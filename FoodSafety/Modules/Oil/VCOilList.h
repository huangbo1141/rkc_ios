//
//  VCOilList.h
//  FoodSafety
//
//  Created by BoHuang on 9/2/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"

@interface VCOilList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) InfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* oilLogItems;
@property (strong, nonatomic) NSMutableDictionary* oilAssignModels;

@end
