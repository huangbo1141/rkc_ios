//
//  VCTransportCapture.h
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderButton.h"
#import "TransportModel.h"
@interface VCTransportCapture : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imgInvoice;
@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet BorderButton *btnSave;
@property (weak, nonatomic) IBOutlet BorderButton *btnAccept;
@property (weak, nonatomic) IBOutlet BorderButton *btnDecline;
@property (strong, nonatomic) TransportModel* logModel;
@property (strong, nonatomic) UIImage* invoiceImage;
@property (strong, nonatomic) UIImage* goodImage;

@property (assign, nonatomic) int goodOrInvoice; // invoice :1 good:2
@end
