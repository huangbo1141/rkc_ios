//
//  VCOilCapture.m
//  FoodSafety
//
//  Created by BoHuang on 9/2/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCOilCapture.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import "SettingModel.h"
#import "UIImage+ImageCompress.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Language.h"
@interface VCOilCapture ()

@end

@implementation VCOilCapture

@synthesize logModel, image;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logModel = (LogModel*) [UserInfo shared].captureObject;
    [Intercom setLauncherVisible:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - image picker delegate

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage* img  = [info objectForKey:UIImagePickerControllerOriginalImage];
   // UIImage *compressedImage = [UIImage compressImage:img                                        compressRatio:0.9f];
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
- (IBAction)acceptAction:(id)sender {
    [self serviceOilSave: true ];
 
}
- (IBAction)declineAction:(id)sender {
    [self serviceOilSave: false];
    
}

- (void) serviceOilSave:(BOOL) accept {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mImage = self.image;
    logModel.mCaptureValue = accept ? @"1" : @"0";
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureOil:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [Global switchScreen:self withStoryboardName:@"Oil" withControllerName:@"VCOilList" ];
        }
        [Global stopIndicator:self];
    }];
}

@end
