//
//  VCMenuList.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuList.h"
#import "VCMenuFilter.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "TVCellDeliveryMenu.h"
#import "DeliveryMenuModel.h"
#import "Global.h"
@interface VCMenuList ()

@end

@implementation VCMenuList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Intercom setLauncherVisible:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK - IBActions

- (IBAction)actionFilter:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    
    VCMenuFilter *ivc = [storyboard instantiateViewControllerWithIdentifier:@"VCMenuFilter"];
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
- (IBAction)actionNewMenu:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[DeliveryMenuModel alloc] init];
        [self gotoItemCreate];
        
    } else {
        [self gotoProfile];
    }
}
- (IBAction)backAction:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}

- (IBAction)sortTitle:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(DeliveryMenuModel*)a mTitle];
        NSString *second = [(DeliveryMenuModel*)b mTitle];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)sortDate:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(DeliveryMenuModel*)a mLogDate];
        NSString *second = [(DeliveryMenuModel*)b mLogDate];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)sortLocation:(id)sender {
    NSArray *sortedArray;
    sortedArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(DeliveryMenuModel*)a mLocationName];
        NSString *second = [(DeliveryMenuModel*)b mLocationName];
        return [first compare:second];
    }];
    self.items = [sortedArray mutableCopy];
    [self.tableView reloadData];
}



- (void) initialize {

    [UserInfo shared].currentLogic = @"delivery_menu";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.items = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"delivery" withCategory:@"menu" withFunction:@"create"]){
        [self.createItem setHidden:NO];
    }else
        [self.createItem setHidden:YES];
    [self loadData];
    
}


- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[MenuInfoModel alloc] init];
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
    [[NetworkParser shared] serviceGetMenuInfo: ^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (MenuInfoModel*) responseObject;
            [UserInfo shared].mMenuInfoStore  = self.infoModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
        }
        [Global stopIndicator:self];
    }];
}

- (void) gotoItemCreate {
    [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuInfo"];
}
- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuDetail"];
}

- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryMenuModel * model = [self cellModelForIndex:indexPath.row];
    TVCellDeliveryMenu* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTitle.text = model.mTitle;
    cell.lblDate.text = model.mLogDate;
    cell.lblLocation.text = model.mLocationName;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryMenuModel * model = [self cellModelForIndex:indexPath.row];
    [UserInfo shared].selectedObject = model;
    [self gotoDetail];
    
}



- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



//MARK: - Helpers

- (long) rowCount{
    return self.infoModel.mLogs.count;
}

- (double) getContainerHeight {
    return [self cellHeight] * self.infoModel.mLogs.count;
}

- (int) cellHeight{
    return 80;
}

- (NSString*) cellReuseIdentifier {
    return @"TVCellDeliveryMenu";
}

- (DeliveryMenuModel*) cellModelForIndex: (NSInteger) index{
    if( self.infoModel.mLogs.count > index) {
        return [self.infoModel.mLogs objectAtIndex:index];
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
