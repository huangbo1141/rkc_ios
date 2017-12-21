//
//  VCFridgeCapture.h
//  FoodSafety
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "LogModel.h"

@interface VCFridgeCapture : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgCapture;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
@property (weak, nonatomic) IBOutlet BorderButton *btnSave;
@property (strong, nonatomic) LogModel* logModel;
@property (strong, nonatomic) UIImage* image;
@end
