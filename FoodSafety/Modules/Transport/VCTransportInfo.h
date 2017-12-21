//
//  VCTransportInfo.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderTextView.h"
#import "TransportModel.h"
#import "TransportInfoModel.h"
@interface VCTransportInfo : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfInvoiceNumber;
@property (weak, nonatomic) IBOutlet BorderTextView *tvDescription;
@property (strong, nonatomic) TransportModel* logModel;
@property (strong, nonatomic) TransportInfoModel* infoModel;
@end
