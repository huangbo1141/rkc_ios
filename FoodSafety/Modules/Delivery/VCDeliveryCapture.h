//
//  VCDeliveryCapture.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "DeliveryModel.h"
@interface VCDeliveryCapture : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgCapture;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
@property (weak, nonatomic) IBOutlet BorderButton *btnAccept;
@property (weak, nonatomic) IBOutlet BorderButton *btnDelcline;
@property (strong, nonatomic) DeliveryModel* logModel;
@property (strong, nonatomic) UIImage* image;
@end
