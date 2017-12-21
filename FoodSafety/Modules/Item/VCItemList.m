//
//  VCItemList.m
//  FoodSafety
//
//  Created by BoHuang on 8/23/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCItemList.h"
#import "VCItemFilter.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "TVCellItemLog.h"
#import "Global.h"

@interface VCItemList ()

@end

@implementation VCItemList

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    [self initialize];

}
- (void) viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self loadData];
    [Intercom setLauncherVisible:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// MARK - IBActions

- (IBAction)actionFilter:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Item" bundle:nil];
    
    VCItemFilter *ivc = [storyboard instantiateViewControllerWithIdentifier:@"VCItemFilter"];
    ivc.conditions = self.conditions;
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
            if([searchwords isEqualToString:@""])
                self.lblFilterText.text = @"No Filter";
        }else {
            self.lblFilterText.text = @"No Filter";
        }
            
        [self loadData];
    };
    [self presentViewController:ivc animated:YES completion:nil];
}
- (IBAction)actionNewItem:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[ItemModel alloc] init];
        [self gotoItemCreate];
        
    } else {
        [self gotoProfile];
    }
}
- (IBAction)backAction:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}

- (IBAction)sortName:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ItemModel*)a mName];
        NSString *second = [(ItemModel*)b mName];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)sortBatch:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ItemModel*)a mBatch];
        NSString *second = [(ItemModel*)b mBatch];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)sortCreate:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ItemModel*)a mCreateDate];
        NSString *second = [(ItemModel*)b mCreateDate];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)sortExpire:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ItemModel*)a mExpireDate];
        NSString *second = [(ItemModel*)b mExpireDate];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}



- (void) initialize {

    [UserInfo shared].currentLogic = @"item";
  
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.items = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"item" withCategory:@"setting" withFunction:@"create"]){
        [self.createItem setHidden:NO];
    }else
        [self.createItem setHidden:YES];

    
}


- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[ItemInfoModel alloc] init];
    }
    if(self.items == nil) {
        self.items = [[NSMutableArray  alloc ] init];
    }
    if(self.conditions == nil) {
        self.conditions = [[NSMutableDictionary  alloc ] init];
    }
    [self search: self.conditions];
}
- (void) search:(NSDictionary*)conditions {
    
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetItemInfo:conditions withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (ItemInfoModel*) responseObject;
            [UserInfo shared].mItemInfoStore = self.infoModel;
            self.items = self.infoModel.mLogs;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
            
        }
        [Global stopIndicator:self];
    }];
}

- (void) gotoItemCreate {
    [Global switchScreen:self withStoryboardName:@"Item" withControllerName:@"VCItemCreate"];
}
- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Item" withControllerName:@"VCItemEdit"];
}

- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    TVCellItemLog* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblName.text = model.mName;
    cell.lblBatch.text = model.mBatch;
    cell.lblCreate.text = [model getCreateDate];
    cell.lblExpire.text = [model getExpireDate];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    [self gotoDetail];
    
}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    return @"TVCellItemLog";
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
