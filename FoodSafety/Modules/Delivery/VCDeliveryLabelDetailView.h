//
//  VCDeliveryLabelDetailView.h
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryModel.h"

@interface VCDeliveryLabelDetailView : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DeliveryModel* logModel;
@property (strong, nonatomic) NSMutableArray* labelItems;
- (void) reloadData;
@end
