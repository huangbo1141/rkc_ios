//
//  VCLogin.h
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCLogin : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UITextField *tfUserCode;
@property (weak, nonatomic) IBOutlet UIButton* btnSwitch;

@property (weak, nonatomic) IBOutlet UIView* view1_1;
@property (weak, nonatomic) IBOutlet UIView* view1_2;

@property (weak, nonatomic) IBOutlet UIView* view2_1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* const_TOP;
@property (assign, nonatomic) float const_TOP_default;

@property (assign, nonatomic) int m_status;
@end
