//
//  VCCleaningList.h
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
#import "FSCalendar.h"

@interface VCCleaningList : UIViewController<UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>

@property (weak, nonatomic) IBOutlet UITableView *assignTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) InfoModel* infoModel;
@property (strong, nonatomic) NSMutableArray* cleaningLogItems;
@property (strong, nonatomic) NSMutableArray* cleaningAssignModels;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;

@end
