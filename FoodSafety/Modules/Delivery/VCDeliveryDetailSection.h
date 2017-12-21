//
//  VCDeliveryDetailSection.h
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCDeliveryInfoDetailView.h"
#import "VCDeliveryConditionDetailView.h"

@interface VCDeliveryDetailSection : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;

@property (strong, nonatomic) UIViewController* currentVC;
@property (strong, nonatomic) VCDeliveryInfoDetailView* infoVC;
@property (strong, nonatomic) VCDeliveryConditionDetailView* conditionVC;
-(void) reloadData;
@end
