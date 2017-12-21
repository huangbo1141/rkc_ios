//
//  VCFridgeDetail.m
//  FoodSafety
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCFridgeDetail.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "Global.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VCFridgeDetail ()

@end

@implementation VCFridgeDetail
@synthesize lblLocation, lblTime, lblTemperature, lblOperator, lblDescription, imgCapture, logModel;
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
    if(logModel.mLocation != nil)
        self.lblLocation.text = logModel.mLocation;
    else
        self.lblLocation.text =@"";
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

- (void) serviceFridgeDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteFridge:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceFreezerDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteFreezer:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceOilDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteOil:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceCleaningDelete {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteCleaning:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
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
    if([[UserInfo shared].currentLogic isEqualToString:@"fridge"]) {
        [self serviceFridgeDelete];
    }else if([[UserInfo shared].currentLogic isEqualToString:@"freezer"]) {
        [self serviceFreezerDelete];
    }else if([[UserInfo shared].currentLogic isEqualToString:@"oil"]) {
        [self serviceOilDelete];
    }else if([[UserInfo shared].currentLogic isEqualToString:@"cleaning"]) {
        [self serviceCleaningDelete];
    }
}
@end
