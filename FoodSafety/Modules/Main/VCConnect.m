//
//  VCConnect.m
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCConnect.h"
#import "Global.h"
#import "NetworkParser.h"
#import "Language.h"
#import "UserInfo.h"

@interface VCConnect ()

@end

@implementation VCConnect

- (void)viewDidLoad {
    [super viewDidLoad];
    if([APP_MODE isEqualToString:@"local_development"]) {
        _tfDomain.text = @"foodsafety";
    }
    //test
    //_tfDomain.text = @"secretsdecuisine";
    //_tfDomain.text = @"farguesmathieu";
    // Do any additional setup after loading the view.
    [self.btnCreateAccount setTitle:kLang(@"create_account") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) connect {
    [Global showIndicator:self];
    NSString *domain = [self.tfDomain.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    if([domain isEqualToString:@""]) {
        [Global AlertMessage:self Message:kLang(@"input_domain") Title:@"Alert"];
    }
    [[NetworkParser shared] serviceCheckSubdomain:domain withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] setDomain: domain];           
            sAppDomain = @"";
            sAppDomain = [[[[sAppDomain stringByAppendingString:@"https://"]  stringByAppendingString:domain ] stringByAppendingString:@".the-haccp-app.com" ] stringByAppendingString:@"/index.php/api/"];
            [self gotoLogin];
        }else {
            [Global AlertMessage:self Message:kLang(@"invalid_domain") Title:@"Alert"];
        }
        [Global stopIndicator:self];
    }];
}

- (void) gotoLogin {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCLogin"];
}

- (IBAction)actionConnect:(id)sender {
    if( [APP_MODE isEqualToString:@"local_development"]) {
        sAppDomain = @"http://192.168.1.102:88/foodapp/index.php/api/";
        NSString *domain = [self.tfDomain.text stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        [[UserInfo shared] setDomain: domain];
        [self gotoLogin];
    }else if( [APP_MODE isEqualToString:@"development"]) {
   
        
        NSString *domain = [self.tfDomain.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
        [[UserInfo shared] setDomain: domain];
        
        sAppDomain = @"";
        sAppDomain = [[[[sAppDomain stringByAppendingString:@"https://"]  stringByAppendingString:domain ] stringByAppendingString:@".the-haccp-app.com" ] stringByAppendingString:@"/index.php/api/"];
        [self gotoLogin];
    }else {
        [self connect];
    }
}
- (IBAction)createAccount:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kLang(@"create_link")]];
}





@end
