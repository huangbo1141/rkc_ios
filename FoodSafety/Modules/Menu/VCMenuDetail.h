//
//  VCMenuDetail.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCMenuDetailView.h"
#import "VCMenuDetailItem.h"
#import "VCMenuDetailLabel.h"
@interface VCMenuDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;

@property (strong, nonatomic) UIViewController* currentVC;
@property (strong, nonatomic) VCMenuDetailView* detailVC;
@property (strong, nonatomic) VCMenuDetailItem * itemVC;
@property (strong, nonatomic) VCMenuDetailLabel * labelVC;

@end
