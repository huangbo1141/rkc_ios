//
//  VCCoolingList.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCCoolingList.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "LogModel.h"
#import "TVCellFridgeLog.h"
@interface VCCoolingList ()

@end

@implementation VCCoolingList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [Intercom setLauncherVisible:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}

- (IBAction)cameraAction:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[LogModel alloc] init];
        [self gotoLocation];
        
    } else {
        [self gotoProfile];
    }
    
}

- (void) initialize {

    [UserInfo shared].currentLogic = @"cooling";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.coolingLogItems = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"cooling" withCategory:@"log" withFunction:@"capture"]){
        [self.btnCamera setHidden:NO];
    }else
        [self.btnCamera setHidden:YES];
 //   [self loadData];
    
}
- (void) gotoLocation {
    [Global switchScreen:self withStoryboardName:@"Item" withControllerName:@"VCItemScan"];
}
- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Reheating" withControllerName:@"VCReheatingDetail"];
}

- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}



- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[InfoModel alloc] init];
    }
    if(self.coolingLogItems == nil) {
        self.coolingLogItems = [[NSMutableArray  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetCoolingInfo:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (InfoModel*) responseObject;
            [UserInfo shared].mInfoStore = self.infoModel;
            if(self.infoModel != nil)
                [self refreshTableView];
        }
        [Global stopIndicator:self];
    }];
}

- (void) refreshTableView {
    
    [self.tableView reloadData];
    
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogModel * model = [self cellModelForIndex:indexPath.row];
    TVCellFridgeLog* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTime.text = [model getCaptureDatetime];
    cell.lblValue.text = model.mCaptureValue;
    cell.lblLocation.text = model.mItem;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    [self gotoDetail];
    
}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



//MARK: - Helpers

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
    return @"TVCellFridgeLog";
}

- (LogModel*) cellModelForIndex: (NSInteger) index{
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
