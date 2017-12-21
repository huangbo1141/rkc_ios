//
//  VCDeliveryList.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryList.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "DeliveryModel.h"
#import "TVCellFridgeLog.h"
@interface VCDeliveryList ()

@end

@implementation VCDeliveryList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void) viewWillAppear:(BOOL)animated {
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
- (IBAction)createAction:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[DeliveryModel alloc] init];
        
        [self gotoDeliveryInfo];
        
    } else {
        [self gotoProfile];
    }
    
}

- (void) initialize {

    [UserInfo shared].currentLogic = @"delivery";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.deliveryLogItems = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"delivery" withCategory:@"log" withFunction:@"create"]){
        [self.btnCreate setHidden:NO];
    }else
        [self.btnCreate setHidden:YES];
    [self loadData];
    
}
- (void) gotoDeliveryInfo {
    
    [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryInfo"];
}


- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}



- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[DeliveryInfoModel alloc] init];
    }
    if(self.deliveryLogItems == nil) {
        self.deliveryLogItems = [[NSMutableArray  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetDeliveryInfo:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (DeliveryInfoModel*) responseObject;
            [UserInfo shared].mDeliveryInfoStore = self.infoModel;
            self.deliveryLogItems = self.infoModel.mLogs;
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
    DeliveryModel * model = [self cellModelForIndex:indexPath.row];
    TVCellFridgeLog* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTime.text = [model getAcceptDatetime];
    cell.lblValue.text = model.mTemperature;
    cell.lblLocation.text = model.mSupplierName;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryDetail"];
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

- (DeliveryModel*) cellModelForIndex: (NSInteger) index{
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
