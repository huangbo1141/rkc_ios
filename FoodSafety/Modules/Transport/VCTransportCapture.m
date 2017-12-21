//
//  VCTransportCapture.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCTransportCapture.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import "SettingModel.h"
#import "UIImage+ImageCompress.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Language.h"
@interface VCTransportCapture ()

@end

@implementation VCTransportCapture
@synthesize logModel, invoiceImage, goodImage, goodOrInvoice,btnAccept,btnDecline,btnSave, imgGood, imgInvoice;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    logModel = (TransportModel*) [UserInfo shared].captureObject;    
    if([logModel isDeparture]) {

        btnSave.hidden = false;
        btnAccept.hidden = true;
        btnDecline.hidden = true;
    }else {

        btnSave.hidden = true;
        btnAccept.hidden = false;
        btnDecline.hidden = false;
    }
    self.goodOrInvoice = 0;
    [Intercom setLauncherVisible:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) serviceTransportArrival:(NSString*) action {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mInvoiceImage = self.invoiceImage;
    logModel.mGoodImage =self.goodImage;
    [Global showIndicator:self];
    
    [[NetworkParser shared] serviceTransportArrival:logModel withAction:action withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Create Trnasport Arrival"];
            [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportList" ];
        }
        [Global stopIndicator:self];
    }];
}

- (void) serviceTransportDeparture {
    NSString* currentDateTime = [[SettingModel shared] getMysqlDateTimeStringFromDate:[NSDate date]];
    [logModel setMysqlCaptureDatetime:currentDateTime];
    logModel.mInvoiceImage = self.invoiceImage;
    logModel.mGoodImage =self.goodImage;
    [Global showIndicator:self];
    [[NetworkParser shared] serviceTransportDeparture:logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] intercomCreateEvent:@"Create Transport Departure"];
            [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportList" ];
        }
        [Global stopIndicator:self];
    }];
}

// MARK: - image picker delegate

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage* img  = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImage *compressedImage = [UIImage compressImage:img                                        compressRatio:0.9f];
    if(goodOrInvoice == 1){
        self.invoiceImage = img;
        [self.imgInvoice setImage:img];
    }
    if(goodOrInvoice == 2){
        self.goodImage = img;
        [self.imgGood setImage:img];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /*      */
    // upload current image
    // [Global showIndicator:self];
}
- (IBAction)saveAction:(id)sender {
    [self serviceTransportDeparture];
}
- (IBAction)acceptAction:(id)sender {
    [self serviceTransportArrival:@"1"];
}
- (IBAction)declineAction:(id)sender {
    [self serviceTransportArrival:@"2"];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)invoiceCameraAction:(id)sender {
    goodOrInvoice = 1;
    [self cameraShow];
}

- (IBAction)goodCameraAction:(id)sender {
    goodOrInvoice = 2;
    [self cameraShow];
}

- (void) cameraShow {
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


@end
