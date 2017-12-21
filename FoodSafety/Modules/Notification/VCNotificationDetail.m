//
//  VCNotificationDetail.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCNotificationDetail.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "Global.h"
@interface VCNotificationDetail ()

@end

@implementation VCNotificationDetail
@synthesize lblFrom, tvDescription, logModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initialize {
    logModel = (NotificationModel*)[UserInfo shared].selectedObject;
    if(logModel.mFrom != nil)
        self.lblFrom.text = logModel.mFrom;
    else
        self.lblFrom.text =@"";
    if(logModel.mMessage != nil)
        self.tvDescription.text = logModel.mMessage;
    else
        self.tvDescription.text =@"";
}


- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backAction:(id)sender {
    [self goBack];
}
- (IBAction)deleteAction:(id)sender {
    if(self.logModel != nil  && self.logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteNotification:self.logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self goBack];
            }
            [Global stopIndicator:self];
        }];
    }
}


@end
