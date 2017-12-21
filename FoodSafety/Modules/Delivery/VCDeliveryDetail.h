//
//  VCDeliveryDetail.h
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCDeliveryDetailSection.h"
#import "VCDeliveryLabelDetailView.h"
@interface VCDeliveryDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;

@property (strong, nonatomic) UIViewController* currentVC;
@property (strong, nonatomic) VCDeliveryDetailSection* detailVC;
@property (strong, nonatomic) VCDeliveryLabelDetailView* labelVC;
@end
