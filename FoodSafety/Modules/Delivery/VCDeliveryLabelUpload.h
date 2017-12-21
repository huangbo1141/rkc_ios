//
//  VCDeliveryLabelUpload.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryModel.h"
#import "BorderButton.h"
@interface VCDeliveryLabelUpload : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* uploadItems;
@property (strong, nonatomic) DeliveryModel* logModel;
@property (strong, nonatomic) UIImage* image;
@property (weak, nonatomic) IBOutlet BorderButton *btnAddLabel;
@property (strong, nonatomic) NSString* fromVC;
@end
