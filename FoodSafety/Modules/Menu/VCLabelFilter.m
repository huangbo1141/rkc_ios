//
//  VCLabelFilter.m
//  FoodSafety
//
//  Created by BoHuang on 9/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCLabelFilter.h"
#import "SupplierModel.h"
#import "UserInfo.h"
#import "SettingModel.h"

@interface VCLabelFilter ()
@property (strong, nonatomic) NSDate *fromDate;
@property (strong, nonatomic) NSDate *toDate;
@property (strong, nonatomic) SupplierModel* selectedSupplier;

@end

@implementation VCLabelFilter

- (void)viewDidLoad {
    [super viewDidLoad];

    self.infoModel = [UserInfo shared].mMenuInfoStore;
    if(self.infoModel == nil) {
        self.infoModel = [[MenuInfoModel alloc] init];
    }
    
    UIDatePicker *uDPFromDate = [[UIDatePicker alloc] init];
    uDPFromDate.datePickerMode = UIDatePickerModeDate;
    [uDPFromDate setDate:[NSDate date]];
    [uDPFromDate addTarget:self action:@selector(updateFromDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfDateFrom setInputView:uDPFromDate];
    self.tfDateFrom.delegate = self;
    
    
    UIDatePicker *uDPToDate = [[UIDatePicker alloc] init];
    uDPToDate.datePickerMode = UIDatePickerModeDate;
    [uDPToDate setDate:[NSDate date]];
    [uDPToDate addTarget:self action:@selector(updateToDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfDateTo setInputView:uDPToDate];
    self.tfDateTo.delegate = self;
    
    self.pVSupplier = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVSupplier setDataSource: self];
    [self.pVSupplier setDelegate: self];
    self.self.pVSupplier.showsSelectionIndicator = YES;
    self.tfSupplier.inputView = self.pVSupplier;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateFromDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.tfDateFrom.inputView;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    
    self.fromDate = picker.date;
    self.tfDateFrom.text = [dateFormat stringFromDate:picker.date];
}

- (void) updateToDate:(id)sender
{
    
    
    UIDatePicker *picker = (UIDatePicker*)self.tfDateTo.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    self.toDate = picker.date;
    self.tfDateTo.text = [dateFormat stringFromDate:picker.date];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionApplyFilter:(id)sender {
    
    NSMutableDictionary* conditions = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* conditionTitles = [[NSMutableDictionary alloc] init];
    NSString* number = self.tfNumber.text;
    if(![number isEqualToString:@""])
    {
        conditions[@"log_number"] = number;
        conditionTitles[@"log_number"] = number;
    }
    if(self.fromDate != nil) {
        NSString* fromDateStr = [[SettingModel shared] getMysqlDateStringFromDate: self.fromDate];
        conditions[@"log_from"] = fromDateStr;
        conditionTitles[@"log_from"] = [[SettingModel shared] getSystemDateString:fromDateStr];
    }
    if(self.toDate != nil) {
        NSString* toDateStr = [[SettingModel shared] getMysqlDateStringFromDate: self.toDate];
        conditions[@"log_to"] = toDateStr;
        conditionTitles[@"log_to"] = [[SettingModel shared] getSystemDateString:toDateStr];;
    }
    if(self.selectedSupplier != nil) {
        conditions[@"log_supplier"] = self.selectedSupplier.mId;
        conditionTitles[@"log_supplier"] = self.selectedSupplier.mName ;
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
    return self.infoModel.mSuppliers.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SupplierModel * model = [self.infoModel.mSuppliers objectAtIndex:row];
    return model.mName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SupplierModel* supplierModel =  [self.infoModel.mSuppliers objectAtIndex: row];
    
    self.tfSupplier.text =supplierModel.mName;
    self.selectedSupplier = supplierModel;
}


@end
