//
//  VCMenuDetailView.h
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryMenuModel.h"
@interface VCMenuDetailView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UITextView *lblTime;
@property (strong, nonatomic) DeliveryMenuModel* logModel;
-(void) loadData;
@end
