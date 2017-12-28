//
//  MyAccordionView.h
//  FoodSafety
//
//  Created by Huang Bo on 12/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccordionView : UIView
@property (weak, nonatomic) IBOutlet UIStackView *stackContent;
+(MyAccordionView*)createView:(NSString*)title List:(NSArray*)list Params:(NSDictionary*)params;
@property (strong, nonatomic) NSDictionary* params;
@property (strong, nonatomic) NSArray* list;
@property (copy, nonatomic) NSString* title;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@end
