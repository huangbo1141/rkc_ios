//
//  VCFridgeCapture.m
//  FoodSafety
//
//  Created by BoHuang on 8/22/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCFridgeCapture.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import "SettingModel.h"
#import "UIImage+ImageCompress.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Language.h"
@interface VCFridgeCapture ()

@end

@implementation VCFridgeCapture
@synthesize logModel, image;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logModel = (LogModel*) [UserInfo shared].captureObject;
    [Intercom setLauncherVisible:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - image picker delegate

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage* img  = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImage *compressedImage = [UIImage compressImage:img                                        compressRatio:0.9f];
    self.image = img;
    [self.imgCapture setImage:img];
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    /*      */
    // upload current image
    // [Global showIndicator:self];
}
- (IBAction)backAction:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cameraAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.delegate = self;
        [self presentViewController:picker animated:true completion:nil];
    }else{
        [Global AlertMessage:self Message:@"There is no camera." Title:nil];
    }
}
- (IBAction)saveAction:(id)sender {
    if( [[UserInfo shared].currentLogic isEqualToString:@"fridge"]) {
        [self serviceFridgeSave];
    }else if( [[UserInfo shared].currentLogic isEqualToString:@"freezer"]) {
        [self serviceFreezerSave];
    }else if( [[UserInfo shared].currentLogic isEqualToString:@"reheating"]) {
        [self serviceReheatingSave];
    }else if( [[UserInfo shared].currentLogic isEqualToString:@"service"]) {
        [self serviceServiceSave];
    }else if( [[UserInfo shared].currentLogic isEqualToString:@"cooling"]) {
        [self serviceCoolingSave];
    }else if( [[UserInfo shared].currentLogic isEqualToString:@"oil"]) {
        [self serviceOilSave];
    }else if( [[UserInfo shared].currentLogic isEqualToString:@"cleaning"]) {
        [self serviceCleaningSave];
    }
}

- (void) serviceFridgeSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureFridge:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Capture Fridge Temp"];
            [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeList" ];
        }
        [Global stopIndicator:self];
    }];
}

- (void) serviceFreezerSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureFreezer:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [Global switchScreen:self withStoryboardName:@"Freezer" withControllerName:@"VCFreezerList" ];
            [[UserInfo shared] intercomCreateEvent:@"Capture Freezer Temp"];
        }
        [Global stopIndicator:self];
    }];
}

- (void) serviceReheatingSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureReheating:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Capture Reheating Log"];
            [Global switchScreen:self withStoryboardName:@"Reheating" withControllerName:@"VCReheatingList" ];

        }
        [Global stopIndicator:self];
    }];
}

- (void) serviceServiceSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureService:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Capture Service Log"];
            [Global switchScreen:self withStoryboardName:@"Service" withControllerName:@"VCServiceList" ];
        }
        [Global stopIndicator:self];
    }];
}

- (void) serviceCoolingSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureCooling:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Capture Cooling Log"];
            [Global switchScreen:self withStoryboardName:@"Cooling" withControllerName:@"VCCoolingList" ];
        }
        [Global stopIndicator:self];
    }];
}
- (void) serviceOilSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureOil:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Capture Oil Change Log"];
            [Global switchScreen:self withStoryboardName:@"Oil" withControllerName:@"VCOilList" ];
        }
        [Global stopIndicator:self];
    }];
}

- (void) serviceCleaningSave {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureCleaning:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Capture Cleaning Task"];
            [Global switchScreen:self withStoryboardName:@"Cleaning" withControllerName:@"VCCleaningList" ];
        }
        [Global stopIndicator:self];
    }];
}
@end
