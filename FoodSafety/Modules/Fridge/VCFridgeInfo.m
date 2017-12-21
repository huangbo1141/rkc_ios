//
//  VCFridgeInfo.m
//  FoodSafety
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCFridgeInfo.h"
#import "UserInfo.h"
#import "Global.h"
#import "Language.h"
@interface VCFridgeInfo ()

@end

@implementation VCFridgeInfo
@synthesize tfTemperature, tvDescription, logModel, infoModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initialize {
    self.logModel = (LogModel*) [UserInfo  shared].captureObject;
    self.infoModel = (InfoModel*)[UserInfo shared].mInfoStore;
       [self loadData];
    //[self.pVLocation load]
}

-(void) loadData {
    tfTemperature.text = @"0";
    tvDescription.text= @"";
    if(logModel.mCaptureValue != nil && ![logModel.mCaptureValue isEqualToString:@""]) {
        tfTemperature.text = logModel.mCaptureValue;
    }
    if(logModel.mCaptureNote != nil && ![logModel.mCaptureNote isEqualToString:@""]) {
        tvDescription.text = logModel.mCaptureNote;
    }
}

- (IBAction)actionMinus:(id)sender {
    NSString* temperature = tfTemperature.text;
    if([temperature isEqualToString:@""])
        temperature = @"0";
    float value = [temperature floatValue];
    value -= 1;
    NSString *myString = [[NSNumber numberWithFloat:value] stringValue];
    tfTemperature.text = myString;
}
- (IBAction)actionPlus:(id)sender {
    NSString* temperature = tfTemperature.text;
    if([temperature isEqualToString:@""])
        temperature = @"0";
    float value = [temperature floatValue];
    value += 1;
    NSString *myString = [[NSNumber numberWithFloat:value] stringValue];
    tfTemperature.text = myString;
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNext:(id)sender {

    if([self confirmEdit]) {
        [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeCapture"];
    }
}

- (BOOL) confirmEdit {
    NSString* description = self.tvDescription.text;
    NSString* temperature = self.tfTemperature.text;
    if([temperature isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"Plesae enter temperature.") Title:kLang(@"alert")];
        return NO;
    }
    logModel.mCaptureNote =description;
    logModel.mCaptureValue = temperature;
    return YES;
}
@end
