//
//  VCItemFilter.h
//  FoodSafety
//
//  Created by BoHuang on 8/24/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInfoModel.h"

@interface VCItemFilter : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) void (^didDismiss)(NSDictionary *conditionValues, NSDictionary* conditionTitle);
@property (weak, nonatomic) IBOutlet UITextField *tfItemName;
@property (weak, nonatomic) IBOutlet UITextField *tfBatch;
@property (weak, nonatomic) IBOutlet UITextField *tfCreateDate;
@property (weak, nonatomic) IBOutlet UITextField *tfExpireDate;
@property (weak, nonatomic) IBOutlet UITextField *tfAllergen;
@property (strong, nonatomic) NSDictionary* conditions;
@property (strong, nonatomic) UIPickerView *pVAllergen;
@property (strong, nonatomic) ItemInfoModel* infoModel;


@end
