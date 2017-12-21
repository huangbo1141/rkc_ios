//
//  VCDeliveryCapture.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryCapture.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import "SettingModel.h"
#import "UIImage+ImageCompress.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Language.h"
@interface VCDeliveryCapture ()

@end

@implementation VCDeliveryCapture
@synthesize logModel, image;
- (void)viewDidLoad {
    [super viewDidLoad];
    [Intercom setLauncherVisible:NO];
    // Do any additional setup after loading the view.
    logModel = (DeliveryModel*) [UserInfo shared].captureObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
- (IBAction)acceptAction:(id)sender {
    [self serviceDeliverySave:@"accept"];
}
- (IBAction)declineAction:(id)sender {
    [self serviceDeliverySave:@"decline"];
}
- (void) serviceDeliverySave:(NSString*) action {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlAcceptDatetime:currentDateTime];
    logModel.mImage = self.image;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCaptureDelivery:logModel withAction:action  withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSString* keyCode = (NSString*) responseObject;
            self.logModel.mKeyCode = keyCode;
            [[UserInfo shared] intercomCreateEvent:@"Create Delivery Record"];
            [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryLabelUpload" ];
        }
        [Global stopIndicator:self];
    }];
}

@end
