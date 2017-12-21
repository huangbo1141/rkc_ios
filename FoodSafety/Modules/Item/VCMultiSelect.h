//
//  VCMultiSelect.h
//  FoodSafety
//
//  Created by BoHuang on 8/24/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCMultiSelect : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* items;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void (^didDismiss)(NSArray *items);
-(void) setAllergens:(NSMutableArray*)items;
@end
