//
//  VCMenuInfo.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuInfoModel.h"
#import "DeliveryMenuModel.h"
#import "BorderTextView.h"
@interface VCMenuInfo : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfDate;
@property (weak, nonatomic) IBOutlet UITextField *tfLocation;
@property (weak, nonatomic) IBOutlet BorderTextView *tvTime;
@property (strong, nonatomic) MenuInfoModel* infoModel;
@property (strong, nonatomic) DeliveryMenuModel* logModel;
@property (strong, nonatomic) NSMutableArray* timeTypeModels;
@property (strong, nonatomic) UIPickerView *pVLocation;
@end
