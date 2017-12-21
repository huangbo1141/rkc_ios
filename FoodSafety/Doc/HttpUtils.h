//
//  HttpUtils.h
//  airstrike7on7
//
//  Created by BoHuang on 7/7/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^NetworkCompletionBlock)(id responseObject, NSString* error);
@interface HttpUtils : NSObject
+ (instancetype)shared;

- (void)makeUnsignedGetRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)makeUnsignedPostRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)makeSignedGetRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)makeSignedPostRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)makePurePostRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)makePureGetRequest:(NSString*) url withParams:(NSMutableDictionary*)params withCompletionBlock:(NetworkCompletionBlock)completionBlock;


@end
