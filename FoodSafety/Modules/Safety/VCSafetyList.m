//
//  VCSafetyList.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCSafetyList.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "LaboratoryModel.h"
#import "TVCellLaboratory.h"
@interface VCSafetyList ()

@end

@implementation VCSafetyList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}
- (void) initialize {
    [UserInfo shared].currentLogic = @"safety";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"safety" withCategory:@"log" withFunction:@"create"]){
        [self.btnCreate setHidden:NO];
    }else
        [self.btnCreate setHidden:YES];
    self.logs = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    [self loadData];
    
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
    LaboratoryModel * model = [self cellModelForIndex:indexPath.row];
    TVCellLaboratory* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblDate.text = [model getLogDate];
    cell.lblTitle.text = model.mTitle ;
    cell.lblOperator.text = model.mOperatorName;
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LaboratoryModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    [self gotoDetail];
    
}

- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Safety" withControllerName:@"VCSafetyEdit"];
}

- (IBAction)actionCreate:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[LaboratoryModel alloc] init];
        [self gotoDetail];
        
    }
}

- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[LaboratoryInfoModel alloc] init];
    }
    if(self.logs == nil) {
        self.logs = [[NSMutableArray  alloc ] init];
    }
    
    [[NetworkParser shared] serviceGetSafetyInfo:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (LaboratoryInfoModel*) responseObject;
            [UserInfo shared].mLaboratoryInfoStore = self.infoModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
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
    return @"TVCellLaboratory";
}

- (LaboratoryModel*) cellModelForIndex: (NSInteger) index{
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
