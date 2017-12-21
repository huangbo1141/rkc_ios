//
//  VCCleaningList.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCCleaningList.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "CalendarAssignModel.h"
#import "TVCellCleaningAssign.h"
#import "LogModel.h"
#import "TVCellOilLog.h"
#import "Global.h"

@interface VCCleaningList ()
@property (strong, nonatomic) NSCalendar *gregorian;
@end

@implementation VCCleaningList


- (void)viewDidLoad {
    [super viewDidLoad];
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    // Do any additional setup after loading the view.
    [self initialize];

    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    [UserInfo shared].currentLogic = @"cleaning";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier:self.tableView] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier:self.tableView]];
    
    [self.assignTableView registerNib:[UINib nibWithNibName:@"TVCellCleaningAssign" bundle:nil] forCellReuseIdentifier:@"TVCellCleaningAssign"];
    self.calendarView.delegate = self;
    self.calendarView.dataSource =self;
    
    self.cleaningLogItems = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    self.cleaningAssignModels = [[NSMutableArray alloc] init];
    self.assignTableView.dataSource =self;
    self.assignTableView.delegate = self;
    
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"cleaning" withCategory:@"log" withFunction:@"capture"]){
        [self.btnCamera setHidden:NO];
    }else
        [self.btnCamera setHidden:YES];
    //[self loadData];
    
}

- (IBAction)actionMenu:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}
- (IBAction)actionCapture:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[LogModel alloc] init];
        [self gotoLocation];
        
    } else {
        [self gotoProfile];
    }
}
- (void) gotoLocation {
    [Global switchScreen:self withStoryboardName:@"Cleaning" withControllerName:@"VCCleaningItemAreaScan"];
}
- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeDetail"];
}

- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}



- (void) loadData {
    [Intercom setLauncherVisible:YES];
    if(self.infoModel == nil) {
        self.infoModel = [[InfoModel alloc] init];
    }
    if(self.cleaningLogItems == nil) {
        self.cleaningLogItems = [[NSMutableArray  alloc ] init];
    }
    if(self.cleaningAssignModels == nil) {
        self.cleaningAssignModels = [[NSMutableArray  alloc ] init];
    }
   
    NSString* firstDay  = [[SettingModel shared] getMysqlDateStringFromDate:[Global getFirstDayOfYear]];
    NSString* lastDay = [[SettingModel shared] getMysqlDateStringFromDate:[Global getLastDayOfYear]];
    if(firstDay == nil || lastDay == nil)
        return;
     [Global showIndicator:self];
    [[NetworkParser shared] serviceGetCleaningInfo:firstDay withEndDate:lastDay withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (InfoModel*) responseObject;
            [UserInfo shared].mInfoStore = self.infoModel;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshTableView];
                [self.calendarView reloadData];
            });
            
        }
        [Global stopIndicator:self];
    }];
}

- (NSMutableArray*) assignsForSelectedDate :(NSDate*) selectedDate {
    NSString* dateString = [[SettingModel shared] getMysqlDateStringFromDate:selectedDate];
    NSMutableArray* assigns = [[NSMutableArray alloc] init];
    for(CalendarAssignModel* model in self.infoModel.mCalendarAssigns) {
        if([model.mDate isEqualToString:dateString]) {
            [assigns  addObject:model];
        }
    }
    return assigns;
}
-(long) assignCountForSelectedDate :(NSDate*) selectedDate {
    NSMutableArray* assigns = [self assignsForSelectedDate:selectedDate];
    return assigns.count;
}

-(void) loadAssignsForSelectedDate :(NSDate*) selectedDate {
    NSMutableArray* assigns = [self assignsForSelectedDate:selectedDate];
    self.cleaningAssignModels = assigns;
    [self.assignTableView reloadData];
    [self setTableViewHeight:self.assignTableView withHeight: [self getContainerHeight:self.assignTableView]];
}

- (void) refreshTableView {
    
    [self.tableView reloadData];
    [self setTableViewHeight:self.tableView withHeight: [self getContainerHeight:self.tableView]];
    [self setTableViewHeight:self.assignTableView withHeight: [self getContainerHeight:self.assignTableView]];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount:tableView];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView) {
    
        LogModel * model = [self.infoModel.mLogs objectAtIndex: indexPath.row];
        TVCellOilLog* cell = [tableView dequeueReusableCellWithIdentifier: @"TVCellOilLog" forIndexPath:indexPath];
        cell.lblTime.text = [model getCaptureDatetime];
        cell.lblItem.text = model.mItem;
        return cell;

        
    }else {
        CalendarAssignModel * model = [self.cleaningAssignModels objectAtIndex: indexPath.row];
        TVCellCleaningAssign* cell = [tableView dequeueReusableCellWithIdentifier: @"TVCellCleaningAssign" forIndexPath:indexPath];
        cell.lblItem.text = model.mItem;
        cell.lblTime.text = [model getTimeString];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight:tableView];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView) {
        LogModel * model = [self.infoModel.mLogs objectAtIndex: indexPath.row];
        [UserInfo shared].selectedObject = model;
        [self gotoDetail];
        
    }else {
        CalendarAssignModel* model = [self.cleaningAssignModels objectAtIndex:indexPath.row];
        LogModel* logModel = [[LogModel alloc] init];
        [UserInfo shared].captureObject = logModel;
        
        logModel.mAssignModel = model;
        [self gotoLocation];
        
    }


}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



//MARK: - Helpers

- (long) rowCount:(UITableView*) tableView{
    if(tableView == self.tableView)
        return self.infoModel.mLogs.count;
    else if(tableView == self.assignTableView)
        return self.cleaningAssignModels.count;
    return 0;
}

- (double) getContainerHeight:(UITableView*) tableView {
    
    if(tableView == self.tableView)
        return [self  cellHeight:tableView] * self.infoModel.mLogs.count;
    else if(tableView == self.assignTableView)
        return [self  cellHeight:tableView] * self.cleaningAssignModels.count;
    return 0;
}

- (int) cellHeight:(UITableView*) tableView{
     if(tableView == self.tableView)
        return 80;
    else
        return 80;
}

- (NSString*) cellReuseIdentifier:(UITableView*) tableView {
    if(tableView == self.tableView)
        return @"TVCellOilLog";
    else if(tableView == self.assignTableView)
        return @"TVCellCleaningAssign";
    return @"";

}


- (void) setTableViewHeight:(UITableView*) tableView  withHeight:(double) height {
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in tableView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    heightConstraint.constant = height;
    
}


#pragma mark - FSCalendarDataSource

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return [self assignCountForSelectedDate:date];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self loadAssignsForSelectedDate:date];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{

}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendarView.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendarView dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendarView monthPositionForCell:obj];
      //  [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}


@end
