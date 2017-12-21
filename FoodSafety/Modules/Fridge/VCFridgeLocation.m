//
//  VCFridgeLocation.m
//  FoodSafety
//
//  Created by BoHuang on 8/18/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCFridgeLocation.h"
#import "UserInfo.h"
#import "LocationModel.h"
#import "QRCodeReaderViewController.h"
#import "Global.h"

@interface VCFridgeLocation ()<QRCodeReaderDelegate>


@end

@implementation VCFridgeLocation

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionNext:(id)sender {
    if(![self.lblLocation.text isEqualToString:@""] && self.logModel.mLocation != nil)
        [Global switchScreen:self withStoryboardName:@"Fridge" withControllerName:@"VCFridgeInfo"];
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)qrScanAction:(id)sender {
    
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        if(resultAsString != nil ){
            [wSelf.navigationController popViewControllerAnimated:YES];
            NSString* keyCode = resultAsString;
            LocationModel* model = [self getLocation:keyCode];
            if(model != nil) {
                self.lblLocation.text = model.mName;
                self.logModel.mLocation = model.mId;
            }
        }
 
        
    }];
    
    //[self presentViewController:reader animated:YES completion:NULL];
    [self.navigationController pushViewController:reader animated:YES];
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
    LocationModel* locationModel = (LocationModel*) self.infoModel.mLocations[row];
    return locationModel.mName;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LocationModel* locationModel = (LocationModel*) self.infoModel.mLocations[row];
    self.lblLocation.text = locationModel.mName;
    self.logModel.mLocation = locationModel.mId;
}



- (LocationModel*) getLocation:(NSString*) keyCode {
    NSMutableArray* locations = [UserInfo shared].mInfoStore.mLocations;
    for(int i=0; i<locations.count; i++){
        LocationModel* model = [locations objectAtIndex:i];
        if( [model.mKeyCode isEqualToString:keyCode] ) {
            [self.pVLocation selectRow:i inComponent:0 animated:YES];
            return model;
        }
    }
    return nil;
}
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) initialize {
    [Intercom setLauncherVisible:NO];
    self.logModel = (LogModel*) [UserInfo  shared].captureObject;
    self.infoModel = (InfoModel*)[UserInfo shared].mInfoStore;
    self.pVLocation.dataSource  = self;
    self.pVLocation.delegate =self;
    [self loadData];
}

-(void) loadData {
    if(self.logModel.mLocationCode != nil) {
        for(int i=0; i<self.infoModel.mLocations.count; i++){
            LocationModel* model = [self.infoModel.mLocations objectAtIndex:i];
            if(model.mKeyCode != nil && [model.mKeyCode isEqualToString:self.logModel.mLocationCode]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                     [self.pVLocation selectRow:i inComponent:0 animated:NO];
                });
    
                self.logModel.mLocation = model.mId;
                self.lblLocation.text = model.mName;
            }
        }

    }
    if(self.logModel.mLocationCode == nil && self.infoModel.mLocations.count > 0) {
        LocationModel * firstModel = [self.infoModel.mLocations objectAtIndex:0];
        self.logModel.mLocation = firstModel.mId;
        self.lblLocation.text = firstModel.mName;
    }
	
}
@end
