//
//  VCDeliveryCondition.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryCondition.h"
#import "UserInfo.h"
#import "Global.h"
@interface VCDeliveryCondition ()

@end

@implementation VCDeliveryCondition

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logModel = (DeliveryModel*)[UserInfo shared].captureObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction:(id)sender {
    [self setData];
    [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryCapture"];
}

-(void) setData {
    self.logModel.mTempAccept = self.temperatureChk.isOn ? @"1" : @"0";
    self.logModel.mCondAccept = self.conditionChk.isOn ? @"1" : @"0";
    self.logModel.mDateAccept = self.userBeforeChk.isOn ? @"1" : @"0";
    self.logModel.mAspectAccept = self.aspectChk.isOn ? @"1" : @"0";
    self.logModel.mQualityAccept = self.qualityChk.isOn ? @"1" : @"0";
    
}


@end
