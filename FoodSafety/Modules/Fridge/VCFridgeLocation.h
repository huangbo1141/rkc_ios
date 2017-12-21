//
//  VCFridgeLocation.h
//  FoodSafety
//
//  Created by BoHuang on 8/18/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogModel.h"
#import "InfoModel.h"
@interface VCFridgeLocation : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIPickerView *pVLocation;
@property (strong, nonatomic) LogModel* logModel;
@property (strong, nonatomic) InfoModel* infoModel;



@end
