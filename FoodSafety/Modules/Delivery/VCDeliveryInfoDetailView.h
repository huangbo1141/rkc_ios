//
//  VCDeliveryInfoDetailView.h
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "DeliveryModel.h"
@interface VCDeliveryInfoDetailView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tvGoodType;
@property (weak, nonatomic) IBOutlet UILabel *lblSupplier;
@property (weak, nonatomic) IBOutlet UILabel *lblDeliveryNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet BorderTextView *tvDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblOperator;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIImageView *imgCapture;

@property (strong, nonatomic) DeliveryModel* logModel;
-(void) reloadData;
@end
