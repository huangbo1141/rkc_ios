//
//  VCSafetyList.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaboratoryInfoModel.h"

@interface VCSafetyList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (strong, nonatomic) LaboratoryInfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* logs;

@end
