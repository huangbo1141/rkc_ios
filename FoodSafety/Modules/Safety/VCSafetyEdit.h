//
//  VCSafetyEdit.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "LaboratoryInfoModel.h"
#import "LaboratoryModel.h"

@interface VCSafetyEdit : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfOperator;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet BorderTextView *tvComment;
@property (weak, nonatomic) IBOutlet UITextField *tfDate;
@property (weak, nonatomic) IBOutlet UITextField *tfAttachFile;

@property (strong, nonatomic) LaboratoryInfoModel* infoModel;
@property (strong, nonatomic) LaboratoryModel* logModel;
@property (strong, nonatomic) UIPickerView *pVOperator;
@end
