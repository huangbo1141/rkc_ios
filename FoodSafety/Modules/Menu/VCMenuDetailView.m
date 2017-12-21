//
//  VCMenuDetailView.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuDetailView.h"
#import "UserInfo.h"
@interface VCMenuDetailView ()

@end

@implementation VCMenuDetailView
@synthesize  lblTitle, lblTime, lblLocation, lblDate, logModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    logModel = (DeliveryMenuModel*)[UserInfo shared].selectedObject;
    self.lblTime.text = [logModel getLogTimeUserFriendly];
    if(logModel.mTitle != nil)
        self.lblTime.text = logModel.mTitle;
    else
        self.lblTime.text =@"";
    
    self.lblDate.text = [logModel getDate];
    self.lblLocation.text = logModel.mLocationName;
    
       
}
@end
