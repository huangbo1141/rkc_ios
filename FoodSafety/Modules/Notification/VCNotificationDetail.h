//
//  VCNotificationDetail.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"

@interface VCNotificationDetail : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;
@property (strong, nonatomic) NotificationModel* logModel;
@end
