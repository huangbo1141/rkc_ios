//
//  VCDeliveryConditionDetailView.m
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryConditionDetailView.h"
#import "UserInfo.h"

@interface VCDeliveryConditionDetailView ()

@end

@implementation VCDeliveryConditionDetailView
@synthesize  logModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData {
    logModel = (DeliveryModel*)[UserInfo shared].selectedObject;
    [self.chkTemperature setOn:   [logModel.mTempAccept isEqualToString:@"1"] animated:NO];

    [self.chkConditions setOn:  [logModel.mCondAccept isEqualToString:@"1"] animated:NO];
    [self.chkUseBefore setOn:  [logModel.mDateAccept isEqualToString:@"1"] animated:NO];
    [self.chkAspect setOn:  [logModel.mAspectAccept isEqualToString:@"1"] animated:NO];
    [self.chkQuality setOn:  [logModel.mQualityAccept isEqualToString:@"1"] animated:NO];
}

@end
