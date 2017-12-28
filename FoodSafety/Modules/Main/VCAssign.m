//
//  VCAssign.m
//  FoodSafety
//
//  Created by BoHuang on 8/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCAssign.h"
#import "Global.h"
#import "Language.h"
#import "NetworkParser.h"
#import "AssignTaskModel.h"
#import "UserInfo.h"
#import "CircleBorderImageView.h"
#import "MyAccordionView.h"

@interface VCAssign ()
@property (assign, nonatomic) long totalAssignViewHeight;
@end

@implementation VCAssign

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.assignTaskItems = [[NSMutableArray alloc] init];
    [self loadData];
    [[UserInfo shared] intercomUpdatePagePosition:@"Today's Assign"];
    
    [Intercom setLauncherVisible:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogout:(id)sender {
    [[UserInfo shared] setLogined:false];
    [[UserInfo shared] setToken:@""];
    [UserInfo shared].mAccount.mToken = @"";
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCConnect" withOptions:@{@"reset":@"1"}];
}

- (IBAction)actionMenu:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}
- (void) configView {
    for(UIView* view in self.navigationController.viewControllers){
        NSLog(@"view %@",view);
    }
    
    NSArray* array = self.stackView.subviews;
    for (UIView* view in array) {
//        [view removeFromSuperview];
        [self.stackView removeArrangedSubview:view];
    }
    
    self.totalAssignViewHeight = 50;
    //[self.assignContainer removeAllSubviews];
    if (self.map_data[@"fridges"]) {
        NSArray* array = self.map_data[@"fridges"];
        if (array.count>0) {
            NSString* title = kLang(@"assign_header_fridge");
            UIView* view = [MyAccordionView createView:title List:array Params:@{@"vc":self}];
            [self.stackView addArrangedSubview:view];
        }
    }
    if (self.map_data[@"freezers"]) {
        NSArray* array = self.map_data[@"freezers"];
        if (array.count>0) {
            NSString* title = kLang(@"assign_header_freezer");
            UIView* view = [MyAccordionView createView:title List:array Params:@{@"vc":self}];
            [self.stackView addArrangedSubview:view];
        }
    }
    if (self.map_data[@"oils"]) {
        NSArray* array = self.map_data[@"oils"];
        if (array.count>0) {
            NSString* title = kLang(@"assign_header_oil");
            UIView* view = [MyAccordionView createView:title List:array Params:@{@"vc":self}];
            [self.stackView addArrangedSubview:view];
        }
    }
    if (self.map_data[@"cleanings"]) {
        NSArray* array = self.map_data[@"cleanings"];
        if (array.count>0) {
            NSString* title = kLang(@"assign_header_cleaning");
            UIView* view = [MyAccordionView createView:title List:array Params:@{@"vc":self}];
            [self.stackView addArrangedSubview:view];
        }
    }
    if (self.map_data[@"expire"]) {
        NSArray* array = self.map_data[@"expire"];
        if (array.count>0) {
            NSString* title = kLang(@"assign_header_customtask");
            UIView* view = [MyAccordionView createView:title List:array Params:@{@"vc":self}];
            [self.stackView addArrangedSubview:view];
        }
    }
}


- (void) loadData {
    //[self.assignTaskItems removeAllObjects];
    [Global showIndicator:self];
    [[NetworkParser shared] serviceTodayTask:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSMutableDictionary* map= responseObject;
            self.map_data = map;
            [self configView];
        }
        [Global stopIndicator:self];
    }];
}
-(void)taskPressedWithModel:(AssignTaskModel*)model {
    if([model.mItemType isEqualToString:@"section"])
        return;
    
    if([model.mTaskType isEqualToString:@"fridge"]) {
        if([[UserInfo shared].mAccount  checkSignature]) {
            [Global showIndicator:self];
            [[NetworkParser shared] serviceGetFridgeInfo:^(id responseObject, NSString *error) {
                if(error == nil) {
                    [UserInfo shared].mInfoStore = (InfoModel*) responseObject;
                    [UserInfo shared].currentLogic = @"fridge";
                    LogModel* logModel = [[LogModel alloc] init];
                    [UserInfo shared].captureObject = logModel;
                    logModel.mLocationCode = model.mParams[@"location_key_code"];
                    [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeLocation"];
                }
                [Global stopIndicator:self];
            }];
        } else {
            [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
        }
        
    }
    if([model.mTaskType isEqualToString:@"freezer"]) {
        if([[UserInfo shared].mAccount  checkSignature]) {
            [Global showIndicator:self];
            [[NetworkParser shared] serviceGetFreezerInfo:^(id responseObject, NSString *error) {
                if(error == nil) {
                    [UserInfo shared].mInfoStore = (InfoModel*) responseObject;
                    [UserInfo shared].currentLogic = @"freezer";
                    LogModel* logModel = [[LogModel alloc] init];
                    [UserInfo shared].captureObject = logModel;
                    logModel.mLocationCode = model.mParams[@"location_key_code"];
                    [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeLocation"];
                }
                [Global stopIndicator:self];
            }];
        }else {
            [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
        }
        
    }
    if([model.mTaskType isEqualToString:@"expire"]) {
        if([[UserInfo shared].mAccount  checkSignature]) {
            [Global showIndicator:self];
            [[NetworkParser shared] serviceGetItemInfo:[[NSDictionary alloc] init] withCompletionBlock:^(id responseObject, NSString *error) {
                if(error == nil) {
                    [UserInfo shared].mItemInfoStore = (ItemInfoModel*) responseObject;
                    [UserInfo shared].currentLogic = @"item";
                    ItemModel* logModel = [[ItemModel alloc] init];
                    [UserInfo shared].captureObject = logModel;
                    
                    if(model.mParams[@"id"] != nil) logModel.mId = model.mParams[@"id"];
                    if(model.mParams[@"key_code"] != nil) logModel.mKeyCode = model.mParams[@"key_code"];
                    if(model.mParams[@"name"] != nil) logModel.mName = model.mParams[@"name"];
                    if(model.mParams[@"batch"] != nil) logModel.mBatch = model.mParams[@"batch"];
                    if(model.mParams[@"create_date"] != nil) logModel.mCreateDate = model.mParams[@"create_date"];
                    if(model.mParams[@"expire_date"] != nil) logModel.mExpireDate = model.mParams[@"expire_date"];
                    if(model.mParams[@"description"] != nil) logModel.mDescription = model.mParams[@"description"];
                    if(model.mParams[@"creator"] != nil) logModel.mCreator = model.mParams[@"creator"];
                    if(model.mParams[@"allergens"] != nil) {
                        NSString* allergenStr = model.mParams[@"allergens"];
                        if(![allergenStr isKindOfClass:[NSNull class]]) {
                            NSDictionary* allergensDict = [Global jsonToDict:allergenStr];
                            for(NSString* ele in allergensDict) {
                                [logModel.mAllergens addObject:ele];
                            }
                        }
                    }
                    [UserInfo shared].selectedObject = logModel;
                    [Global switchScreen:self withStoryboardName:@"Item" withControllerName:@"VCItemEdit"];
                    
                    
                }
                [Global stopIndicator:self];
            }];
        }else {
            [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
        }
        
    }
    if([model.mTaskType isEqualToString:@"oil"]) {
        if([[UserInfo shared].mAccount  checkSignature]) {
            [Global showIndicator:self];
            [[NetworkParser shared] serviceGetOilInfo:^(id responseObject, NSString *error) {
                if(error == nil) {
                    [UserInfo shared].mInfoStore = (InfoModel*) responseObject;
                    [UserInfo shared].currentLogic = @"oil";
                    LogModel* logModel = [[LogModel alloc] init];
                    [UserInfo shared].captureObject = logModel;
                    AssignModel* assignModel = [[AssignModel alloc] init];
                    assignModel.mLocationId = model.mParams[@"location_id"];
                    assignModel.mLocation = model.mParams[@"area_name"];
                    assignModel.mItemId  = model.mParams[@"item_id"];
                    assignModel.mItem = model.mParams[@"item_name"];
                    logModel.mAssignModel = assignModel;
                    
                    [Global switchScreen:self withStoryboardName:@"Oil" withControllerName:@"VCOilItemAreaScan"];
                }
                [Global stopIndicator:self];
            }];
        }else {
            [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
        }
        
    }
    if([model.mTaskType isEqualToString:@"cleaning"]) {
        if([[UserInfo shared].mAccount  checkSignature]) {
            NSString* firstDay = [[SettingModel shared] getMysqlDateStringFromDate:[Global getFirstDayOfYear]];
            NSString* lastDay = [[SettingModel shared] getMysqlDateStringFromDate:[Global getLastDayOfYear]];            [Global showIndicator:self];
            [[NetworkParser shared] serviceGetCleaningInfo:firstDay withEndDate:lastDay withCompletionBlock:^(id responseObject, NSString *error) {
                if(error == nil) {
                    [UserInfo shared].mInfoStore = (InfoModel*) responseObject;
                    [UserInfo shared].currentLogic = @"cleaning";
                    LogModel* logModel = [[LogModel alloc] init];
                    [UserInfo shared].captureObject = logModel;
                    AssignModel* assignModel = [[AssignModel alloc] init];
                    assignModel.mLocationId = model.mParams[@"location_id"];
                    assignModel.mLocation = model.mParams[@"area_name"];
                    assignModel.mItemId  = model.mParams[@"item_id"];
                    assignModel.mItem = model.mParams[@"item_name"];
                    logModel.mAssignModel = assignModel;
                    
                    [Global switchScreen:self withStoryboardName:@"Cleaning" withControllerName:@"VCCleaningItemAreaScan"];
                }
                [Global stopIndicator:self];
            }];
        }else {
            [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
        }
        
    }
}
- (void)taskPressed : (id) sender
{
    UIButton* taskLink = (UIButton*)sender;
    long index = taskLink.tag;
    //AssignTaskModel* model = [self.assignTaskItems objectAtIndex:index];
    AssignTaskModel* model = nil;
    [self taskPressedWithModel:model];
    
}




@end
