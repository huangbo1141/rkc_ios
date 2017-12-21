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

@interface VCAssign ()
@property (assign, nonatomic) long totalAssignViewHeight;
@end

@implementation VCAssign

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.assignTaskItems = [[NSMutableArray alloc] init];
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
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCConnect"];
    
    
}

- (IBAction)actionMenu:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenu"];
}
- (void) configView {
    self.assignContainer.orientation = MyOrientation_Vert;
    self.totalAssignViewHeight = 50;
    //[self.assignContainer removeAllSubviews];
    NSMutableArray* models = nil;
    NSString* sectionTitle = @"";
    NSString* sectionImageName = @"";
    for(int i=0; i<self.assignTaskItems.count; i++) {
        AssignTaskModel* item = [self.assignTaskItems objectAtIndex:i];
        if([item.mItemType isEqualToString:@"section"]) {
            if(models != nil) {
                UIView* view = [self createAssignSection:sectionTitle withSectionImageName:sectionImageName withModels:models];
                if(view != nil) [self.assignContainer addSubview:view];
                
            }
            models = [[NSMutableArray alloc] init];
            sectionImageName = [item getLogoImageName];
            sectionTitle = [item getSectionTitle];
        }else {
            if(models != nil) [models addObject:item];
        }
    }
    
    if(models != nil) {
        MyLinearLayout* view = [self createAssignSection:sectionTitle withSectionImageName:sectionImageName withModels:models];
   
        if(view != nil) [self.assignContainer addSubview:view];
    }
    if(_totalAssignViewHeight < 300)
        _totalAssignViewHeight = 300;
    
    [self setAssignContainerHeight:_totalAssignViewHeight];
}
-(MyLinearLayout*) createAssignSection:(NSString*) sectionTitle withSectionImageName:(NSString*) sectionImageName withModels:(NSArray*) models {
    
    MyLinearLayout *container = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    container.topPos.equalTo(@10);
    container.leftPos.equalTo(@10);
    container.rightPos.equalTo(@10);
    container.wrapContentHeight = YES;

    //section
    MyLinearLayout *sectionName = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    sectionName.topPos.equalTo(@10);
    sectionName.leftPos.equalTo(@0);
    sectionName.rightPos.equalTo(@0);
    sectionName.heightSize.equalTo(@40);
    [container addSubview:sectionName];
    
    
    UILabel *title = [UILabel new];
    title.leftPos.equalTo(@100);
    title.weight = 1;
    title.topPos.equalTo(@0);
    title.bottomPos.equalTo(@0);
    title.text = sectionTitle;
    [title setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:14]];
    title.textColor = [UIColor colorWithRed:(11.0/255) green:(54.0/255) blue:(74.0/255) alpha:1];
    [sectionName addSubview:title];
    
    //content
    MyLinearLayout *content = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    content.topPos.equalTo(@0);
    content.leftPos.equalTo(@0);
    content.rightPos.equalTo(@0);
    content.wrapContentHeight= YES;
   // content.backgroundColor = [UIColor blueColor];
    content.gravity = MyGravity_Vert_Center;
    [container addSubview:content];
    
    //image
    MyRelativeLayout * logoContent = [MyRelativeLayout new];
    logoContent.widthSize.equalTo(@80);
    logoContent.heightSize.equalTo(@80);
    logoContent.gravity = MyGravity_Center;
    [content addSubview:logoContent];

    
    CircleBorderImageView* logo = [CircleBorderImageView new];
    logo.widthSize.equalTo(@60);
    logo.heightSize.equalTo(@60);
    logo.centerYPos.equalTo(@0);
    logo.centerXPos.equalTo(@0);
    logo.backgroundColor =[UIColor colorWithRed:(11.0/255) green:(54.0/255) blue:(74.0/255) alpha:1];

    [logo setImage:[UIImage imageNamed:sectionImageName]];
    [logoContent addSubview:logo];
    
    //Content
    MyLinearLayout * mainContent = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    mainContent.weight = 1;

    //mainContent.wrapContentHeight = YES;
    [content addSubview: mainContent];
    mainContent.heightSize.equalTo(@200);
    mainContent.gravity = MyGravity_Vert_Center;
    mainContent.backgroundImage = [UIImage imageNamed:@"row_back"];
    
    
    MyLinearLayout * taskContent = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    taskContent.topPos.equalTo(@15);
    taskContent.bottomPos.equalTo(@15);
    taskContent.weight= 1;
 //   taskContent.backgroundColor = [UIColor blackColor];
    [mainContent addSubview:taskContent];
    
    
    MyLinearLayout * timeContent = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    
    timeContent.topPos.equalTo(@15);
    timeContent.bottomPos.equalTo(@15);

    timeContent.weight= 1;
    //timeContent.backgroundColor = [UIColor blueColor];
    long mainContentHeight = 30;
    [mainContent addSubview:timeContent];
    for(AssignTaskModel* model in models) {
        UIButton *task = [UIButton new];
        task.leftPos.equalTo(@10);
        task.rightPos.equalTo(@10);
        task.topPos.equalTo(@0);
        task.heightSize.equalTo(@40);
        [task setTitle:@"Task Name" forState:UIControlStateNormal];
        [task setFont:[UIFont fontWithName:@"CenturyGothic-Regular" size:14]];
        [task setTitleColor:[UIColor colorWithRed:(11.0/255) green:(54.0/255) blue:(74.0/255) alpha:1] forState:UIControlStateNormal ];
        [task setTag:model.mIndex];
        [task addTarget:self action:@selector(taskPressed:) forControlEvents:UIControlEventTouchUpInside];
   
        
        UILabel *time = [UILabel new];
        time.leftPos.equalTo(@10);
        time.rightPos.equalTo(@10);
        time.topPos.equalTo(@0);
        time.heightSize.equalTo(@40);
        time.text = @"task Name";
        [time setFont:[UIFont fontWithName:@"CenturyGothic-Regular" size:14]];
        time.textColor = [UIColor colorWithRed:(11/255) green:(74/255) blue:54/255 alpha:1];
  
        
        if([model.mTaskType isEqualToString:@"fridge"] || [model.mTaskType isEqualToString:@"freezer"]) {
            time.text = kLang(model.mParams[@"time"]);
            [task setTitle:model.mParams[@"lname"] forState:UIControlStateNormal];
        }
        if([model.mTaskType isEqualToString:@"oil"]) {
            time.text = kLang(model.mParams[@"time"]);
           [task setTitle:model.mParams[@"item_name"] forState:UIControlStateNormal];
        }
        if([model.mTaskType isEqualToString:@"expire"]) {
            time.text = [[SettingModel shared] getSystemDateString: model.mParams[@"expire_date"]];
            [task setTitle:model.mParams[@"name"] forState:UIControlStateNormal];
        }
        
        if([model.mTaskType isEqualToString:@"cleaning"]) {
            NSString* assignTime = model.mParams[@"time"];
            NSDictionary* dict = [Global jsonToDict:assignTime];
            if([dict isKindOfClass:[NSArray class]]) {
                int inc =0;
                for(NSString* timeStr in dict) {
                    UIButton *cleaningTask = [UIButton new];
                    cleaningTask.leftPos.equalTo(@10);
                    cleaningTask.rightPos.equalTo(@10);
                    cleaningTask.topPos.equalTo(@0);
                    cleaningTask.heightSize.equalTo(@40);
                    [cleaningTask setTitle:@"Task Name" forState:UIControlStateNormal];
                    [cleaningTask setFont:[UIFont fontWithName:@"CenturyGothic-Regular" size:14]];
                    [cleaningTask setTitleColor:[UIColor colorWithRed:(11/255) green:(54/255) blue:74/255 alpha:1] forState:UIControlStateNormal ];
                    [cleaningTask setTag:model.mIndex];
                    [cleaningTask addTarget:self action:@selector(taskPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    UILabel *cleaingTime = [UILabel new];
                    cleaingTime.leftPos.equalTo(@10);
                    cleaingTime.rightPos.equalTo(@10);
                    cleaingTime.topPos.equalTo(@0);
                    cleaingTime.heightSize.equalTo(@40);
                    cleaingTime.text = @"task Name";
                    [cleaingTime setFont:[UIFont fontWithName:@"CenturyGothic-Regular" size:14]];
                    cleaingTime.textColor = [UIColor colorWithRed:(11.0/255) green:(54.0/255) blue:(74.0/255) alpha:1];
                    
                    NSString* timeTitle;
                    if([timeStr isEqualToString:@"1"])
                        timeTitle = kLang(@"morning");
                    else if([timeStr isEqualToString:@"2"])
                        timeTitle = kLang(@"afternoon");
                    else if([timeStr isEqualToString:@"3"])
                        timeTitle = kLang(@"evening");
                    [cleaingTime setText:timeTitle];
                    if(inc == 0) {
                        [cleaningTask setTitle:model.mParams[@"item"] forState:UIControlStateNormal];
                    } else {
                        [cleaningTask setHidden:YES];
                    }
                    [taskContent addSubview:cleaningTask];
                    [timeContent addSubview:cleaingTime];
                    mainContentHeight += 40;
                    inc ++;
                }
            }

        }else {
            [taskContent addSubview:task];
            [timeContent addSubview:time];
            mainContentHeight += 40;
        }
    }
    if(mainContentHeight <120)
        mainContentHeight = 120;
    
    self.totalAssignViewHeight += mainContentHeight;
    self.totalAssignViewHeight += 50;
    mainContent.heightSize.equalTo([NSNumber numberWithLong:mainContentHeight]);
    return container;
}

- (void) loadData {
    [self.assignTaskItems removeAllObjects];
    [Global showIndicator:self];
    [[NetworkParser shared] serviceTodayTask:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSMutableArray* models= responseObject;
            NSString* taskTypeTemp = @"none";
            
            int index = 0;
            for(int i=0; i<models.count; i++) {
                AssignTaskModel* model = [models objectAtIndex:i];
                if(![model.mTaskType isEqualToString:taskTypeTemp]) {
                    taskTypeTemp = model.mTaskType;
                    AssignTaskModel* section = [[AssignTaskModel alloc] init];
                    [section setItemType:YES withTaskType:model.mTaskType];
                    section.mIndex = index;
                    [self.assignTaskItems addObject: section];
                    index++;
                }
                model.mIndex = index;
                [self.assignTaskItems addObject:model];
                index++;
            }
            [self configView];
        }
        [Global stopIndicator:self];
    }];
}

- (void)taskPressed : (id) sender
{
    UIButton* taskLink = (UIButton*)sender;
    long index = taskLink.tag;
    AssignTaskModel* model = [self.assignTaskItems objectAtIndex:index];
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



- (void) setAssignContainerHeight :(double) height {
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.assignContainer.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    heightConstraint.constant = height;
    
}
@end
