//
//  VCMenuFilter.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuInfoModel.h"

@interface VCMenuFilter : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) void (^didDismiss)(NSDictionary *conditionValues, NSDictionary* conditionTitle);
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfDateFrom;
@property (weak, nonatomic) IBOutlet UITextField *tfDateTo;
@property (weak, nonatomic) IBOutlet UITextField *tfLocation;
@property (strong, nonatomic) UIPickerView *pVLocation;
@property (strong, nonatomic) MenuInfoModel* infoModel;
@end
