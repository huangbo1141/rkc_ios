//
//  VCItemEdit.m
//  FoodSafety
//
//  Created by BoHuang on 8/23/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCItemEdit.h"
#import "SettingModel.h"
#import "VCMultiSelect.h"
#import "UserInfo.h"
#import "MultiSelectCellModel.h"
#import "Language.h"
#import "NetworkParser.h"
#import "Global.h"
#import "VCPrint.h"

@interface VCItemEdit()
@property (strong, nonatomic) NSDate *expireDate;
@end

@implementation VCItemEdit
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
- (IBAction)actionUpdate:(id)sender {
    [self submitForm];
}
- (IBAction)actionPrintLabel:(id)sender {
    ItemModel* retrievedItem = self.itemModel;
            if(retrievedItem != nil && retrievedItem.mKeyCode != nil &&
               retrievedItem.mCreator != nil &&
               retrievedItem.mExpireDate != nil &&
               retrievedItem.mCreateDate != nil &&
               retrievedItem.mName != nil) {
                [UserInfo shared].selectedObject = retrievedItem;
                [Global switchStoryboard:self withStoryboardName:@"Print"];
            }

        

    
    
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
    [self.tfExpireDate setInputView:uDPExpireDate];
    self.tfExpireDate.delegate = self;
    [self loadData];
    
    
}

- (void) loadData {
    self.itemModel = (ItemModel*) [UserInfo shared].selectedObject;
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
    tfItemName.text = self.itemModel.mName;
    tfBatchNumber.text =self.itemModel.mBatch;
    tvDescription.text =self.itemModel.mDescription;
    tfExpireDate.text = [self.itemModel getExpireDate];
    
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

-(NSString*) getAllergenName:(NSString*) value {
    return kLang(value);
}


-(void) submitForm {
    NSString* currentDate = [[SettingModel shared] getMysqlDateStringFromDate:[NSDate date]];
    ItemModel* model = [[ItemModel alloc] init];
    model.mKeyCode = self.itemModel.mKeyCode;
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
    [[NetworkParser shared] serviceUpdateItem:model withCompletionBlock:^(id responseObject, NSString *error) {
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
- (IBAction)actionDelete:(id)sender {
    if(self.itemModel != nil  && self.itemModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteItem:self.itemModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            [Global stopIndicator:self];
        }];
    }
}
@end

