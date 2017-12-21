//
//  VCDeliveryInfo.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "DeliveryInfoModel.h"
#import "DeliveryModel.h"

@interface VCDeliveryInfo : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *tfSupplier;
@property (weak, nonatomic) IBOutlet UITextField *tfDeliveryNumber;
@property (weak, nonatomic) IBOutlet BorderTextView *tvDescription;
@property (weak, nonatomic) IBOutlet UITextField *tfTemperature;
@property (weak, nonatomic) IBOutlet BorderTextView *tvGoodType;
@property (strong, nonatomic) DeliveryInfoModel* infoModel;
@property (strong, nonatomic) DeliveryModel* logModel;
@property (strong, nonatomic) NSMutableArray* goodTypeModels;
@property (strong, nonatomic) UIPickerView *pVSupplier;
@end
