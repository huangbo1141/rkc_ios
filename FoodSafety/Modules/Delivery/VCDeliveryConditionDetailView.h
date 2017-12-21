//
//  VCDeliveryConditionDetailView.h
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryModel.h"

@interface VCDeliveryConditionDetailView : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch* chkTemperature;
@property (weak, nonatomic) IBOutlet UISwitch* chkConditions;
@property (weak, nonatomic) IBOutlet UISwitch* chkUseBefore;
@property (weak, nonatomic) IBOutlet UISwitch* chkAspect;
@property (weak, nonatomic) IBOutlet UISwitch* chkQuality;

@property (strong, nonatomic) DeliveryModel* logModel;

-(void) reloadData;
@end
