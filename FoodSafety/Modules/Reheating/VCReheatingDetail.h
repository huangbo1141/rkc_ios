//
//  VCReheatingDetail.h
//  FoodSafety
//
//  Created by BoHuang on 9/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "LogModel.h"
@interface VCReheatingDetail : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblItem;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblOperator;
@property (weak, nonatomic) IBOutlet BorderTextView *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgCapture;
@property (strong, nonatomic) LogModel* logModel;
@end
