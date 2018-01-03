	//
//  VCMenuAddUser.m
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuAddUser.h"
#import "Global.h"
#import "Language.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "HttpUtils.h"
@interface VCMenuAddUser ()

@end

@implementation VCMenuAddUser

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
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSString *url = sAppDomain;
    
    if (self.m_status == 0) {
        [keys addObject:@"username"];
        [objects addObject:username];
        [keys addObject:@"password"];
        [objects addObject:password];
        url = [url stringByAppendingString:LOGIN];
    }else{
        [keys addObject:@"digit_code"];
        [objects addObject:username];
        url = [url stringByAppendingString:LOGIN_DIGIT];
    }
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [Global showIndicator:self];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* response = (NSDictionary*) responseObject;
            if([response objectForKey:@"login"] == nil) {
                // error
                return;
            }
            [Global stopIndicator:self];
            if( [[response objectForKey:@"login"] intValue] == 0 ) {
                
            }else if([[response objectForKey:@"login"] intValue] == 1 ) {
                // save info
                if (self.m_status == 0) {
                    // username
                    
                }else{
                    // usercode
                    
                }
                NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
                data[@"m_status"] = [NSString stringWithFormat:@"%d",self.m_status];
                data[@"username"] = username;
                data[@"password"] = password;
                
                NSString* domain = [[UserInfo shared] getDomain];
                NSString* key_domain = [NSString stringWithFormat:@"key_%@",domain];
                
                id saved_data = [[NSUserDefaults standardUserDefaults] objectForKey:key_domain];
                NSMutableArray* tempArray = [[NSMutableArray alloc] init];
                if (saved_data != nil) {
                    NSArray* array = saved_data;
                    for (id obj in array) {
                        NSDictionary* iDict = obj;
                        if (![username isEqualToString:iDict[@"username"]]) {
                            [tempArray addObject:obj];
                        }
                        
                    }
                }
                [tempArray addObject:data];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:key_domain];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:true];
                });
                
                return;
            }
            if([response objectForKey:@"token"]) {
                [UserInfo shared].mAccount.mToken = [response objectForKey:@"token"];
            }
            
            
        }
        
        if (self.m_status == 0) {
            [Global AlertMessage:self Message:kLang(@"invalid_account") Title:kLang(@"alert")];
        }else{
            [Global AlertMessage:self Message:kLang(@"invalid_code") Title:kLang(@"alert")];
        }
    }];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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

