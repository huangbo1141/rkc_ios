//
//  VCTransportDepatureInfo.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportModel.h"
#import "BorderTextView.h"
@interface VCTransportDepatureInfo : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblItem;
@property (weak, nonatomic) IBOutlet UILabel *lblInvoiceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet BorderTextView *tvDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblOperator;

@property (weak, nonatomic) IBOutlet UIImageView *imgInvoice;
@property (weak, nonatomic) IBOutlet UIImageView *imgGood;

@property (strong, nonatomic) TransportModel* logModel;

@end
