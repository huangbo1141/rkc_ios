//
//  VCNotificationList.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationInfoModel.h"
@interface VCNotificationList : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NotificationInfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* logs;
@end
