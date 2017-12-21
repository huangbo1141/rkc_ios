//
//  HttpUtils.m
//  airstrike7on7
//
//  Created by BoHuang on 7/7/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "HttpUtils.h"
#import "Global.h"
#import "UserInfo.h"

@implementation HttpUtils

+ (instancetype)shared
{
    static HttpUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HttpUtils alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)makePurePostRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSURL *URL = [NSURL URLWithString:url];
    if(URL == nil){
        if(completionBlock) {
            completionBlock(nil, @"url error");
        }
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.securityPolicy.allowInvalidCertificates=YES;
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* response = (NSDictionary*)responseObject;
        if(completionBlock) {
            completionBlock(response, nil);
        }
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", errResponse);
        if(completionBlock) {
            completionBlock(nil, errResponse);
        }
        
    }];

}
- (void)makePureGetRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSURL *URL = [NSURL URLWithString:url];
    if(URL == nil){
        if(completionBlock) {
            completionBlock(nil, @"url error");
        }
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.securityPolicy.allowInvalidCertificates=YES;
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* response = (NSDictionary*)responseObject;
        if(completionBlock) {
            completionBlock(response, nil);
        }
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", errResponse);
        if(completionBlock) {
            completionBlock(nil, errResponse);
        }
        
    }];
    
}

- (void)makeUnsignedGetRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSURL *URL = [NSURL URLWithString:url];
    if(URL == nil){
        if(completionBlock) {
            completionBlock(nil, @"url error");
        }
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   // manager.securityPolicy.allowInvalidCertificates=YES;
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* response = (NSDictionary*)responseObject;
        if([response objectForKey:@"valid"] == nil) {
            NSString* error = @"Invaild response structure.";
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        int valid = [[response objectForKey:@"valid"] intValue];
        
        
        if(valid == 1){
            //NSDictionary* data = [response objectForKey:@"data"];
            if (completionBlock) {
                completionBlock(response, nil);
            }
            
        }else {
            if (completionBlock) {
                completionBlock(nil, @"error");
            }
            
        
        }
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", errResponse);
        if(completionBlock) {
            completionBlock(nil, errResponse);
        }
        
    }];
    
}

- (void)makeUnsignedPostRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSURL *URL = [NSURL URLWithString:url];
    if(URL == nil){
        if(completionBlock) {
            completionBlock(nil, @"url error");
        }
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* response = (NSDictionary*)responseObject;
        if([response objectForKey:@"valid"] == nil) {
            NSString* error = @"Invaild response structure.";
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        int valid = [[response objectForKey:@"valid"] intValue];
        
        
        if(valid == 1){
            //NSDictionary* data = [response objectForKey:@"data"];
            if (completionBlock) {
                completionBlock(response, nil);
            }
            
        }else {
            if (completionBlock) {
                completionBlock(nil, @"error");
            }
            
        }
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", errResponse);
        if(completionBlock) {
            completionBlock(nil, errResponse);
        }
        
    }];
}

- (void)makeSignedGetRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSURL *URL = [NSURL URLWithString:url];
    if(URL == nil){
        if(completionBlock) {
            completionBlock(nil, @"url error");
        }
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.securityPolicy.allowInvalidCertificates=YES;
    NSString *token = [UserInfo shared].mAccount.mToken;
    if(token != nil) {
        params[@"token"] = token;
    } else {
        if(completionBlock)
            completionBlock(nil, @"Token empty.");
        return;
    }
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* response = (NSDictionary*)responseObject;
        if([response objectForKey:@"valid"] == nil ) {
            NSString* error = @"Invaild response structure.";
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        int valid = [[response objectForKey:@"valid"] intValue];

        
        
        if(valid == 1){
            //NSDictionary* data = [response objectForKey:@"data"];
            if (completionBlock) {
                completionBlock(response, nil);
            }
            
        }else {
            if (completionBlock) {
                completionBlock(nil, @"error");
            }
            
        }
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", errResponse);
        if(completionBlock) {
            completionBlock(nil, errResponse);
        }
        
    }];
}

- (void)makeSignedPostRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSURL *URL = [NSURL URLWithString:url];
    NSString *token = [UserInfo shared].mAccount.mToken;
    if(URL == nil){
        if(completionBlock) {
            completionBlock(nil, @"url error");
        }
        return;
    }
    if(token != nil) {
        params[@"token"] = token;
    } else {
        if(completionBlock)
            completionBlock(nil, @"Token empty.");
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.securityPolicy.allowInvalidCertificates=YES;
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* response = (NSDictionary*)responseObject;
        if([response objectForKey:@"valid"] == nil ) {
            NSString* error = @"Invaild response structure.";
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        int valid = [[response objectForKey:@"valid"] intValue];
        if(valid == 1){
            //NSDictionary* data = [response objectForKey:@"data"];
            if (completionBlock) {
                completionBlock(response, nil);
            }
            
        }else {
            if (completionBlock) {
                completionBlock(nil, @"error");
            }
            
        }
        
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", errResponse);
        if(completionBlock) {
            completionBlock(nil, errResponse);
        }
        
    }];
}

@end
