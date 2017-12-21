//
//  VCOilList.m
//  FoodSafety
//
//  Created by BoHuang on 9/2/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCOilList.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"
#import "AssignTableCellModel.h"
#import "LogModel.h"
#import "TVCellOilLog.h"

@interface VCOilList ()

@end

@implementation VCOilList


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [Intercom setLauncherVisible:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {

    [UserInfo shared].currentLogic = @"oil";
    
    [self.tableView registerNib:[UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier]];
    
    
    self.oilLogItems = [[NSMutableArray alloc] init];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    if([[UserInfo shared].mAccount.mPermissionModel checkPermission:@"oil" withCategory:@"log" withFunction:@"capture"]){
        [self.btnCamera setHidden:NO];
    }else
        [self.btnCamera setHidden:YES];
    for(int i=0; i<21; i++) {
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
        
        UILabel* textView = [self.view viewWithTag:(i+100)];
        [textView addGestureRecognizer:gestureRecognizer];
    }
    //[self loadData];
    
}

- (void) textViewTapped:(UITapGestureRecognizer *)tapGesture {
    
    UILabel* textView = (UILabel*)tapGesture.view;
    long index =textView.tag - 100;
    NSString* indexString = [NSString stringWithFormat:@"%ld", index];
    if([[UserInfo shared].mAccount checkSignature]) {
        AssignTableCellModel* model = [self.oilAssignModels objectForKey:indexString];
        if(model != nil){
            LogModel* logModel = [[LogModel alloc] init];
            [UserInfo shared].captureObject = logModel;
            logModel.mAssignModel = [model getTableCellModel];
            [self gotoLocation];
        }
        
        
    }else {
        [self gotoProfile];
    }
    
    
}
- (IBAction)actionMenu:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}
- (IBAction)actionCapture:(id)sender {
    if([[UserInfo shared].mAccount checkSignature]){
        [UserInfo shared].captureObject = [[LogModel alloc] init];
        [self gotoLocation];
        
    } else {
        [self gotoProfile];
    }
}
- (void) gotoLocation {
    [Global switchScreen:self withStoryboardName:@"Oil" withControllerName:@"VCOilItemAreaScan"];
}
- (void) gotoDetail {
    [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeDetail"];
}

- (void) gotoProfile {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
}



- (void) loadData {
    if(self.infoModel == nil) {
        self.infoModel = [[InfoModel alloc] init];
    }
    if(self.oilLogItems == nil) {
        self.oilLogItems = [[NSMutableArray  alloc ] init];
    }
    if(self.oilAssignModels == nil) {
        self.oilAssignModels = [[NSMutableDictionary  alloc ] init];
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceGetOilInfo:^(id responseObject, NSString *error) {
        if(error == nil) {
            self.infoModel = (InfoModel*) responseObject;
            [UserInfo shared].mInfoStore = self.infoModel;
            for(int i=0; i<self.infoModel.mAssigns.count; i++) {
                AssignTableCellModel* model = [self.infoModel.mAssigns objectAtIndex:i];
                int index = [model getTableCellIndex];
                NSString* indexString = [NSString stringWithFormat:@"%i", index];
                self.oilAssignModels[indexString] = model;
                UILabel* label =  [self.view viewWithTag:index+100];
                if(label != nil) {
                    label.text = [model getTableCellText];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshTableView];
            });
        }
        [Global stopIndicator:self];
    }];
}

- (void) refreshTableView {
    
    [self.tableView reloadData];
    [self setTableViewHeight:[self getContainerHeight]];
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCount];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogModel * model = [self cellModelForIndex:indexPath.row];
    TVCellOilLog* cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    cell.lblTime.text = [model getCaptureDatetime];
    cell.lblItem.text = model.mItem;
    //cell.lblValue.text = model.mCaptureValue;
    //cell.lblLocation.text = model.mLocation;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogModel * model = [self cellModelForIndex:indexPath.row];
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
    return @"TVCellOilLog";
}

- (LogModel*) cellModelForIndex: (NSInteger) index{
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
