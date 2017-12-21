//
//  VCMenuLabelAddList.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuLabelAddList.h"
#import "TVCellMenuLabel.h"
#import "LabelModel.h"
#import "UserInfo.h"
#import "Global.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VCMenuLabelAddList ()

@end

@implementation VCMenuLabelAddList

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
    self.items = self.logModel.mLabels;
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
    if(self.logModel == nil)
        return;
    
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCreateMenu:self.logModel withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [self gotoList];
        
        }
        
        [Global stopIndicator:self];
        
    }];
}
- (void) gotoList {
    [Global switchScreen:self withStoryboardName: @"Menu" withControllerName:@"VCMenuList"];
}

- (IBAction)addItem:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuLabelAdd"];
}




#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelModel * model = [self cellModelForIndex:indexPath.row];
    TVCellMenuLabel* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    if(model.mBigFile != nil && [model.mBigFile isKindOfClass:[NSString class]] && ![model.mBigFile isEqualToString:@""]){
        [cell.imgLabel sd_setImageWithURL:[NSURL URLWithString:model.mBigFile ]];
    }
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



//MARK: - Helpers

- (long) rowCount{
    return self.logModel.mLabels.count;
}

- (double) getContainerHeight {
    return [self cellHeight] * self.logModel.mLabels.count;
}

- (int) cellHeight{
    return 300;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellMenuLabel";
}

- (LabelModel*) cellModelForIndex: (NSInteger) index{
    if( self.logModel.mLabels.count > index) {
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
