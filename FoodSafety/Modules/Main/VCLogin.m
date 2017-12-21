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

- (IBAction)actionLogin:(id)sender {
    [Global showIndicator:self];
    NSString* username = self.tfUserName.text ;
    NSString* password = self.tfPassword.text;
    if([username isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_username") Title:kLang(@"alert")];
        return;
    }
    if([password isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_password") Title:kLang(@"alert")];
        return;
    }
   [[NetworkParser shared] serviceLogin:username withPassword:password withCompletionBlock:^(id responseObject, NSString *error) {
       if(error == nil) {
           [[UserInfo shared] setToken:[UserInfo shared].mAccount.mToken];
           [self serviceGetProfile:[UserInfo shared].mAccount.mToken];
       }else {
           [Global AlertMessage:self Message:kLang(@"invalid_account") Title:kLang(@"alert")];
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
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCAssign"];
}

@end
