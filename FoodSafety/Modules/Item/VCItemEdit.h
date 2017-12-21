//
//  VCItemEdit.h
//  FoodSafety
//
//  Created by BoHuang on 8/23/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "ItemInfoModel.h"
#import "ItemModel.h"

@interface VCItemEdit : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfItemName;
@property (weak, nonatomic) IBOutlet UITextField *tfBatchNumber;
@property (weak, nonatomic) IBOutlet BorderTextView *tvDescription;
@property (weak, nonatomic) IBOutlet UITextField *tfExpireDate;
@property (weak, nonatomic) IBOutlet BorderTextView *tvAllergens;

@property (weak, nonatomic) IBOutlet UIButton *btnAllergen;
@property (strong, nonatomic) ItemInfoModel* infoModel;
@property (strong, nonatomic) ItemModel* itemModel;
@property (strong, nonatomic) NSMutableArray* allergenModels;
@end
