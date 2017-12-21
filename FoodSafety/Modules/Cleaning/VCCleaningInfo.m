//
//  VCCleaningInfo.m
//  FoodSafety
//
//  Created by BoHuang on 9/4/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCCleaningInfo.h"
#import "UserInfo.h"
#import "Global.h"
#import "Language.h"
@interface VCCleaningInfo ()

@end

@implementation VCCleaningInfo
@synthesize tvDescription, logModel, infoModel;
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
    self.logModel = (LogModel*) [UserInfo  shared].captureObject;
    self.infoModel = (InfoModel*)[UserInfo shared].mInfoStore;
    [self loadData];
    //[self.pVLocation load]
}

-(void) loadData {
    
    tvDescription.text= @"";
    
    if(logModel.mCaptureNote != nil && ![logModel.mCaptureNote isEqualToString:@""]) {
        tvDescription.text = logModel.mCaptureNote;
    }
}


- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNext:(id)sender {
    
    if([self confirmEdit]) {
        [Global switchScreen:self withStoryboardName:@"Cleaning" withControllerName:@"VCCleaningCapture"];
    }
}

- (BOOL) confirmEdit {
    NSString* description = self.tvDescription.text;
    logModel.mCaptureNote =description;
    return YES;
}

@end
