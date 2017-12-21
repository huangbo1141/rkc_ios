//
//  VCReheatingDetail.m
//  FoodSafety
//
//  Created by BoHuang on 9/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCReheatingDetail.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "Global.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VCReheatingDetail ()

@end

@implementation VCReheatingDetail
@synthesize lblItem, lblTime, lblTemperature, lblOperator, lblDescription, imgCapture, logModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    logModel = (LogModel*)[UserInfo shared].selectedObject;
    if(logModel.mItem != nil)
        self.lblItem.text = logModel.mItem;
    else
        self.lblItem.text =@"";
    if(logModel.mCaptureDateTime != nil)
        self.lblTime.text = [logModel getCaptureDatetime];
    else
        self.lblTime.text =@"";
    if(logModel.mCaptureValue != nil)
        self.lblTemperature.text = logModel.mCaptureValue;
    else
        self.lblTemperature.text =@"";
    if(logModel.mOperator != nil)
        self.lblOperator.text = logModel.mOperator;
    else
        self.lblOperator.text =@"";
    if(logModel.mCaptureNote != nil)
        self.lblDescription.text = logModel.mCaptureNote;
    else
        self.lblDescription.text =@"";
    if(logModel.mBigFile != nil && [logModel.mBigFile isKindOfClass:[NSString class]] && ![logModel.mBigFile isEqualToString:@""]){
        [self.imgCapture sd_setImageWithURL:[NSURL URLWithString:logModel.mBigFile ]];
    }
}

- (void) serviceReheatingDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteReheating:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceServiceDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteService:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceCoolingDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteCooling:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}


- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backAction:(id)sender {
    [self goBack];
}
- (IBAction)deleteAction:(id)sender {
    if([[UserInfo shared].currentLogic isEqualToString:@"reheating"]) {
        [self serviceReheatingDelete];
    }else if([[UserInfo shared].currentLogic isEqualToString:@"service"]) {
        [self serviceServiceDelete];
    }else if([[UserInfo shared].currentLogic isEqualToString:@"cooling"]) {
        [self serviceCoolingDelete];
    }
}
@end
