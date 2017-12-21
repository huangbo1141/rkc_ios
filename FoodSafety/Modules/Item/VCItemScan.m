//
//  VCItemScan.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCItemScan.h"
#import "TVCellItemSearch.h"
#import "UserInfo.h"
#import "LocationModel.h"
#import "QRCodeReaderViewController.h"
#import "Global.h"
#import "NetworkParser.h"
@interface VCItemScan ()<QRCodeReaderDelegate>

@end

@implementation VCItemScan

- (void)viewDidLoad {
    [super viewDidLoad];
    [self search:@""];
    self.logModel = (LogModel*)[UserInfo shared].captureObject;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    [Intercom setLauncherVisible:NO];
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
    [self search:self.tfItem.text];
}
- (IBAction)nextAction:(id)sender {
    if([self confirmData]) {
        if([[UserInfo shared].currentLogic isEqualToString:@"transport"]) {
            [Global switchScreen: self withStoryboardName:@"Transport"  withControllerName:@"VCTransportInfo"];
        }else if([[UserInfo shared].currentLogic isEqualToString:@"delivery"]) {
            [Global switchScreen: self withStoryboardName:@"Delivery"  withControllerName:@"VCDeliveryInfo"];
        }else {
            [Global switchScreen: self withStoryboardName:@"Fridge"  withControllerName:@"VCFridgeInfo"];
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
            NSString* keyCode = resultAsString;
            [[NetworkParser shared] serviceGetItemForKeyCode:keyCode withCompletionBlock:^(id responseObject, NSString *error) {
                if(error == nil) {
                    ItemModel* model = (ItemModel*) responseObject;
                    self.tfItem.text = model.mName;
                    self.logModel.mItem   = model.mId;
                    self.logModel.mItemId    = model.mId;
                    self.logModel.mItemName = model.mName;
                }
            }];
        }

    }];
    
    //[self presentViewController:reader animated:YES completion:NULL];
    [self.navigationController pushViewController:reader animated:YES];
}


#pragma mark - QRCodeReader Delegate Methods

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) search:(NSString*) key {
    if(self.items == nil) {
        self.items = [[NSMutableArray  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetItems:key withCompletionBlock:^(id responseObject, NSString *error) {
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


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    TVCellItemSearch* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblItemName.text =  model.mName;
    cell.lblCreateDate.text = [model getCreateDate];
    cell.lblExpireDate.text = [model getExpireDate];
    
    
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
    return 100;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellItemSearch";
}

- (ItemModel*) cellModelForIndex: (NSInteger) index{
    if( self.items.count > index) {
        return [self.items objectAtIndex:index];
    }else
        return nil;
}

@end
