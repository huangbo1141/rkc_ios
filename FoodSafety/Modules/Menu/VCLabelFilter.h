//
//  VCLabelFilter.h
//  FoodSafety
//
//  Created by BoHuang on 9/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuInfoModel.h"
@interface VCLabelFilter : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) void (^didDismiss)(NSDictionary *conditionValues, NSDictionary* conditionTitle);
@property (weak, nonatomic) IBOutlet UITextField *tfSupplier;
@property (weak, nonatomic) IBOutlet UITextField *tfNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfDateFrom;
@property (weak, nonatomic) IBOutlet UITextField *tfDateTo;
@property (strong, nonatomic) UIPickerView *pVSupplier;
@property (strong, nonatomic) MenuInfoModel* infoModel;
@end
