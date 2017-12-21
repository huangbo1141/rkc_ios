//
//  VCTransportList.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCTransportList.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "TransportModel.h"
#import "TVCellTransportLog.h"
@interface VCTransportList ()

@end

@implementation VCTransportList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

        [UserInfo shared].captureObject = [[TransportModel alloc] init];
        [self gotoLocation];
        
    } else {
        [self gotoProfile];
    }
    
}

- (void) initialize {

    [UserInfo shared].currentLogic = @"transport";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.transportLogItems = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"transport" withCategory:@"log" withFunction:@"create"]){
        [self.btnCreate setHidden:NO];
    }else
        [self.btnCreate setHidden:YES];
    [self loadData];
    
}
- (void) gotoLocation {

    [Global switchScreen:self withStoryboardName:@"Item" withControllerName:@"VCItemScan"];
}


- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}



- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[TransportInfoModel alloc] init];
    }
    if(self.transportLogItems == nil) {
        self.transportLogItems = [[NSMutableArray  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetTransportInfo:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (TransportInfoModel*) responseObject;
            [UserInfo shared].mTransportInfoStore = self.infoModel;
            self.transportLogItems = self.infoModel.mLogs;
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
    TransportModel * model = [self cellModelForIndex:indexPath.row];
    TVCellTransportLog* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTime.text = [model getUpdateTime];
    cell.Name.text = model.mItemName;
    cell.lblDepartureTemp.text = model.mDepartureTemp;
    cell.lblArrivalTemp.text = model.mArrivalTemp;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransportModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    if([model isComplete]) {
    
        
        [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportDetail"];
    }else {
        if([[UserInfo shared].mAccount checkSignature]){
            
            [UserInfo shared].captureObject = model;
            [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportDepartureInfo"];
            
        } else {
            [self gotoProfile];
        }
    }
    
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
    return @"TVCellTransportLog";
}

- (TransportModel*) cellModelForIndex: (NSInteger) index{
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
