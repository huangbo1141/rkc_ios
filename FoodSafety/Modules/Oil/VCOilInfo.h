//
//  VCOilInfo.h
//  FoodSafety
//
//  Created by BoHuang on 9/2/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "LogModel.h"
#import "InfoModel.h"
@interface VCOilInfo : UIViewController

@property (weak, nonatomic) IBOutlet BorderTextView *tvDescription;
@property (strong, nonatomic) LogModel* logModel;
@property (strong, nonatomic) InfoModel* infoModel;
@end
