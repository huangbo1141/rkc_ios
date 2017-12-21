//
//  VCMenuDetailLabel.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuDetailLabel.h"
#import "TVCellLabel.h"
#import "LabelModel.h"
#import "UserInfo.h"
#import "Global.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VCMenuDetailLabel ()

@end

@implementation VCMenuDetailLabel

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
    self.logModel = (DeliveryMenuModel*)[UserInfo shared].selectedObject;
    self.items = self.logModel.mLabels;
    [self.tableView  reloadData];
    
}



#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelModel * model = [self cellModelForIndex:indexPath.row];
    TVCellLabel* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    if(model.mBigFile != nil && [model.mBigFile isKindOfClass:[NSString class]] && ![model.mBigFile isEqualToString:@""]){
        [cell.imgLabel sd_setImageWithURL:[NSURL URLWithString:model.mBigFile ]];
    }
    
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
    return @"TVCellLabel";
}

- (LabelModel*) cellModelForIndex: (NSInteger) index{
    if( self.logModel.mLabels.count > index) {
        return [self.logModel.mLabels objectAtIndex:index];
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
