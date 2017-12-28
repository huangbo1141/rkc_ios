//
//  MyAccordionCell.h
//  FoodSafety
//
//  Created by Huang Bo on 12/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"
#import "AssignTaskModel.h"

@interface MyAccordionCell : UIView
@property (weak, nonatomic) IBOutlet CircleButton *circleButton;
@property (weak, nonatomic) IBOutlet UILabel *txt1;
@property (weak, nonatomic) IBOutlet UILabel *txt2;
@property (weak, nonatomic) IBOutlet UILabel *txt3;

@property (strong, nonatomic) AssignTaskModel* model;
@end
