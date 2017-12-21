//
//  VCDeliveryLabelDetailView.m
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryLabelDetailView.h"
#import "TVCellLabel.h"
#import "UserInfo.h"
#import "VCDeliveryLabelUpload.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VCDeliveryLabelDetailView ()

@end

@implementation VCDeliveryLabelDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.labelItems= [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.logModel =  (DeliveryModel*)[UserInfo shared].selectedObject;
    self.labelItems =  self.logModel.mLabels;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData {

    self.logModel =  (DeliveryModel*)[UserInfo shared].selectedObject;
    self.labelItems =  self.logModel.mLabels;
    [self.tableView reloadData];
}
- (IBAction)addAction:(id)sender {
    [UserInfo shared].captureObject = self.logModel;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName: @"Delivery" bundle:nil];
    VCDeliveryLabelUpload* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"VCDeliveryLabelUpload"];
    vc.fromVC = @"VCDeliveryLabelDetailView.h";
    [self.navigationController pushViewController:vc animated:YES];
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
    [cell.imgLabel setImage: model.mLocalImage];
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
    return self.labelItems.count;
}

- (double) getContainerHeight {
    return [self cellHeight] * self.labelItems.count;
}

- (int) cellHeight{
    return 200;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellLabel";
}

- (LabelModel*) cellModelForIndex: (NSInteger) index{
    if( self.labelItems.count > index) {
        return [self.labelItems objectAtIndex:index];
    }else
        return nil;
}



@end
