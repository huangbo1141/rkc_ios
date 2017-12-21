//
//  VCSpash.m
//  FoodSafety
//
//  Created by BoHuang on 8/15/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCSpash.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "Global.h"

@interface VCSpash ()

@end

@implementation VCSpash

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initReg];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initReg {   
    NSString* token = [[UserInfo shared] getToken];
    if(token != nil && ![token isEqualToString:@""]) {
        [[NetworkParser  shared] serviceGetProfile:token withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                UserModel* model = (UserModel*) responseObject;
                [UserInfo shared].mAccount = model;
                [UserInfo shared].mAccount.mToken = token;
                [[UserInfo shared] setLogined:true];
                [[UserInfo shared] intercomCreateUser];
                if([UserInfo shared].mApnsToken != nil && ![[UserInfo shared].mApnsToken isEqualToString:@""]) {
                    [[NetworkParser shared] serviceUpdateAPNSToken:[UserInfo shared].mApnsToken withCompletionBlock:nil];
                }
                [[NetworkParser shared]  serviceGetSettings:^(id responseObject, NSString *error) {
                    [self gotoAssign];
                }];

            }else{
                [[UserInfo shared] setLogined:false];
                [self gotoConnect];
            }
                
        }];
    }else {
        [[UserInfo shared] setLogined:false];
        [self gotoConnect];
    }
    
}

- (void) gotoConnect {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCConnect"];
}

- (void) gotoAssign {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCAssign"];
}
@end
