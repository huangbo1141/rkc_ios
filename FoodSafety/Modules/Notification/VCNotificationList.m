//
//  VCNotificationList.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCNotificationList.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "NotificationModel.h"
#import "TVCellNotification.h"
@interface VCNotificationList ()

@end

@implementation VCNotificationList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
        [Intercom setLauncherVisible:YES];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void) initialize {
    [UserInfo shared].currentLogic = @"notification";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.logs = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    //[self loadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
        [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationModel * model = [self cellModelForIndex:indexPath.row];
    TVCellNotification* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTitle.text = model.mTime;
    cell.lblFrom.text = model.mFrom;
    cell.lblMessage.text = model.mMessage;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    [self gotoDetail];
    
}

- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Notification" withControllerName:@"VCNotificationDetail"];
}


- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[NotificationInfoModel alloc] init];
    }
    if(self.logs == nil) {
        self.logs = [[NSMutableArray  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetNotification:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (NotificationInfoModel*) responseObject;
            [UserInfo shared].mNotificationInfoStore = self.infoModel;
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.tableView reloadData];
            });
            
        }
        [Global stopIndicator:self];
    }];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (long) rowCount{
    return self.infoModel.mLogs.count;
}

- (double) getContainerHeight {
    return [self cellHeight] * self.infoModel.mLogs.count;
}

- (int) cellHeight{
    return 80;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellNotification";
}

- (NotificationModel*) cellModelForIndex: (NSInteger) index{
    if( self.infoModel.mLogs.count > index) {
        return [self.infoModel.mLogs objectAtIndex:index];
    }else
        return nil;
}

- (void) setTableViewHeight :(double) height {
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.tableView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    heightConstraint.constant = height;
    
}

@end
