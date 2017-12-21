//
//  VCMenuFilter.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuFilter.h"
#import "SettingModel.h"
#import "LocationModel.h"
#import "UserInfo.h"

@interface VCMenuFilter ()
@property (strong, nonatomic) NSDate *fromDate;
@property (strong, nonatomic) NSDate *toDate;
@property (strong, nonatomic) LocationModel* selectedLocation;
@end

@implementation VCMenuFilter

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
    
    self.pVLocation = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVLocation setDataSource: self];
    [self.pVLocation setDelegate: self];
    self.self.pVLocation.showsSelectionIndicator = YES;
    self.tfLocation.inputView = self.pVLocation;
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
    
    NSString* title = self.tfTitle.text;
    if(![title isEqualToString:@""])
    {
        conditions[@"log_title"] = title;
        conditionTitles[@"log_title"] = title;
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
    if(self.selectedLocation != nil) {
        conditions[@"log_location"] = self.selectedLocation.mId;
        conditionTitles[@"log_location"] = self.selectedLocation.mName ;
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
    return self.infoModel.mLocations.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LocationModel * model = [self.infoModel.mLocations objectAtIndex:row];
    return model.mName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LocationModel* locationModel =  [self.infoModel.mLocations objectAtIndex: row];
    
    self.tfLocation.text =locationModel.mName;
    self.selectedLocation = locationModel;
}

@end
