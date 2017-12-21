//
//  VCMenuItemAdd.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuItemAdd.h"
#import "TVCellMenuItem.h"
#import "ItemModel.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "Global.h"
@interface VCMenuItemAdd ()

@end

@implementation VCMenuItemAdd


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

- (void) search:(NSString*) key {
    if(self.items == nil) {
        self.items = [[NSMutableArray  alloc ] init];
    }
    
    [[NetworkParser shared] serviceGetItems:key withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.items = (NSMutableArray*) responseObject;
           [self.tableView reloadData];
        }
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addItem:(id)sender {
   
    for(int i=0; i<self.items.count; i++) {
        ItemModel* model= [self.items objectAtIndex:i];
        if(model.isChecked == YES) {
            BOOL canAdd = YES;
            for(int i=0; i< self.logModel.mItemModels.count; i++){
            
                ItemModel* original = [self.logModel.mItemModels objectAtIndex:i];
                if([original.mId isEqualToString:model.mId]){
                    canAdd = NO;
                }
                
            }
            if(canAdd)
            [self.logModel.mItemModels addObject:model];
        }
    }
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actionSearch:(id)sender {
    NSString* searchString = self.tfSearch.text;
    [self search: searchString];
}


- (void) loadData {
    self.logModel = (DeliveryMenuModel*)[UserInfo shared].captureObject;
    [self search: @""];
    [self.tableView  reloadData];
    
}
- (void) deleteItem:(UIButton *) sender {
    
    long row =  sender.tag;
    [self.items removeObjectAtIndex:row];
    [self.tableView reloadData];
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
     ItemModel * model = [self cellModelForIndex:indexPath.row];
    model.isChecked = YES;
}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    model.isChecked = NO;
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
