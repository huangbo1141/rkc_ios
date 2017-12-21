//
//  VCDeliveryInfo.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryInfo.h"
#import "SupplierModel.h"
#import "UserInfo.h"
#import "Global.h"
#import "Language.h"
#import "VCMultiSelect.h"
#import "MultiSelectCellModel.h"

@interface VCDeliveryInfo ()

@end

@implementation VCDeliveryInfo
@synthesize tfSupplier, tfTemperature, tfDeliveryNumber, tvDescription, tvGoodType,logModel, infoModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    self.logModel = (DeliveryModel*) [UserInfo  shared].captureObject;
    self.infoModel = (DeliveryInfoModel*)[UserInfo shared].mDeliveryInfoStore;
    self.pVSupplier = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.pVSupplier setDataSource: self];
    [self.pVSupplier setDelegate: self];
    self.pVSupplier.showsSelectionIndicator = YES;
    self.tfSupplier.inputView = self.pVSupplier;
    self.tfSupplier.delegate =self;
    
    if(self.goodTypeModels == nil) {
        self.goodTypeModels = [[NSMutableArray alloc] init];
    }
    
    [self.goodTypeModels removeAllObjects];
    MultiSelectCellModel* freshGoods = [[MultiSelectCellModel alloc] init];
    freshGoods.mValue = @"fresh_goods";
    freshGoods.mText = kLang(@"fresh_goods");
    [self.goodTypeModels addObject:freshGoods];
    
    MultiSelectCellModel* frozenGoods = [[MultiSelectCellModel alloc] init];
    frozenGoods.mValue = @"frozen_goods";
    frozenGoods.mText = kLang(@"frozen_goods");
    [self.goodTypeModels addObject:frozenGoods];
    
    MultiSelectCellModel* dryGoods = [[MultiSelectCellModel alloc] init];
    dryGoods.mValue = @"dry_goods";
    dryGoods.mText = kLang(@"dry_goods");
    [self.goodTypeModels addObject:dryGoods];
    
    MultiSelectCellModel* miscalleneous = [[MultiSelectCellModel alloc] init];
    miscalleneous.mValue = @"miscalleneous";
    miscalleneous.mText = kLang(@"miscalleneous");
    [self.goodTypeModels addObject:miscalleneous];
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

- (IBAction)nextAction:(id)sender {
    if([self confirmEdit]) {
        [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryCondition"];
    }
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionGoodTypeMultiSelect:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Item" bundle:nil];
    
    VCMultiSelect *ivc = [storyboard instantiateViewControllerWithIdentifier:@"VCMultiSelect"];
    if(self.goodTypeModels != nil)
        [ivc setAllergens: self.goodTypeModels];
    ivc.didDismiss = ^(NSArray *elements) {
        self.goodTypeModels  = [elements mutableCopy];
        [self setGoodTypeMSTV];
    };
    [self presentViewController:ivc animated:YES completion:nil];
    
}

- (BOOL) confirmEdit {
    NSString* description = self.tvDescription.text;
    NSString* temperature = self.tfTemperature.text;
    NSString* goodType = self.tvGoodType.text;
    
    
    if([goodType isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_goodtype") Title:kLang(@"alert")];
        return NO;
    }
    if([temperature isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_temperature") Title:kLang(@"alert")];
        return NO;
    }
    logModel.mNumber = self.tfDeliveryNumber.text;
    logModel.mComment = description;
    logModel.mTemperature =temperature;

    for(int i=0; i<self.goodTypeModels.count; i++) {
        MultiSelectCellModel* cellModel = self.goodTypeModels[i];
        if(cellModel.isSelected){
            [logModel.mGoodTypes addObject:cellModel.mValue];
        }
    }
    return YES;
}


- (void) setGoodTypeMSTV {
    
    NSString* goodTypeStr = @"";
    int inc =0;
    for(int i=0; i<self.goodTypeModels.count; i++) {
        
        MultiSelectCellModel* model = self.goodTypeModels[i];
        if(model.isSelected == NO)
            continue;
        NSString* title = model.mText;
        goodTypeStr = [goodTypeStr stringByAppendingString:title];
        inc ++;
        goodTypeStr = [goodTypeStr stringByAppendingString:@", "];
    }
    if(goodTypeStr.length >2)
        goodTypeStr = [goodTypeStr substringToIndex:goodTypeStr.length -2];
    self.tvGoodType.text = goodTypeStr;
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
    SupplierModel* model = [self.infoModel.mSuppliers objectAtIndex:row];
    return model.mName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SupplierModel* model = [self.infoModel.mSuppliers objectAtIndex:row];
    self.tfSupplier.text = model.mName;
    logModel.mSupplier = model.mId;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

@end
