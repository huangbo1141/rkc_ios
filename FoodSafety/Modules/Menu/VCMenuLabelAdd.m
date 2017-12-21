//
//  VCMenuLabelAdd.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuLabelAdd.h"
#import "TVCellMenuLabel.h"
#import "LabelModel.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Global.h"
#import "VCLabelFilter.h"

@interface VCMenuLabelAdd ()

@end

@implementation VCMenuLabelAdd

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate= self;
    self.tableView.dataSource =self;
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    [self loadData];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

- (void) search:(NSDictionary*) conditions {
    if(self.items == nil) {
        self.items = [[NSMutableArray  alloc ] init];
    }
    
    [[NetworkParser shared] serviceSearchLabels:conditions withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.items = (NSMutableArray*) responseObject;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionFilter:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    
    VCLabelFilter *ivc = [storyboard instantiateViewControllerWithIdentifier:@"VCLabelFilter"];
    ivc.didDismiss = ^(NSDictionary *conditions, NSDictionary* conditionTitles) {
        self.conditions = conditions;
        if(conditionTitles != nil && conditionTitles.count >0) {
            NSString* searchwords = @"";
            NSArray* keys = conditionTitles.allKeys;
            int inc =0;
            for(NSString* key in keys) {
                NSString* value = conditionTitles[key];
                searchwords = [searchwords stringByAppendingString:value];
                inc ++;
                if(![value isEqualToString:@""])
                    searchwords = [searchwords stringByAppendingString:@"|"];
            }
            if(searchwords.length >1)
                searchwords = [searchwords substringToIndex:searchwords.length-1];
            self.lblFilterText.text = searchwords;
            
        }else {
            self.lblFilterText.text = @"No Filter";
        }
        
        [self loadData];
    };
    [self presentViewController:ivc animated:YES completion:nil];
}

- (IBAction)addItem:(id)sender {
    
    for(int i=0; i<self.items.count; i++) {
        LabelModel* model= [self.items objectAtIndex:i];
        if(model.isChecked == YES) {
            BOOL canAdd = YES;
            for(int i=0; i< self.logModel.mLabels.count; i++){
                
                LabelModel* original = [self.logModel.mLabels objectAtIndex:i];
                if([original.mId isEqualToString:model.mId]){
                    canAdd = NO;
                }
                
            }
            if(canAdd)
                [self.logModel.mLabels addObject:model];
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
    if(self.conditions == nil) {
        self.conditions = [[NSMutableDictionary  alloc ] init];
    }
    [self search: self.conditions];
    
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
    LabelModel * model = [self cellModelForIndex:indexPath.row];
    model.isChecked = YES;
}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelModel * model = [self cellModelForIndex:indexPath.row];
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
    return 300;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellMenuLabel";
}

- (LabelModel*) cellModelForIndex: (NSInteger) index{
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
