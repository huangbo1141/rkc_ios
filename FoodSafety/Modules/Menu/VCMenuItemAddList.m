//
//  VCMenuItemAddList.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuItemAddList.h"
#import "TVCellMenuItem.h"
#import "ItemModel.h"
#import "UserInfo.h"
#import "Global.h"
#import "VCPrint.h"
@interface VCMenuItemAddList ()
@end

@implementation VCMenuItemAddList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate= self;
    self.tableView.dataSource =self;
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

- (void) loadData {
    self.logModel = (DeliveryMenuModel*)[UserInfo shared].captureObject;
    self.items = self.logModel.mItemModels;
    [self.tableView  reloadData];
    
}
- (void) deleteItem:(UIButton *) sender {
    
    long row =  sender.tag;
    [self.items removeObjectAtIndex:row];
    [self.tableView reloadData];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuLabelAddList"];
}

- (IBAction)addItem:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuItemAdd"];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    TVCellMenuItem* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblItemName.text = model.mName;
    cell.lblExpireDate.text = model.mExpireDate;
    [cell.btnDelete addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)printAllergen:(id)sender {
    NSString* alergens = [_logModel getAllergensString];
    if(alergens != nil && ![alergens isEqualToString:@""]) {
        [UserInfo shared].selectedObject = _logModel;
        
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName: @"Print" bundle:nil];
        VCPrint* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"VCPrint"];
        vc.printType = @"print_menu_alergens";
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//MARK: - Helpers

- (long) rowCount{
    return self.items.count;
}

- (double) getContainerHeight {
    return [self cellHeight] * self.items.count;
}

- (int) cellHeight{
    return 80;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellMenuItem";
}

- (ItemModel*) cellModelForIndex: (NSInteger) index{
    if( self.items.count > index) {
        return [self.items objectAtIndex:index];
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
