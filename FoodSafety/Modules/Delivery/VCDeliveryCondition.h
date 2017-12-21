//
//  VCDeliveryCondition.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryModel.h"
@interface VCDeliveryCondition : UIViewController
@property (strong, nonatomic) DeliveryModel* logModel;
@property (weak, nonatomic) IBOutlet UISwitch *temperatureChk;
@property (weak, nonatomic) IBOutlet UISwitch *conditionChk;
@property (weak, nonatomic) IBOutlet UISwitch *userBeforeChk;
@property (weak, nonatomic) IBOutlet UISwitch *aspectChk;
@property (weak, nonatomic) IBOutlet UISwitch *qualityChk;


@end
