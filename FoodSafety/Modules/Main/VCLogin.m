	//
//  VCLogin.m
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCLogin.h"
#import "Global.h"
#import "Language.h"
#import "UserInfo.h"
#import "NetworkParser.h"
@interface VCLogin ()

@end

@implementation VCLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.m_status = 0;
    self.const_TOP_default = self.const_TOP.constant;
    [self setSwitchViews];
    // Do any additional setup after loading the view.
    if([APP_MODE isEqualToString:@"local_development"]) {
        self.tfUserName.text = @"admin@system.com";
        self.tfPassword.text = @"123456";
    }
    if([APP_MODE isEqualToString:@"development"]){
        //self.tfUserName.text = @"contact@secretsdecuisine.fr";
        //self.tfPassword.text = @"secretsdecuisine";
        // self.tfUserName.text = @"cantine@fargues-saint-hilaire.fr";
        // self.tfPassword.text = @"papillon";
    }
}
-(void)setSwitchViews{
    if (self.m_status == 0) {
        self.view1_1.hidden = false;
        self.view1_2.hidden = false;
        self.view2_1.hidden = true;
        NSString* title = kLang(@"login_by_code");
        [self.btnSwitch setTitle:title forState:UIControlStateNormal];
        self.const_TOP.constant = self.const_TOP_default;
        
        [self.btnSwitch setNeedsUpdateConstraints];
        [self.btnSwitch layoutIfNeeded];
        [self.view layoutIfNeeded];
    }else{
        self.view1_1.hidden = true;
        self.view1_2.hidden = true;
        self.view2_1.hidden = false;
        NSString* title = kLang(@"login_by_username");
        [self.btnSwitch setTitle:title forState:UIControlStateNormal];
        self.const_TOP.constant = 20;
        
        [self.btnSwitch setNeedsUpdateConstraints];
        [self.btnSwitch layoutIfNeeded];
        [self.view layoutIfNeeded];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionChangeDomain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionForgotPassword:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCForgotPassword"];
}
- (IBAction)actionSwitch:(UIView*)sender {
    if(self.m_status == 0){
        self.m_status = 1;
    }else{
        self.m_status = 0;
        
    }
    [self setSwitchViews];
}
- (IBAction)actionLogin:(UIView*)sender {
    [Global showIndicator:self];
    
    NSString* username = @"";
    NSString* password = @"";
    
    if (self.m_status == 0) {
        username = self.tfUserName.text ;
        password = self.tfPassword.text;
        if([username isEqualToString:@""]) {
            [Global AlertMessage:self Message:kLang(@"input_username") Title:kLang(@"alert")];
            return;
        }
        if([password isEqualToString:@""]) {
            [Global AlertMessage:self Message:kLang(@"input_password") Title:kLang(@"alert")];
            return;
        }
    }else{
        username = self.tfUserCode.text;
        if([username isEqualToString:@""]) {
            [Global AlertMessage:self Message:kLang(@"input_code") Title:kLang(@"alert")];
            return;
        }
    }
    
    [[NetworkParser shared] serviceLogin:username withPassword:password withMode:self.m_status withCompletionBlock:^(id responseObject, NSString *error) {
       if(error == nil) {
           [[UserInfo shared] setToken:[UserInfo shared].mAccount.mToken];
           [self serviceGetProfile:[UserInfo shared].mAccount.mToken];
       }else {
           if (self.m_status == 0) {
               [Global AlertMessage:self Message:kLang(@"invalid_account") Title:kLang(@"alert")];
           }else{
               [Global AlertMessage:self Message:kLang(@"invalid_code") Title:kLang(@"alert")];
           }
           
       }
       [Global stopIndicator:self];
   }];
}

- (void) serviceGetProfile:(NSString*) token {
    [[NetworkParser shared] serviceGetProfile:token withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            UserModel* model = (UserModel*) responseObject;
            [UserInfo shared].mAccount.mToken = token;
            [[UserInfo shared] intercomCreateUser];
            [[NetworkParser shared] serviceGetSettings:nil];
            if([UserInfo shared].mApnsToken != nil && ![[UserInfo shared].mApnsToken isEqualToString:@""]) {
                [[NetworkParser shared] serviceUpdateAPNSToken:[UserInfo shared].mApnsToken withCompletionBlock:nil];
            }
            [self gotoAssign];
     
        }
    }];
}

- (void) gotoAssign {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCAssign" withOptions:@{@"reset":@"1"}];
}

@end
