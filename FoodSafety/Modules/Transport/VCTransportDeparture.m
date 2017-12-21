//
//  VCTransportDeparture.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCTransportDeparture.h"
#import "UserInfo.h"
#import "Global.h"
#import "Language.h"
#import "LocationModel.h"
@interface VCTransportDeparture ()
@property (strong, nonatomic) NSDate *departureDate;
@property (strong, nonatomic) NSDate *departureTime;
@property (strong, nonatomic) LocationModel* selectedModel;
@end

@implementation VCTransportDeparture

@synthesize tfTemperature, tfArea, tfTime, logModel, infoModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initialize {
    self.logModel = (TransportModel*) [UserInfo  shared].captureObject;
    self.infoModel = (TransportInfoModel*)[UserInfo shared].mTransportInfoStore;
    
    UIDatePicker *dPDate = [[UIDatePicker alloc] init];
    dPDate.datePickerMode = UIDatePickerModeDate;
    [dPDate setDate:[NSDate date]];
    [dPDate addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfDate setInputView:dPDate];
    self.tfDate.delegate = self;
    
    UIDatePicker *dPTime = [[UIDatePicker alloc] init];
    dPTime.datePickerMode = UIDatePickerModeTime;
    [dPTime setDate:[NSDate date]];
    [dPTime addTarget:self action:@selector(updateTime:) forControlEvents:UIControlEventValueChanged];
    [self.tfTime setInputView:dPTime];
    self.tfTime.delegate = self;
    
    
    self.pVArea = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVArea setDataSource: self];
    [self.pVArea setDelegate: self];
    self.self.pVArea.showsSelectionIndicator = YES;
    self.tfArea.inputView = self.pVArea;
    self.tfArea.delegate = self;
    [self loadData];
}

-(void) loadData {
    self.tfDate.text = @"";
    self.tfTime.text= @"";
    
    NSString* currentDate = [[SettingModel shared] getMysqlDateStringFromDate:[NSDate date]];
    NSString* currentTime = [[SettingModel shared] getMysqlTimeStringFromDate:[NSDate date]];
    self.tfTemperature.text = @"0";
     if([logModel getDepartureDate]!= nil)
         self.tfDate.text = [logModel getDepartureDate]
    ;
     else {
         self.tfDate.text = [[SettingModel shared] getSystemDateString:currentDate];
     }
    
    if([logModel getDepartureTime]!= nil)
        self.tfTime.text = [logModel getDepartureTime]
        ;
    else {
        self.tfTime.text = [[SettingModel shared] getSystemTimeString:currentTime];
    }
    
    if(logModel.mDepartureTemp != nil && ![logModel.mDepartureTemp isEqualToString:@""]) {
        tfTemperature.text = logModel.mDepartureTemp;
    }
}
- (void) updateDate:(id)sender
{
    
    
    UIDatePicker *picker = (UIDatePicker*)self.tfDate.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    self.departureDate = picker.date;
    self.tfDate.text = [dateFormat stringFromDate:picker.date];
}

- (void) updateTime:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.tfTime.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mTimeFormat];
    
    self.departureTime = picker.date;
    NSString* timeStr =[dateFormat stringFromDate:picker.date];

    self.tfTime.text = timeStr;
}


- (IBAction)actionMinus:(id)sender {
    NSString* temperature = tfTemperature.text;
    if([temperature isEqualToString:@""])
        temperature = @"0";
    float value = [temperature floatValue];
    value -= 1;

    NSString *myString = [[NSNumber numberWithFloat:value] stringValue];
    tfTemperature.text = myString;
}
- (IBAction)actionPlus:(id)sender {
    NSString* temperature = tfTemperature.text;
    if([temperature isEqualToString:@""])
        temperature = @"0";
    float value = [temperature floatValue];
    value += 1;

    NSString *myString = [[NSNumber numberWithFloat:value] stringValue];
    tfTemperature.text = myString;
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNext:(id)sender {
    
    if([self confirmEdit]) {
        [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportCapture"];
    }
}

- (BOOL) confirmEdit {
    NSString* date = self.tfDate.text;
    NSString* time = self.tfTime.text;
    NSString* temperature = self.tfTemperature.text;
    if([date isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_date.") Title:kLang(@"alert")];
        return NO;
    }
    if([time isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_time.") Title:kLang(@"alert")];
        return NO;
    }
    logModel.mDepartureTemp = temperature;
    [logModel setDepartureDate:date];
    [logModel setDepartureTime:time];
    return YES;
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
    self.tfArea.text = model.mName;
    logModel.mDepartureArea = model.mId;
    self.selectedModel = model;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}






@end
