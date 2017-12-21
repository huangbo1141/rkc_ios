//
//  VCCleaningItemAreaScan.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCCleaningItemAreaScan.h"
#import "TVCellOilItemSearch.h"
#import "UserInfo.h"
#import "LocationModel.h"
#import "QRCodeReaderViewController.h"
#import "Global.h"
#import "NetworkParser.h"
#import "CalendarAssignModel.h"
@interface VCCleaningItemAreaScan ()<QRCodeReaderDelegate>

@end

@implementation VCCleaningItemAreaScan

- (void)viewDidLoad {
    [super viewDidLoad];
        [Intercom setLauncherVisible:NO];
    //[self search:@"" withAreaId:@""];
    self.logModel = (LogModel*)[UserInfo shared].captureObject;
    
    self.infoModel = (InfoModel*)[UserInfo shared].mInfoStore;
    self.pVArea = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVArea setDataSource: self];
    [self.pVArea setDelegate: self];
    self.pVArea.showsSelectionIndicator = YES;
    self.tfArea.inputView = self.pVArea;
    self.tfArea.delegate =self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    CalendarAssignModel* assignModel= (CalendarAssignModel*) self.logModel.mAssignModel;
    if(assignModel != nil) {
        self.logModel.mAreaId = assignModel.mLocationId;
        self.logModel.mAreaName = assignModel.mLocation;
        self.logModel.mItem = assignModel.mItemId;
        self.tfItem.text = assignModel.mItem;
        self.tfArea.text = assignModel.mLocation;
        
        self.logModel.mLocation = assignModel.mLocationId;
        self.logModel.mItemName = assignModel.mItem;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchAction:(id)sender {
    if(self.logModel.mLocation == nil) {
        [Global AlertMessage:self Message:@"Please input area." Title:@"Alert"];
        return;
    }
    [self search:self.tfItem.text withAreaId:self.logModel.mLocation];
}
- (IBAction)nextAction:(id)sender {
    if([self confirmData]) {
        if([[UserInfo shared].currentLogic isEqualToString:@"cleaning"]) {
            [Global switchScreen: self withStoryboardName:@"Cleaning"  withControllerName:@"VCCleaningInfo"];
        }
    }
}


- (BOOL) confirmData {
    if(self.logModel.mItem == nil || [self.logModel.mItem isEqualToString:@""])
        return false;
    return true;
}

- (IBAction)qrScanAction:(id)sender {
    
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        if(resultAsString != nil){
            [wSelf.navigationController popViewControllerAnimated:YES];
            NSString* payload = resultAsString;
            NSArray* params =  [payload componentsSeparatedByString:@":"];
            if(params.count == 2) {
                NSString* itemId = params[0];
                [[NetworkParser shared] serviceGetCleaningItem:itemId withCompletionBlock:^(id responseObject, NSString *error) {
                    if(error == nil) {
                        ItemModel* model = (ItemModel*) responseObject;
                        self.tfItem.text = model.mName;
                        self.tfArea.text = model.mAreaName;
                        self.logModel.mItem   = model.mId;
                        self.logModel.mItemId    = model.mId;
                        self.logModel.mItemName = model.mName;
                        self.logModel.mAreaId = model.mAreaId;
                        self.logModel.mAreaName = model.mAreaName;
                    }
                }];
            }
        }


    }];
    
    //[self presentViewController:reader animated:YES completion:NULL];
    [self.navigationController pushViewController:reader animated:YES];
}
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
      

    }];
}

- (void) search:(NSString*) key withAreaId:(NSString*) areaId{
    if(self.items == nil) {
        self.items = [[NSMutableArray  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetCleaningItems:key withAreaId:areaId withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.items = (NSMutableArray*) responseObject;
            [self refreshTableView];
        }
        [Global stopIndicator:self];
    }];
}

- (void) refreshTableView {
    
    [self.tableView reloadData];
    
}
#pragma mark - UIPickerView Delegate

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.infoModel.mLocations.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LocationModel* model = [self.infoModel.mLocations objectAtIndex:row];
    return model.mName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LocationModel* model = [self.infoModel.mLocations objectAtIndex:row];
    self.tfArea.text = model.mName;
    self.logModel.mLocation = model.mId;
    self.tfItem.text = @"";
    [self search:self.tfItem.text withAreaId: model.mId];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    TVCellOilItemSearch* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblItemName.text =  model.mName;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    
    self.tfItem.text = model.mName;
    self.logModel.mItem   = model.mId;
    self.logModel.mItemId    = model.mId;
    self.logModel.mItemName = model.mName;
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



//MARK: - Helpers

- (long) rowCount{
    return self.items.count;
}


- (int) cellHeight{
    return 50;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellOilItemSearch";
}

- (ItemModel*) cellModelForIndex: (NSInteger) index{
    if( self.items.count > index) {
        return [self.items objectAtIndex:index];
    }else
        return nil;
}

@end
