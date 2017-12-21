//
//  VCTransportInfo.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCTransportInfo.h"
#import "UserInfo.h"
#import "Global.h"
#import "Language.h"
@interface VCTransportInfo ()

@end

@implementation VCTransportInfo
@synthesize tfInvoiceNumber, tvDescription, logModel, infoModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNext:(id)sender {
    
    if([self confirmEdit]) {
        if([logModel isDeparture])
            [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportDeparture"];
        else
            [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportArrival"];
    }
}
-(void) loadData {
    tfInvoiceNumber.text = @"";
    tvDescription.text= @"";
    if(logModel.mNumber != nil && ![logModel.mNumber isEqualToString:@""]) {
        tfInvoiceNumber.text = logModel.mNumber;
    }
    if([logModel isDeparture]) {
        [self.tfInvoiceNumber setEnabled:YES];
        if(logModel.mDepartureComment != nil && ![logModel.mCaptureNote isEqualToString:@""]) {
            tvDescription.text = logModel.mCaptureNote;
        }
    }else {
        [self.tfInvoiceNumber setEnabled:NO];
        if(logModel.mArrivalComment != nil && ![logModel.mArrivalComment isEqualToString:@""]) {
            tvDescription.text = logModel.mArrivalComment;
        }
    }
        

}

-(void) initialize {
    self.logModel = (TransportModel*) [UserInfo  shared].captureObject;
    self.infoModel = (TransportInfoModel*)[UserInfo shared].mInfoStore;
    [self loadData];
    //[self.pVLocation load]
}

- (BOOL) confirmEdit {
    NSString* description = self.tvDescription.text;
    NSString* invoiceNumber = self.tfInvoiceNumber.text;
    if([logModel isDeparture])
        logModel.mDepartureComment =description;
    else
        logModel.mArrivalComment =description;
    logModel.mNumber = invoiceNumber;
    return YES;
}



@end
