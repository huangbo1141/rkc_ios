//
//  VCItemCreate.m
//  FoodSafety
//
//  Created by BoHuang on 8/23/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCItemCreate.h"
#import "SettingModel.h"
#import "VCMultiSelect.h"
#import "UserInfo.h"
#import "MultiSelectCellModel.h"
#import "Language.h"
#import "NetworkParser.h"
#import "Global.h"
#import "VCPrint.h"
#import "HttpUtils.h"
#import "AutocompleteCell.h"

@interface VCItemCreate ()
@property (strong, nonatomic) NSDate *expireDate;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *items_predction;
@end

@implementation VCItemCreate
@synthesize tfItemName, tfBatchNumber, tvDescription, tfExpireDate, tvAllergens;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionAllergenMultiSelect:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Item" bundle:nil];
    
    VCMultiSelect *ivc = [storyboard instantiateViewControllerWithIdentifier:@"VCMultiSelect"];
    if(self.allergenModels != nil)
       [ivc setAllergens:self.allergenModels];
    ivc.didDismiss = ^(NSArray *elements) {
        self.allergenModels = elements;
        [self setAllergensMSTV];
    };
    [self presentViewController:ivc animated:YES completion:nil];

}
- (IBAction)actionCreate:(id)sender {
    [self submitForm];
}
- (IBAction)actionPrintLabel:(id)sender {
    NSString* currentDate = [[SettingModel shared] getMysqlDateStringFromDate:[NSDate date]];
    ItemModel* model = [[ItemModel alloc] init];
    model.mName = tfItemName.text;
    model.mBatch = tfBatchNumber.text;
    model.mDescription = tvDescription.text;
    [model setExpireDate:tfExpireDate.text];
    model.mCreateDate = currentDate;
    
    for(int i=0; i< self.allergenModels.count; i++) {
        MultiSelectCellModel* cellModel = self.allergenModels[i];
        if(cellModel.isSelected){
            [model.mAllergens addObject:cellModel.mValue];
        }
    }
    if([model.mName isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_name") Title:kLang(@"alert")];
        return;
    }
    if([model.mExpireDate isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_expire_date") Title:kLang(@"alert")];
        return;
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCreateItem:model withCompletionBlock:^(id responseObject, NSString *error) {
        [Global stopIndicator:self];
        if(error == nil) {
            ItemModel* retrievedItem = (ItemModel*) responseObject;
            if(retrievedItem.mKeyCode != nil &&
               retrievedItem.mCreator != nil &&
               retrievedItem.mExpireDate != nil &&
               retrievedItem.mCreateDate != nil &&
               retrievedItem.mName != nil) {
                [UserInfo shared].selectedObject = retrievedItem;
                [Global switchStoryboard:self withStoryboardName:@"Print"];
            }
        }
        
    }];
    
    
}
- (IBAction)actionPrintAllergen:(id)sender {
    if(_itemModel != nil && _itemModel.mAlergenString != nil && ![_itemModel.mAlergenString isEqualToString:@""]) {
        [UserInfo shared].selectedObject = _itemModel;
        
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName: @"Print" bundle:nil];
        VCPrint* vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"VCPrint"];
        vc.printType = @"print_alergens";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}


-(void) initialize {
    
    UIDatePicker *uDPExpireDate = [[UIDatePicker alloc] init];
    uDPExpireDate.datePickerMode = UIDatePickerModeDate;
    [uDPExpireDate setDate:[NSDate date]];
    [uDPExpireDate addTarget:self action:@selector(updateExpireDate:) forControlEvents:UIControlEventValueChanged];
//    [self.tfExpireDate setInputView:uDPExpireDate];
//    self.tfExpireDate.delegate = self;
    [self loadData];
    
    [_autocompleteTable registerNib:[UINib nibWithNibName:@"AutocompleteCell" bundle:nil] forCellReuseIdentifier:@"CellGeneral"];
    _autocompleteTable.hidden = true;
    
    [_autocompleteTable setDelegate:self];
    [_autocompleteTable setDataSource:self];
    
    [self.tfItemName addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    self.activityIndicator.hidden = true;
    
    _autocompleteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) loadData {
    self.itemModel = (ItemModel*) [UserInfo shared].captureObject;
    self.infoModel = (ItemInfoModel*) [UserInfo shared].mItemInfoStore;
    self.allergenModels = [[NSMutableArray alloc] init];
    if(self.infoModel == nil)
        return;
    NSArray* keys = self.infoModel.mAllergens.allKeys;
    for(NSString* key in keys) {
        NSString* value = [self.infoModel.mAllergens objectForKey:key];
        NSString* name = [self getAllergenName:value];
        MultiSelectCellModel* model = [[MultiSelectCellModel alloc] init];
        model.isSelected   = NO;
        model.mValue = key;
        model.mText = name;
        [self.allergenModels addObject:model];
    }
    tvAllergens.text = @"";
    if(self.itemModel.mAllergens != nil) {
        for(NSString* allergen in self.itemModel.mAllergens) {
            NSString* value = self.infoModel.mAllergens[allergen];
            NSString* name= [self getAllergenName:value];
            for(int i=0; i<self.allergenModels.count; i++) {
                MultiSelectCellModel* model = self.allergenModels[i];
                if([model.mText isEqualToString:name]) {
                    model.isSelected = YES;
                }
            }
        }
        [self setAllergensMSTV];
    }
    
}
- (void) updateExpireDate:(id)sender
{
    
    
    UIDatePicker *picker = (UIDatePicker*)self.tfExpireDate.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    
    self.expireDate = picker.date;
    self.tfExpireDate.text = [dateFormat stringFromDate:picker.date];
}

-(NSString*) getNameFromValue:(NSString*) value {
  
    NSArray *valueArr = [value componentsSeparatedByString:@"_"];
    NSString* result = @"";
    for(NSString* ele in valueArr) {
        NSString* capEle = [[[ele substringToIndex:1] uppercaseString] stringByAppendingString:[ele substringFromIndex:1]];
        result = [result stringByAppendingString:capEle];
    }
    return result;
}

-(NSString*) getAllergenName:(NSString*) value {
    return kLang(value);

}

-(void) submitForm {
    NSString* currentDate = [[SettingModel shared] getMysqlDateStringFromDate:[NSDate date]];
    ItemModel* model = [[ItemModel alloc] init];
    model.mName = tfItemName.text;
    model.mBatch = tfBatchNumber.text;
    model.mDescription = tvDescription.text;
    [model setExpireDate:tfExpireDate.text];
    model.mCreateDate = currentDate;

    for(int i=0; i< self.allergenModels.count; i++) {
        MultiSelectCellModel* cellModel = self.allergenModels[i];
        if(cellModel.isSelected){
            [model.mAllergens addObject:cellModel.mValue];
        }
    }
    if([model.mName isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_name") Title:kLang(@"alert")];
        return;
    }
    if([model.mExpireDate isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_expire_date") Title:kLang(@"alert")];
        return;
    }
    [self save: model];
}
- (void) save:(ItemModel*) model {
    [Global showIndicator:self];
    [[NetworkParser shared] serviceCreateItem:model withCompletionBlock:^(id responseObject, NSString *error) {
        [Global stopIndicator:self];
        if(error == nil) {
            [self gotoItemList];
        }

    }];
}
- (void) gotoItemList {
    [Global switchScreen:self withStoryboardName:@"Item" withControllerName:@"VCItemList"];
}
- (void) setAllergensMSTV {
    
    NSString* allergenStr = @"";
    int inc =0;
    for(int i=0; i<self.allergenModels.count; i++) {
        
        MultiSelectCellModel* model = self.allergenModels[i];
        if(model.isSelected == NO)
            continue;
        NSString* title = model.mText;
        allergenStr = [allergenStr stringByAppendingString:title];
        inc ++;
        allergenStr = [allergenStr stringByAppendingString:@", "];
    }
    if(allergenStr.length >2)
    allergenStr = [allergenStr substringToIndex:allergenStr.length -2];
    self.tvAllergens.text = allergenStr;
    self.itemModel.mAlergenString = allergenStr;
}
#pragma -mark textFields
-(void)textFieldDidChange:(UITextField*)textField{
    if (textField == self.tfItemName) {
        NSString *str = textField.text;
        if (![str isEqualToString:@""]&& [str length]>=2) {
            [self getAutoCompletePlaces:str];
            
        }else{
            _autocompleteTable.hidden = true;
            [_autocompleteTable setScrollEnabled:false];
        }
    }
}
-(void)showAutoComplete:(NSMutableArray*)items{
    self.items = items;
    if (self.items.count>0) {
        _autocompleteTable.hidden = false;
        [self.autocompleteTable reloadData];
    }else{
        _autocompleteTable.hidden = true;
        [self.autocompleteTable reloadData];
    }
    
}
-(void)getAutoCompletePlaces:(NSString *)searchKey{
    NSMutableDictionary *params= [[NSMutableDictionary alloc] init];
    
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_ITEMS];
    url = [url stringByAppendingString:@"/"];
    url = [url stringByAppendingString:searchKey];
    
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            NSDictionary* dict = (NSDictionary*) responseObject;
            NSMutableArray* tempItems = [[NSMutableArray alloc] init];
            ItemModel* imodel = [[ItemModel alloc] init];
            imodel.mName = searchKey;
            [tempItems addObject:imodel];
            BOOL duplicate = false;
            if([dict objectForKey:@"items"] != nil) {
                NSArray* items =  dict[@"items"];
                
                if ([items isKindOfClass:[NSArray class]]) {
                    for (id obj in items) {
                        ItemModel* imodel = [[ItemModel alloc] init];
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            [imodel parse:obj];
                        }
                        if ([[imodel.mName lowercaseString] isEqualToString:[searchKey lowercaseString]]) {
                            duplicate = true;
                        }
                        [tempItems addObject:imodel];
                    }
                }
                
                
            }else {
                
            }
            if (duplicate) {
                [tempItems removeObjectAtIndex:0];
            }
            [self showAutoComplete:tempItems];
        }
        self.activityIndicator.hidden = true;
        [self.activityIndicator stopAnimating];
        
    }];
    
}
#pragma mark - tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellGeneral" forIndexPath:indexPath];
    ItemModel* imodel = self.items[indexPath.row];
    cell.lblContent.text = imodel.mName;
    if (imodel.mExpireDate == nil || [imodel.mExpireDate length]==0) {
        cell.view1.hidden = true;
        cell.view2.hidden = true;
    }else{
        cell.view1.hidden = false;
        cell.view2.hidden = false;
        cell.lbl1_2.text = [imodel getCreateDate];
        cell.lbl2_2.text = [imodel getExpireDate];
    }
    
    return cell;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _autocompleteTable) {
        
        return _items.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemModel* imodel = self.items[indexPath.row];
    if (imodel.mId == nil || [imodel.mId length] == 0) {
        return 40;
    }else{
        return 80;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    
    ItemModel* imodel = self.items[indexPath.row];
    self.autocompleteTable.hidden = true;
    
    if (imodel.mId==nil || [imodel.mId length] == 0) {
        self.tfItemName.text = imodel.mName;
    }
    else{
        // http request
        self.tfItemName.text = imodel.mName;
        
        NSMutableDictionary *params= [[NSMutableDictionary alloc] init];
        
        NSString *url = sAppDomain;
        url = [url stringByAppendingString:PREVIEW_ITEM];
        
        params[@"token"] = [UserInfo shared].mAccount.mToken;
        params[@"id"] = imodel.mId;
        
        
        self.activityIndicator.hidden = false;
        [self.activityIndicator startAnimating];
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                
            } else {
                NSDictionary* dict = (NSDictionary*) responseObject;
                NSDictionary* data = dict[@"item"];
                ItemModel* imodel = [[ItemModel alloc] init];
                [imodel parse:data];
                
                for (MultiSelectCellModel* cell in self.allergenModels) {
                    cell.isSelected = false;
                }
                for (NSString* string in imodel.mAllergens) {
                    for (MultiSelectCellModel* cell in self.allergenModels) {
                        if ([[cell.mValue lowercaseString] isEqualToString:[string lowercaseString]]) {
                            cell.isSelected = true;
                        }
                    }
                }
                
                self.tvDescription.text = imodel.mDescription;
                self.tfExpireDate.text = imodel.mDiff;
                NSLog(imodel.mDiff);
                
                [self setAllergensMSTV];
            }
            self.activityIndicator.hidden = true;
            [self.activityIndicator stopAnimating];
            
        }];
    }
    
    return;
    
}


@end
