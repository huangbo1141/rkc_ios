//
//  VCTransportDetail.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCTransportDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;

@property (strong, nonatomic) UIViewController* currentVC;
@property (strong, nonatomic) UIViewController* departureVC;
@property (strong, nonatomic) UIViewController* arrivalVC;
@end
