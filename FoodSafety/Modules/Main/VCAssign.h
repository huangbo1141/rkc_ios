//
//  VCAssign.h
//  FoodSafety
//
//  Created by BoHuang on 8/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLinearLayout.h"
#import "MyRelativeLayout.h"

@interface VCAssign : UIViewController
//@property (weak, nonatomic) IBOutlet MyLinearLayout *assignContainer;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) NSMutableDictionary* map_data;
@end
