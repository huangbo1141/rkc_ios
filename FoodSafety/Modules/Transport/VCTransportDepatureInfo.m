//
//  VCTransportDepatureInfo.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCTransportDepatureInfo.h"
#import "UserInfo.h"
#import "Global.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VCTransportDepatureInfo ()

@end

@implementation VCTransportDepatureInfo
@synthesize lblItem, lblInvoiceNumber, lblTime, lblDate, lblTemperature, lblOperator,tvDescription, imgInvoice, imgGood, logModel;
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
    logModel = (TransportModel*)[UserInfo shared].selectedObject;
    if(logModel.mItem != nil)
        self.lblItem.text = logModel.mItem;
    else
        self.lblItem.text =@"";
    
    if(logModel.mNumber != nil)
        self.lblInvoiceNumber.text = logModel.mNumber;
    else
        self.lblInvoiceNumber.text =@"";
    
    if([logModel getDepartureDate] != nil)
        self.lblDate.text = [logModel getDepartureDate];
    else
        self.lblDate.text =@"";
    
    if([logModel getDepartureTime] != nil)
        self.lblTime.text = [logModel getDepartureTime];
    else
        self.lblTime.text =@"";
    
    if(logModel.mDepartureTemp != nil)
        self.lblTemperature.text = logModel.mDepartureTemp;
    else
        self.lblTemperature.text =@"";
    
    if(logModel.mDepartureOperatorFirstName != nil)
        self.lblOperator.text = [[logModel.mDepartureOperatorFirstName stringByAppendingString:@" "] stringByAppendingString:logModel.mDepartureOperatorLastName];
    else
        self.lblOperator.text =@"";
    
    if(logModel.mDepartureComment != nil)
        self.tvDescription.text = logModel.mDepartureComment;
    else
        self.tvDescription.text =@"";
    
    if(logModel.mDepartureInvoiceFile != nil && [logModel.mDepartureInvoiceFile isKindOfClass:[NSString class]] && ![logModel.mDepartureInvoiceFile isEqualToString:@""]){
        [self.imgInvoice sd_setImageWithURL:[NSURL URLWithString:logModel.mDepartureInvoiceFile ]];
    }
    
    if(logModel.mDepartureGoodFile != nil && [logModel.mDepartureGoodFile isKindOfClass:[NSString class]] && ![logModel.mDepartureGoodFile isEqualToString:@""]){
        [self.imgInvoice sd_setImageWithURL:[NSURL URLWithString:logModel.mDepartureGoodFile ]];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextAction:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportInfo"];
}

@end
