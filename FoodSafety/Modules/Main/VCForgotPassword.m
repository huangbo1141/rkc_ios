//
//  VCForgotPassword.m
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCForgotPassword.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"

@interface VCForgotPassword ()

@end

@implementation VCForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitAction:(id)sender {
    NSString* email = self.tfEmail.text;
    if(![Global NSStringIsValidEmail:email]){
         [Global AlertMessage:self Message:kLang(@"invalid_email") Title:kLang(@"alert")];
        return;
    }
    [Global showIndicator:self];
    [[NetworkParser shared] serviceForgotPassword:email withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil && [responseObject isEqualToString:@"success"]) {
            [Global AlertMessage:self Message:kLang(@"forgot_success") Title:kLang(@"success")];
        }else {
            [Global AlertMessage:self Message:kLang(@"invalid_email") Title:kLang(@"alert")];
        }
        [Global stopIndicator:self];
    }];
    
}


@end
