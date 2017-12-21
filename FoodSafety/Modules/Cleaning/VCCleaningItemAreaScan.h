//
//  VCCleaningItemAreaScan.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogModel.h"
#import "InfoModel.h"
@interface VCCleaningItemAreaScan : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) LogModel* logModel;
@property (strong, nonatomic) InfoModel* infoModel;

@property (weak, nonatomic) IBOutlet UITextField *tfItem;
@property (weak, nonatomic) IBOutlet UITextField *tfArea;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) UIPickerView *pVArea;

@end
