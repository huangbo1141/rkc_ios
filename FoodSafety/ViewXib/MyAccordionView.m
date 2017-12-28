//
//  MyAccordionView.m
//  FoodSafety
//
//  Created by Huang Bo on 12/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "MyAccordionView.h"
#import "AssignTaskModel.h"
#import "MyAccordionCell.h"

@implementation MyAccordionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(MyAccordionView*)createView:(NSString*)title List:(NSArray*)list Params:(NSDictionary*)params{
    if (list.count == 0) {
        return nil;
    }
    UIViewController* vc =  params[@"vc"];
    
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"AssignViews" owner:vc options:nil];
    MyAccordionView* view = array[0];
    view.params = params;
    view.title = title;
    view.list = list;
    
    for (int i=0; i<list.count; i++) {
        AssignTaskModel* item =  list[i];
        NSArray* tarray = [[NSBundle mainBundle] loadNibNamed:@"AssignViews" owner:vc options:nil];
        MyAccordionCell* cell = tarray[1];
        cell.txt1.text = item.mParams[@"task_title"];
        cell.txt2.text = item.mParams[@"task_detail"];
        cell.txt3.text = item.mParams[@"owner"];
        NSString* isComplete = item.mParams[@"isComplete"];
        if ([isComplete isEqualToString:@"0"]) {
            cell.circleButton.backMode = 1;
        }else{
            cell.circleButton.backMode = 2;
        }
        cell.model = item;
        [cell.circleButton addTarget:cell action:@selector(clickView:) forControlEvents:UIControlEventTouchUpInside];
        [view.stackContent addArrangedSubview:cell];
    }
    view.lblHeader.text = title;
    view.stackContent.hidden = true;
    [view setViews];
    
    return view;
}
- (IBAction)toggleShow:(id)sender {
    [self toggleContent];
}

-(void)toggleContent{
    self.stackContent.hidden = !self.stackContent.hidden;
    [self setViews];
}
-(void)setViews{
    if (self.stackContent.hidden) {
        self.imgArrow.image = [UIImage imageNamed:@"ic_arrow_right"];
    }else{
        self.imgArrow.image = [UIImage imageNamed:@"ic_arrow_down"];
    }
}
@end
