//
//  VCCleaningCapture.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "LogModel.h"
@interface VCCleaningCapture : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgCapture;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
@property (weak, nonatomic) IBOutlet BorderButton *btnSave;
@property (strong, nonatomic) LogModel* logModel;
@property (strong, nonatomic) UIImage* image;

@end
