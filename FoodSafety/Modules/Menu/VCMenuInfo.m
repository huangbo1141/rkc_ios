//
//  VCMenuInfo.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuInfo.h"
#import "LocationModel.h"
#import "UserInfo.h"
#import "Global.h"
#import "Language.h"
#import "VCMultiSelect.h"
#import "MultiSelectCellModel.h"

@interface VCMenuInfo ()
@property (strong, nonatomic) NSDate *logDate;
@end

@implementation VCMenuInfo
@synthesize tfLocation, tfTitle, tfDate, tvTime, logModel, infoModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    self.logModel = (DeliveryMenuModel*) [UserInfo  shared].captureObject;
    self.infoModel = (MenuInfoModel*)[UserInfo shared].mMenuInfoStore;
    self.pVLocation = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVLocation setDataSource: self];
    [self.pVLocation setDelegate: self];
    self.pVLocation.showsSelectionIndicator = YES;
    self.tfLocation.inputView = self.pVLocation;
    self.tfLocation.delegate =self;
    
    if(self.timeTypeModels == nil) {
        self.timeTypeModels = [[NSMutableArray alloc] init];
    }
    
    [self.timeTypeModels removeAllObjects];
    MultiSelectCellModel* breakfast = [[MultiSelectCellModel alloc] init];
    breakfast.mValue = @"breakfast";
    breakfast.mText = kLang(@"breakfast");
    [self.timeTypeModels addObject:breakfast];
    
    MultiSelectCellModel* lunch = [[MultiSelectCellModel alloc] init];
    lunch.mValue = @"lunch";
    lunch.mText = kLang(@"lunch");
    [self.timeTypeModels addObject:lunch];
    
    MultiSelectCellModel* dinner = [[MultiSelectCellModel alloc] init];
    dinner.mValue = @"dinner";
    dinner.mText = kLang(@"dinner");
    [self.timeTypeModels addObject:dinner];
    
    MultiSelectCellModel* other = [[MultiSelectCellModel alloc] init];
    other.mValue = @"other";
    other.mText = kLang(@"other");
    [self.timeTypeModels addObject:other];
    
    UIDatePicker *dpLogDate = [[UIDatePicker alloc] init];
    dpLogDate.datePickerMode = UIDatePickerModeDate;
    [dpLogDate setDate:[NSDate date]];
    [dpLogDate addTarget:self action:@selector(updateLogDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfDate setInputView:dpLogDate];
    self.tfDate.delegate = self;
}

- (IBAction)nextAction:(id)sender {
    if([self confirmEdit]) {
        [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuItemAddList"];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionTimeTypeMultiSelect:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Item" bundle:nil];
    
    VCMultiSelect *ivc = [storyboard instantiateViewControllerWithIdentifier:@"VCMultiSelect"];
    if(self.timeTypeModels != nil)
        [ivc setAllergens: self.timeTypeModels];
    ivc.didDismiss = ^(NSArray *elements) {
        self.timeTypeModels  = [elements mutableCopy];
        [self setTimeTypeMSTV];
    };
    [self presentViewController:ivc animated:YES completion:nil];
    
}
- (void) updateLogDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.tfDate.inputView;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    self.logDate = picker.date;
    self.tfDate.text = [dateFormat stringFromDate:picker.date];
}
- (BOOL) confirmEdit {
    NSString* title = self.tfTitle.text;
    NSString* date = self.tfDate.text;
   
    logModel.mTitle     = title;
    [logModel setDate:date];
    [logModel.mTimeTypes removeAllObjects];
    for(int i=0; i<self.timeTypeModels.count; i++) {
        MultiSelectCellModel* cellModel = self.timeTypeModels[i];
        if(cellModel.isSelected){
            [logModel.mTimeTypes addObject:cellModel.mValue];
        }
    }
    if([title isEqualToString:@""])
        return NO;
    if(logModel.mTimeTypes.count == 0)
        return NO;
    
    if(logModel.mLocation  == nil || [logModel.mLocation isEqualToString:@""])
        return NO;
    
    return YES;
    
}

- (void) setTimeTypeMSTV {
    
    NSString* timeTypeStr = @"";
    int inc =0;
    for(int i=0; i<self.timeTypeModels.count; i++) {
        
        MultiSelectCellModel* model = self.timeTypeModels[i];
        if(model.isSelected == NO)
            continue;
        NSString* title = model.mText;
        timeTypeStr = [timeTypeStr stringByAppendingString:title];
        inc ++;
        timeTypeStr = [timeTypeStr stringByAppendingString:@", "];
    }
    if(timeTypeStr.length >2)
        timeTypeStr = [timeTypeStr substringToIndex:timeTypeStr.length -2];
    self.tvTime.text = timeTypeStr;
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
    LocationModel* model = [self.infoModel.mLocations objectAtIndex:row];
    return model.mName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LocationModel* model = [self.infoModel.mLocations objectAtIndex:row];
    self.tfLocation.text = model.mName;
    logModel.mLocation = model.mId;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

@end
