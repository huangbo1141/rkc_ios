//
//  MyAccordionCell.m
//  FoodSafety
//
//  Created by Huang Bo on 12/27/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "MyAccordionCell.h"
#import "HttpUtils.h"
#import "UserInfo.h"
#import "Global.h"
@implementation MyAccordionCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)clickView:(UIView*)sender{
    if (self.model!=nil) {
        NSString* isComplete = self.model.mParams[@"isComplete"];
        BOOL b = false;
        if (![isComplete isEqualToString:@"0"]) {
            b = false;
            self.circleButton.backMode = 1;
        }else{
            self.circleButton.backMode = 2;
            b = true;
        }
        [self switchTask:b];
    }
}
-(void)switchTask:(BOOL)b{
    NSMutableDictionary *params= [[NSMutableDictionary alloc] init];
    
    params[@"token"] = [UserInfo shared].mAccount.mToken;
    params[@"task_id"] = self.model.mParams[@"id"];
    NSString* isComplete = self.model.mParams[@"isComplete"];
    if (b) {
        params[@"complete"] = @"1";
    }else{
        params[@"complete"] = @"0";
    }
    
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CHECKLIST_CHECK];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* dict = responseObject;
            if (dict[@"valid"]!=nil && [dict[@"valid"] intValue] == 1) {
                if (b) {
                    self.model.mParams[@"isComplete"] = @"1";
                }else{
                    self.model.mParams[@"isComplete"] = @"0";
                }
                return;
            }else{
                // fail
                if ([isComplete isEqualToString:@"0"]) {
                    self.circleButton.backMode = 1;
                }else{
                    self.circleButton.backMode = 2;
                }
            }
        }else {
            
        }
    }];
}
@end
