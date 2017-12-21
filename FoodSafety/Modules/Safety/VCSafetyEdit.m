///Volumes/Untitled 2/FoodSafety/FoodSafety/Modules/Safety/VCSafetyEdit.m
//  VCSafetyEdit.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCSafetyEdit.h"
#import "SettingModel.h"
#import "VCMultiSelect.h"
#import "UserInfo.h"
#import "MultiSelectCellModel.h"
#import "LaboratoryInfoModel.h"
#import "Language.h"
#import "NetworkParser.h"
#import "OperatorModel.h"
#import "Global.h"
@interface VCSafetyEdit ()
@property (strong, nonatomic) NSDate *date;
@end

@implementation VCSafetyEdit
@synthesize tfDate, tfTitle, tfOperator, tfAttachFile, tvComment, logModel, infoModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initialize {
    [self loadData];
    UIDatePicker *uDPDate = [[UIDatePicker alloc] init];
    uDPDate.datePickerMode = UIDatePickerModeDate;
    [uDPDate setDate:[NSDate date]];
    [uDPDate addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];
    [self.tfDate setInputView:uDPDate];
    self.tfDate.delegate = self;
   
    
    self.tfAttachFile.delegate = self;
    
    self.pVOperator = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVOperator setDataSource: self];
    [self.pVOperator setDelegate: self];
    self.pVOperator.showsSelectionIndicator = YES;
    self.tfOperator.inputView = self.pVOperator;
    self.tfOperator.delegate =self;
    
    
}

- (void) loadData {
    self.logModel = (LaboratoryModel*) [UserInfo shared].captureObject;
    self.infoModel = (LaboratoryInfoModel*) [UserInfo shared].mLaboratoryInfoStore;

    if(self.infoModel == nil)
        return;
    
    if(self.logModel.mKeyCode == nil) {
        self.lblNavTitle.text = kLang(@"create");
        
    }else {
        self.lblNavTitle.text = kLang(@"edit");
    }
    
    if(self.logModel.mTitle != nil) {
        self.tfTitle.text = logModel.mTitle;
    }else
        tfTitle.text = @"";
    if(self.logModel.mComment != nil) {
        tvComment.text = logModel.mComment;
    }else
        tvComment.text = @"";
    if(self.logModel.mLogDate != nil) {
        self.tfTitle.text = [logModel getLogDate];
    }else
        tfTitle.text = @"";
    if(self.logModel.mOperatorId != nil) {
       long index = [self getOperatorIndex: logModel.mOperatorId] ;
        if(index >=0) {
            [self.pVOperator selectedRowInComponent:index];
        }
    }else
        tfTitle.text = @"";
    
    
}

- (long) getOperatorIndex:(NSString*) operatorId {
    if(infoModel.mOperators == nil)
        return -1;
    int inc = 0;
    for(OperatorModel* model in infoModel.mOperators) {
        if([operatorId isEqualToString:model.mId]) {
            return inc;
        }
        inc ++;
    }
    return -1;
}

- (void) submitForm {
    logModel.mTitle = tfTitle.text;
    logModel.mComment = tvComment.text;
    [logModel setMysqlLogDate:[[SettingModel shared] getMysqlDateStringFromDate:self.date]];
    if([logModel.mTitle isEqualToString:@""])
    {
        [Global AlertMessage:self Message:kLang(@"input_title") Title:kLang(@"alert")];
        return;
    }
    if([[logModel getLogDate] isEqualToString:@""]){
            [Global AlertMessage:self Message:kLang(@"input_date") Title:kLang(@"alert")];
        return;
    }
    
    [self save: logModel];
    
}

- (void) save:(LaboratoryModel*) model {

    [Global showIndicator:self];
    if(model.mKeyCode == nil) {
        [[NetworkParser alloc] serviceCreateSafety:model withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil)
                [self gotoList];
            [Global stopIndicator:self];
            
        }];
    
    }else {
        [[NetworkParser alloc] serviceUpdateSafety:model withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil)
                [self gotoList];
             [Global stopIndicator:self];
        }];
    }
    
}

- (void) gotoList {
    [Global switchScreen:self withStoryboardName:@"Safety" withControllerName:@"VCSafetyList"];
    
}
- (IBAction)attachAction:(id)sender {

}
- (IBAction)saveAction:(id)sender {
    [self submitForm];
}
- (void) updateDate:(id)sender
{
    
    
    UIDatePicker *picker = (UIDatePicker*)self.tfDate.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:[SettingModel shared].mDateFormat];
    
    
    self.date = picker.date;
    self.tfDate.text = [dateFormat stringFromDate:picker.date];
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
    return self.infoModel.mOperators.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    OperatorModel* model = [self.infoModel.mOperators objectAtIndex:row];
    return model.mFullName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    OperatorModel* model = [self.infoModel.mOperators objectAtIndex:row];
    self.tfOperator.text = model.mFullName;
    logModel.mOperatorId = model.mId;
    logModel.mOperatorName = model.mFullName;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}
@end
