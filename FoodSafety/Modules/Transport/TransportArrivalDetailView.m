//
//  TransportArrivalDetailView.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "TransportArrivalDetailView.h"
#import "UserInfo.h"
#import "Global.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface TransportArrivalDetailView ()

@end

@implementation TransportArrivalDetailView

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
    
    if([logModel getArrivalDate] != nil)
        self.lblDate.text = [logModel getArrivalDate];
    else
        self.lblDate.text =@"";
    
    if([logModel getArrivalTime] != nil)
        self.lblTime.text = [logModel getArrivalTime];
    else
        self.lblTime.text =@"";
    
    if(logModel.mArrivalTemp != nil)
        self.lblTemperature.text = logModel.mArrivalTemp;
    else
        self.lblTemperature.text =@"";
    
    if(logModel.mArrivalOperatorFirstName != nil)
        self.lblOperator.text = [[logModel.mArrivalOperatorFirstName stringByAppendingString:@" "] stringByAppendingString:logModel.mArrivalOperatorLastName];
    else
        self.lblOperator.text =@"";
    
    if(logModel.mArrivalComment != nil)
        self.tvDescription.text = logModel.mArrivalComment;
    else
        self.tvDescription.text =@"";
    
    if(logModel.mArrivalInvoiceFile != nil && [logModel.mArrivalInvoiceFile isKindOfClass:[NSString class]] && ![logModel.mArrivalInvoiceFile isEqualToString:@""]){
        [self.imgInvoice sd_setImageWithURL:[NSURL URLWithString:logModel.mArrivalInvoiceFile ]];
    }
    
    if(logModel.mArrivalGoodFile != nil && [logModel.mArrivalGoodFile isKindOfClass:[NSString class]] && ![logModel.mArrivalGoodFile isEqualToString:@""]){
        [self.imgGood sd_setImageWithURL:[NSURL URLWithString:logModel.mArrivalGoodFile ]];
    }
}

@end
