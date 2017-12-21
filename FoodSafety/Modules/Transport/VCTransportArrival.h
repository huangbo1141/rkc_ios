//
//  VCTransportArrival.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TransportModel.h"
#import "TransportInfoModel.h"

@interface VCTransportArrival : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *tfArea;
@property (weak, nonatomic) IBOutlet UITextField *tfDate;
@property (weak, nonatomic) IBOutlet UITextField *tfTime;
@property (weak, nonatomic) IBOutlet UITextField *tfTemperature;
@property (strong, nonatomic) TransportModel* logModel;
@property (strong, nonatomic) TransportInfoModel* infoModel;

@property (strong, nonatomic) UIPickerView *pVArea;

@end
