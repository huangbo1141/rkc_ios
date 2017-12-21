//
//  VCItemFilter.m
//  FoodSafety
//
//  Created by BoHuang on 8/24/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCItemFilter.h"
#import "SettingModel.h"
#import "AllergenModel.h"
#import "Language.h"
#import "UserInfo.h"
@interface VCItemFilter ()
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *expireDate;
@property (strong, nonatomic) AllergenModel* selectedAllergen;
@end

@implementation VCItemFilter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoModel = [UserInfo shared].mItemInfoStore;
    if(self.infoModel == nil) {
        self.infoModel = [[ItemInfoModel alloc] init];
    }
    UIDatePicker *uDPCreateDate = [[UIDatePicker alloc] init];
    uDPCreateDate.datePickerMode = UIDatePickerModeDate;
    [uDPCreateDate setDate:[NSDate date]];
    [uDPCreateDate addTarget:self action:@selector(updateCreateDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfCreateDate setInputView:uDPCreateDate];
    self.tfCreateDate.delegate = self;
    
    
    UIDatePicker *uDPExpireDate = [[UIDatePicker alloc] init];
    uDPExpireDate.datePickerMode = UIDatePickerModeDate;
    [uDPExpireDate setDate:[NSDate date]];
    [uDPExpireDate addTarget:self action:@selector(updateExpireDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfExpireDate setInputView:uDPExpireDate];
    self.tfExpireDate.delegate = self;
    
    self.pVAllergen = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVAllergen setDataSource: self];
    [self.pVAllergen setDelegate: self];
    self.self.pVAllergen.showsSelectionIndicator = YES;
    self.tfAllergen.inputView = self.pVAllergen;
    [self loadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateCreateDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.tfCreateDate.inputView;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    
    self.createDate = picker.date;
    self.tfCreateDate.text = [dateFormat stringFromDate:picker.date];
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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (void) loadData {
    if(_conditions == nil)
        return;
    self.tfItemName.text = self.conditions[@"name"] == nil ? @"" : self.conditions[@"name"];
    self.tfCreateDate.text = self.conditions[@"create_date"] == nil ? @"" : self.conditions[@"create_date"];
    self.tfExpireDate.text = self.conditions[@"expire_date"] == nil ? @"" : self.conditions[@"expire_date"];
    self.tfBatch.text = self.conditions[@"batch"] == nil ? @"" : self.conditions[@"batch"];
}

- (IBAction)actionApplyFilter:(id)sender {
    
    NSMutableDictionary* conditions = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* conditionTitles = [[NSMutableDictionary alloc] init];

    NSString* itemName = self.tfItemName.text;
    if(![itemName isEqualToString:@""])
    {
        conditions[@"name"] = itemName;
        conditionTitles[@"name"] = itemName;
    }
    NSString* batch = self.tfBatch.text;
    if(![batch isEqualToString:@""])
        conditions[@"batch_number"] = batch;
        conditionTitles[@"batch_number"] = batch;
    if(self.createDate != nil) {
        NSString* createDateStr = [[SettingModel shared] getMysqlDateStringFromDate: self.createDate];
        conditions[@"create_date"] = createDateStr;
        conditionTitles[@"create_date"] = [[SettingModel shared] getSystemDateString:createDateStr];
    }
    if(self.expireDate != nil) {
        NSString* expireDateStr = [[SettingModel shared] getMysqlDateStringFromDate: self.expireDate];
        conditions[@"expire_date"] = expireDateStr;
        conditionTitles[@"expire_date"] = [[SettingModel shared] getSystemDateString:expireDateStr];;

    }
    if(self.selectedAllergen != nil) {
        conditions[@"allergen"] = self.selectedAllergen.mValue;
        conditionTitles[@"allergen"] = [self getAllergenName:self.selectedAllergen.mValue] ;
    }
    
    [self dismissViewControllerAnimated:true completion:false];
    if (self.didDismiss)
        self.didDismiss(conditions, conditionTitles);
}


#pragma mark - UIPickerView Delegate

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.infoModel.mAllergens.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *keys = [self.infoModel.mAllergens allKeys];
    NSString* key = keys[row];
    NSString* value = [self.infoModel.mAllergens objectForKey:key];
    NSString* title = [self getAllergenName:value];
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    AllergenModel* allergenModel = [[AllergenModel alloc] init];
    NSArray *keys = [self.infoModel.mAllergens allKeys];
    allergenModel.mValue = keys[row];
    allergenModel.mName = [self.infoModel.mAllergens objectForKey:allergenModel.mValue];
    NSString* title = [self getAllergenName:allergenModel.mName];
    self.tfAllergen.text =title;
    self.selectedAllergen = allergenModel;
}

-(NSString*) getAllergenName:(NSString*) value {
    return kLang(value);

}


@end
