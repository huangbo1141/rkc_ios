//
//  VCDeliveryInfoDetailView.m
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryInfoDetailView.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VCDeliveryInfoDetailView ()

@end

@implementation VCDeliveryInfoDetailView
@synthesize tvGoodType, lblSupplier, lblDeliveryNumber, lblTemperature, lblOperator, lblTime, tvDescription, logModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)reloadData{
    logModel = (DeliveryModel*)[UserInfo shared].selectedObject;
    if(logModel.mGoodTypes != nil)
        self.tvGoodType.text = [logModel getItemsWithComma];
    else
        self.tvGoodType.text =@"";
    
    if(logModel.mSupplierName != nil)
        self.lblSupplier.text = logModel.mSupplierName;
    else
        self.lblSupplier.text =@"";
    
    if(logModel.mNumber != nil)
        self.lblDeliveryNumber.text = logModel.mNumber;
    else
        self.lblDeliveryNumber.text =@"";
    
    if(logModel.mTemperature != nil)
        self.lblTemperature.text = logModel.mTemperature;
    else
        self.lblTemperature.text =@"";
    
    if(logModel.mOperator != nil)
        self.lblOperator.text = [[logModel.mOperatorFirstName stringByAppendingString:@" "] stringByAppendingString:logModel.mOperatorLastName];
    else
        self.lblOperator.text =@"";
    
    if(logModel.mAcceptDatetime != nil)
        self.lblTime.text = [logModel getAcceptDatetime];
    else
        self.lblTime.text =@"";
    
    if(logModel.mComment != nil)
        self.tvDescription.text = logModel.mComment;
    else
        self.tvDescription.text =@"";
    
    
    if(logModel.mBigFile != nil && [logModel.mBigFile isKindOfClass:[NSString class]] && ![logModel.mBigFile isEqualToString:@""]){
        [self.imgCapture sd_setImageWithURL:[NSURL URLWithString:logModel.mBigFile ]];
    }

}

@end
