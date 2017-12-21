//
//  VCMultiSelect.m
//  FoodSafety
//
//  Created by BoHuang on 8/24/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMultiSelect.h"
#import "MultiSelectCellModel.h"
#import "TVCellMultiSelect.h"

@interface VCMultiSelect ()

@end

@implementation VCMultiSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    if(self.items == nil)
    self.items = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
}
- (void) setAllergens:(NSMutableArray*) items {
    self.items = items;
    [self.tableView reloadData];
    int inc =0;
 /*   for(MultiSelectCellModel*  model in self.items) {
        if(model.isSelected) {
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:inc inSection:0];
            [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
            [self.tableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        inc ++;
    }*/
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MultiSelectCellModel * model = [self cellModelForIndex:indexPath.row];
    TVCellMultiSelect* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTitle.text = model.mText;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultiSelectCellModel * model = [self cellModelForIndex:indexPath.row];
 
    if(model.isSelected) {
        [cell setSelected:YES animated:NO];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

    }else {
        [cell setSelected:NO animated:NO];
    }

}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultiSelectCellModel * model = [self cellModelForIndex:indexPath.row];
    model.isSelected = YES;
    
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultiSelectCellModel * model = [self cellModelForIndex:indexPath.row];
    model.isSelected = NO;
}



//MARK: - Helpers

- (long) rowCount{
    return self.items.count;
}


- (int) cellHeight{
    return 50;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellMultiSelect";
}

- (MultiSelectCellModel*) cellModelForIndex: (NSInteger) index{
    if( self.items.count > index) {
        return [self.items objectAtIndex:index];
    }else
        return nil;
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:false];
}

- (IBAction)saveAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:false];
    if (self.didDismiss)
        self.didDismiss(self.items);
}


@end
