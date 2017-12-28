//
//  NetworkParser.m
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "NetworkParser.h"
#import "UserInfo.h"
#import "Global.h"
#import "HttpUtils.h"
#import "PermissionModel.h"
#import "LaboratoryInfoModel.h"
#import "AssignTaskModel.h"
#import "UserModel.h"
#import "LogModel.h"

@implementation NetworkParser

+ (instancetype)shared
{
    static NetworkParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkParser alloc] init];
        
    });
    
    return sharedInstance;
}


- (void)serviceCheckSubdomain:(NSString*)subdomain withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"domain"];
    [objects addObject:subdomain];

    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = CONTROL_DOMAIN_URL;
   // url = [url stringByAppendingString:CHECK_APP_DOMAIN];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* response = (NSDictionary*) responseObject;
            if([response objectForKey:@"result"] == nil) {
                    completionBlock(nil, @"error");
                return;
            }
            if([[response objectForKey:@"result"] intValue] == 1){
                completionBlock(@"success", nil);
            }else {
                completionBlock(nil, @"invalid");
            }

        } else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceLogin:(NSString*)username withPassword:(NSString*)password withMode:(int)mode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSString *url = sAppDomain;
    
    if (mode == 0) {
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
    
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* response = (NSDictionary*) responseObject;
            if([response objectForKey:@"login"] == nil) {
                if(completionBlock) {
                    completionBlock(nil, @"empty");
                }
                return;
            }
            if( [[response objectForKey:@"login"] intValue] == 0 ) {
                if(completionBlock) {
                    completionBlock(nil, @"fail");
                }
                return;
            }else if([[response objectForKey:@"login"] intValue] == 1 ) {
                if([response objectForKey:@"permission"] != nil) {
                    NSDictionary* permissions = [response objectForKey:@"permission"];
                    if([permissions isKindOfClass:[NSDictionary class]]) {
           
                        [[UserInfo shared].mAccount.mPermissionModel parse:permissions];
                        [UserInfo shared].mAccount.mUserName = username;
                        [UserInfo shared].mAccount.mPassword = password;
                    }else {
                        [[UserInfo shared].mAccount.mPermissionModel allowAllPermissions];
                    }
                }
            }
            if([response objectForKey:@"token"]) {
                [UserInfo shared].mAccount.mToken = [response objectForKey:@"token"];
            }
            
                
            if(completionBlock) {
                completionBlock([UserInfo shared].mAccount, nil);
            }
        } else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
        
    }];
    
}


- (void)serviceForgotPassword:(NSString*)email withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"email"];
    [objects addObject:email];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:FORGOT_PASSWORD];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"result"] != nil) {
                
                NSString *result = [dict objectForKey:@"result"];
                if([result longLongValue] == 0) {
                    completionBlock(@"Your email address is not registered.", error);
                }else {
                    completionBlock(@"success", error);
                }
            }


        }else {
            completionBlock(nil, error);
        }
    }];
    
}

- (void)serviceTodayTask:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
     NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:TODAY_TASK];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
            NSDictionary* dict = (NSDictionary*) responseObject;
            NSMutableArray* models = [[NSMutableArray alloc] init];
            NSDictionary* data = dict;
            
            if([data objectForKey:@"fridges"] != nil) {
                NSDictionary* values = [data objectForKey:@"fridges"];
                for(NSDictionary* value in values) {
                    AssignTaskModel* model = [[AssignTaskModel alloc] init];
                    [model parse:@"fridge" withDict:value];
                    [models addObject:model];
                }
            }
            ret[@"fridges"] = models;
            models = [[NSMutableArray alloc] init];
            
            if([data objectForKey:@"freezers"] != nil) {
                NSDictionary* values = [data objectForKey:@"freezers"];
                for(NSDictionary* value in values) {
                    AssignTaskModel* model = [[AssignTaskModel alloc] init];
                    [model parse:@"freezer" withDict:value];
                    [models addObject:model];
                }
                
            }
            ret[@"freezers"] = models;
            models = [[NSMutableArray alloc] init];
            
            if([data objectForKey:@"oils"] != nil) {
                NSDictionary* values = [data objectForKey:@"oils"];
                for(NSDictionary* value in values) {
                    AssignTaskModel* model = [[AssignTaskModel alloc] init];
                    [model parse:@"oil" withDict:value];
                    [models addObject:model];
                }
                
            }
            ret[@"oils"] = models;
            models = [[NSMutableArray alloc] init];
            
            if([data objectForKey:@"cleanings"] != nil) {
                NSDictionary* values = [data objectForKey:@"cleanings"];
                for(NSDictionary* value in values) {
                    AssignTaskModel* model = [[AssignTaskModel alloc] init];
                    [model parse:@"cleaning" withDict:value];
                    [models addObject:model];
                }
                
            }
            ret[@"cleanings"] = models;
            models = [[NSMutableArray alloc] init];
            
            if([data objectForKey:@"customs"] != nil) {
                NSDictionary* values = [data objectForKey:@"customs"];
                for(NSDictionary* value in values) {
                    AssignTaskModel* model = [[AssignTaskModel alloc] init];
                    [model parse:@"expire" withDict:value];
                    [models addObject:model];
                }
                
            }
            ret[@"expire"] = models;
            models = [[NSMutableArray alloc] init];
            
            
            if(completionBlock) {
                    completionBlock(ret, nil);
                }
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}


- (void) serviceUpdateAPNSToken:(NSString*) apnsToken withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"apns_token"];
    [objects addObject:apnsToken];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:UPDATE_APNSTOKEN];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if(completionBlock) {
                completionBlock( nil,@"Capture faild.");
            }
            
        } else {
            if(completionBlock) {
                completionBlock( @"success", nil);
            }
           
            
        }
        
    }];
    
}
- (void)serviceGetProfile:(NSString*) token withCompletionBlock:(NetworkCompletionBlock)completionBlock;{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:token];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_PROFILE];
    [[HttpUtils shared] makeUnsignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"profile"] != nil){
                NSDictionary* profile = [dict objectForKey:@"profile"];
                UserModel* model = [UserInfo shared].mAccount;
                model.mFirstName = [profile objectForKey:@"first_name"];
                if(model.mFirstName == nil || [model.mFirstName isKindOfClass:[NSNull class]]){
                    model.mFirstName = @"";
                }
                model.mLastName = [profile objectForKey:@"last_name"];
                if(model.mLastName == nil || [model.mLastName isKindOfClass:[NSNull class]]){
                    model.mLastName = @"";
                }
                model.mEmail = [profile objectForKey:@"email"];
                model.mPhoneNumber = [profile objectForKey:@"phone"];
                if(model.mPhoneNumber == nil || [model.mPhoneNumber isKindOfClass:[NSNull class]]){
                    model.mPhoneNumber = @"";
                }
                model.mAvatar = [profile objectForKey:@"avatar"];
                if(model.mAvatar == nil || [model.mAvatar isKindOfClass:[NSNull class]]){
                    model.mAvatar = @"";
                }
                model.mSignature = [profile objectForKey:@"signature"];
                if(model.mSignature != nil && [model.mSignature isKindOfClass:[NSNull class]])
                    model.mSignature = nil;
                model.mUserKey = [profile objectForKey:@"user_key"];
                model.mCompanyName = [profile objectForKey:@"company_name"];
                
                model.mRoleName = [profile objectForKey:@"role_name"];
                if(model.mRoleName != nil && [model.mRoleName isKindOfClass:[NSNull class]])
                    model.mRoleName = nil;
                model.mUserPosition = [profile objectForKey:@"user_position"];
                if(model.mUserPosition != nil && [model.mUserPosition isKindOfClass:[NSNull class]])
                    model.mUserPosition = nil;
                model.mSignUpTime = [profile objectForKey:@"sign_up_time"];
                if(model.mSignUpTime != nil && [model.mSignUpTime isKindOfClass:[NSNull class]])
                    model.mSignUpTime = nil;
                
                
                
                if([profile objectForKey:@"permission"] != nil) {
        
                        NSDictionary* permissions = [profile objectForKey:@"permission"];
                        if([permissions isKindOfClass:[NSDictionary class]]) {
                            
                           [[UserInfo shared].mAccount.mPermissionModel parse:permissions];
        
                        }else {
                            [[UserInfo shared].mAccount.mPermissionModel allowAllPermissions];
                        }
            
                }
                if(completionBlock) {
                    completionBlock(model, nil);
                }
                


            }else {
                if(completionBlock) {
                    completionBlock(nil, error);
                }
            }
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceSaveProfile:(UserModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"first_name"];
    [objects addObject:model.mFirstName];
    [keys addObject:@"last_name"];
    [objects addObject:model.mLastName];
    [keys addObject:@"email"];
    [objects addObject:model.mEmail];
    [keys addObject:@"phone"];
    [objects addObject:model.mPhoneNumber];
    [keys addObject:@"signature"];
    [objects addObject:model.mSignature];
    if(model.mPassword != nil && ![model.mPassword isEqualToString:@""]){
        [keys addObject:@"password"];
        [objects addObject:model.mPassword];
    }
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:SAVE_PROFILE];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"avata[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(@"Profile save faild.", nil);
                              }
                              
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                              
                              NSDictionary* dict = (NSDictionary*)responseObject;
                              if(![dict objectForKey:@"valid"]) {
                                  if(completionBlock) {
                                      completionBlock(nil,@"empty");
                                  }
                                  return;
                                  
                              }
                              int valid =[[dict objectForKey:@"valid"] intValue];
                              
                              if(valid == 0){
                                  if(completionBlock) {
                                      completionBlock(nil,@"invalid_token");
                                  }
                              }else if(valid == 1) {
                                  if(completionBlock) {
                                      completionBlock(@"1", nil);
                                  }
                              }else {
                                  if(completionBlock) {
                                      completionBlock(nil, @"invalid_email");
                                  }
                                  
                              }
                              
                              
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock(nil, @"error");
                }
                
            } else {
                
                NSDictionary* dict = (NSDictionary*)responseObject;
                if(![dict objectForKey:@"valid"]) {
                    if(completionBlock) {
                        completionBlock(nil,@"empty");
                    }
                    return;
                    
                }
                int valid =[[dict objectForKey:@"valid"] intValue];
                
                if(valid == 0){
                    if(completionBlock) {
                        completionBlock(nil,@"invalid_token");
                    }
                }else if(valid == 1) {
                    if(completionBlock) {
                        completionBlock(@"1", nil);
                    }
                }else {
                    if(completionBlock) {
                        completionBlock(nil, @"invalid_email");
                    }
                }
            }

        }];
    }
    
   
    
}

- (void)serviceGetSettings:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_SETTINGS];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                NSDictionary* data = [dict objectForKey:@"data"];
                [[SettingModel shared] parse:data];
            }
            if(completionBlock) {
                completionBlock([SettingModel shared], nil);
            }
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceGetFridgeInfo:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];

    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_FRIDGE_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);

                }
            }else {
                 completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceDeleteFridge:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_FRIDGE];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}



- (void)serviceCaptureFridge:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"location"];
    [objects addObject:model.mLocation];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_FRIDGE];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}


- (void)serviceGetFreezerInfo:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_FREEZE_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceDeleteFreezer:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_FREEZE];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
         
                completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}



- (void)serviceCaptureFreezer:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"location"];
    [objects addObject:model.mLocation];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_FREEZE];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}

- (void) serviceGetItemForKeyCode:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];

    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_ITEM];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            NSDictionary* response = (NSDictionary*) responseObject;
            if([response objectForKey:@"data"] == nil) {
                if(completionBlock) {
                    completionBlock(nil, @"empty");
                }
                return;
            }
            NSDictionary* dict = [response objectForKey:@"data"];
            ItemModel* itemModel = [[ItemModel alloc] init];
            [itemModel parse:dict];
            if(completionBlock) {
                completionBlock(itemModel, nil);
            }
        } else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
        
    }];
    
    
}
- (void) serviceGetItemInfo:(NSDictionary*) conditions withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"conditions"];
    [objects addObject:[Global dictToJson:conditions]];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_ITEM_INFO];
    
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                ItemInfoModel* infoModel = [[ItemInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}
- (void) serviceCreateItem:(ItemModel*) model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"name"];
    [objects addObject:model.mName];
    [keys addObject:@"batch_number"];
    [objects addObject:model.mBatch];
    [keys addObject:@"description"];
    [objects addObject:model.mDescription];
    [keys addObject:@"create_date"];
    [objects addObject: [model getMysqlCreateDate]];
    [keys addObject:@"expire_date"];
    [objects addObject: [model getMysqlExpireDate]];
    [keys addObject:@"allergens"];
    [objects addObject: [Global dictToJson:(NSDictionary*)model.mAllergens]];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CREATE_ITEM];
    NSURL *URL = [NSURL URLWithString:url];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if(completionBlock) {
                completionBlock( nil,@"Capture faild.");
            }
            
        } else {
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                ItemModel* itemModel = [[ItemModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [itemModel parse:data];
                    completionBlock(itemModel, nil);
                }else {
                    completionBlock(itemModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }

        }
        
    }];
    
}
- (void) serviceUpdateItem:(ItemModel*) model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];

    [keys addObject:@"name"];
    [objects addObject:model.mName];
    [keys addObject:@"batch_number"];
    [objects addObject:model.mBatch];
    [keys addObject:@"description"];
    [objects addObject:model.mDescription];
    [keys addObject:@"create_date"];
    [objects addObject: [model getMysqlCreateDate]];
    [keys addObject:@"expire_date"];
    [objects addObject: [model getMysqlExpireDate]];
    [keys addObject:@"allergens"];
    [objects addObject: [Global dictToJson:(NSDictionary*)model.mAllergens]];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [[[url stringByAppendingString:UPDATE_ITEM] stringByAppendingString:@"/"] stringByAppendingString:model.mKeyCode  ];
    NSURL *URL = [NSURL URLWithString:url];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if(completionBlock) {
                completionBlock( nil,@"Capture faild.");
            }
            
        } else {
 
                completionBlock(@"success", nil);
         
            
        }
        
    }];
}
- (void) serviceDeleteItem:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_ITEM];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceGetReheatingInfo:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_REHEATING_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceDeleteReheating:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_REHEATING];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}



- (void)serviceCaptureReheating:(LogModel *)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item_id"];
    [objects addObject:model.mItemId];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_REHEATING];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}


- (void)serviceGetCoolingInfo:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_COOLING_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceDeleteCooling:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_COOLING];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}



- (void)serviceCaptureCooling:(LogModel *)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item_id"];
    [objects addObject:model.mItemId];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_COOLING];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}

- (void)serviceGetServiceInfo:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_SERVICE_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}

- (void)serviceDeleteService:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_SERVICE];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}



- (void)serviceCaptureService:(LogModel *)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item_id"];
    [objects addObject:model.mItemId];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_SERVICE];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}

- (void)serviceGetDeliveryInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_DELIVERY_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                DeliveryInfoModel* infoModel = [[DeliveryInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];

}
- (void)serviceDeleteDelivery:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_DELIVERY];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceCaptureDelivery:(DeliveryModel*)model withAction: (NSString*)action withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item"];
    [objects addObject:[model getItemsJson]];
    if(model.mSupplier != nil && ![model.mSupplier isEqualToString:@""]) {
        [keys addObject:@"supplier"];
        [objects addObject:model.mSupplier];
    }
    [keys addObject:@"number"];
    [objects addObject:model.mNumber];
    [keys addObject:@"accept_datetime"];
    [objects addObject:model.mAcceptDatetime];
    [keys addObject:@"temperature"];
    [objects addObject:model.mTemperature];
    [keys addObject:@"temp_accept"];
    [objects addObject:model.mTempAccept];
    [keys addObject:@"cond_accept"];
    [objects addObject:model.mCondAccept];
    [keys addObject:@"date_accept"];
    [objects addObject:model.mDateAccept];
    [keys addObject:@"aspect_accept"];
    [objects addObject:model.mAspectAccept];
    [keys addObject:@"quality_accept"];
    [objects addObject:model.mQualityAccept];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"action"];
    [objects addObject:action];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_DELIVERY];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              NSDictionary* dict =(NSDictionary*) responseObject;
                              if([dict objectForKey:@"data"] != nil && [[dict objectForKey:@"data"] isKindOfClass:[NSString class]]) {
                                  NSString* keyCode = (NSString*)[dict objectForKey:@"data"] ;
                                  if(completionBlock) {
                                      
                                      completionBlock(keyCode, nil);
                                  }
                              }else {
                                  if(completionBlock) {
                                      
                                      completionBlock(nil, @"error");
                                  }
                              }
           
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                NSDictionary* dict =(NSDictionary*) responseObject;
                if([dict objectForKey:@"data"]) {
                    NSString* keyCode = (NSString*)[dict objectForKey:@"data"] ;
                    if(completionBlock) {
                        
                        completionBlock(keyCode, nil);
                    }
                }else {
                    if(completionBlock) {
                        
                        completionBlock(nil, @"error");
                    }
                }
            }
            
        }];
    }
}
- (void)serviceDeliveryUploadLabel:(UIImage*) image withKeyCode:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    if(image == nil || keyCode == nil){
        if(completionBlock) {
            completionBlock(nil, @"Nil Error");
        }
        return;
    }
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELIVERY_UPLOAD_LABEL];
    NSURL *URL = [NSURL URLWithString:url];
    

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
           
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }


- (void)serviceGetTransportInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_TRANSPORT_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                TransportInfoModel* infoModel = [[TransportInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceDeleteTransport:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_TRANSPORT];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceTransportDeparture:(TransportModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item"];
    [objects addObject:model.mItem];
    [keys addObject:@"number"];
    [objects addObject:model.mNumber];
    [keys addObject:@"departure_comment"];
    [objects addObject:model.mDepartureComment];
    [keys addObject:@"departure_area"];
    [objects addObject:model.mDepartureArea];
    [keys addObject:@"departure_date"];
    [objects addObject:[model getMysqlDepartureDate]];
    [keys addObject:@"departure_time"];
    [objects addObject:[model getMysqlDepartureTime]];
    [keys addObject:@"departure_temp"];
    [objects addObject:model.mDepartureTemp];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DEPARTURE_TRANSPORT];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mInvoiceImage != nil || model.mGoodImage != nil) {
        UIImage* invoiceImage = model.mInvoiceImage;
       UIImage* goodImage = model.mGoodImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(invoiceImage != nil){
                   NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                   filename = [filename stringByAppendingString:@".jpeg"];
                   
                   NSData *imageData = UIImageJPEGRepresentation(invoiceImage,0.7);
                   
                   [formData appendPartWithFileData:imageData name:@"invoice_attach" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
               }
            if(goodImage != nil){
                NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                filename = [filename stringByAppendingString:@".jpeg"];
                
                NSData *imageData = UIImageJPEGRepresentation(goodImage,0.7);
                
                [formData appendPartWithFileData:imageData name:@"good_attach" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            }
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
}
- (void)serviceTransportArrival:(TransportModel*)model withAction:(NSString*) action withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"key_code"];
    [objects addObject:model.mKeyCode];
    [keys addObject:@"item"];
    [objects addObject:model.mItem];
    [keys addObject:@"number"];
    [objects addObject:model.mNumber];
    [keys addObject:@"arrival_comment"];
    [objects addObject:model.mArrivalComment];
    [keys addObject:@"arrival_area"];
    [objects addObject:model.mArrivalArea];
    [keys addObject:@"arrival_date"];
    [objects addObject:[model getMysqlArrivalDate]];
    [keys addObject:@"arrival_time"];
    [objects addObject:[model getMysqlArrivalTime]];
    [keys addObject:@"arrival_temp"];
    [objects addObject:model.mArrivalTemp];
    [keys addObject:@"action"];
    [objects addObject:action];

    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:ARRIVAL_TRANSPORT];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mInvoiceImage != nil || model.mGoodImage != nil) {
        UIImage* invoiceImage = model.mInvoiceImage;
        UIImage* goodImage = model.mGoodImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(invoiceImage != nil){
                NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                filename = [filename stringByAppendingString:@".jpeg"];
                
                NSData *imageData = UIImageJPEGRepresentation(invoiceImage,0.7);
                
                [formData appendPartWithFileData:imageData name:@"invoice_attach" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            }
            if(goodImage != nil){
                NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                filename = [filename stringByAppendingString:@".jpeg"];
                
                NSData *imageData = UIImageJPEGRepresentation(goodImage,0.7);
                
                [formData appendPartWithFileData:imageData name:@"good_attach" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            }
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
    
}

- (void)serviceGetCleaningInfo:(NSString*) startDate withEndDate:(NSString*) endDate withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"start"];
    [objects addObject:startDate];
    [keys addObject:@"end"];
    [objects addObject:endDate];

    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_CLEANING_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceGetCleaningItem:(NSString*) itemId withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"item_id"];
    [objects addObject:itemId];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_CLEANING_ITEM];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                ItemModel* itemModel = [[ItemModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [itemModel parse:data];
                    completionBlock(itemModel, nil);
                }else {
                    completionBlock(itemModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceDeleteCleaning:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_CLEANING];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceCaptureCleaning:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item"];
    [objects addObject:model.mItem];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_CLEANING];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }

}

- (void)serviceGetOilInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_OIL_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                InfoModel* infoModel = [[InfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];


}
- (void)serviceGetOilItem:(NSString*) itemId withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"item_id"];
    [objects addObject:itemId];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_OIL_ITEM];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                ItemModel* itemModel = [[ItemModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [itemModel parse:data];
                    completionBlock(itemModel, nil);
                }else {
                    completionBlock(itemModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];

}

-(void)serviceDeleteOil:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_OIL];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceCaptureOil:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"item"];
    [objects addObject:model.mItem];
    [keys addObject:@"capture_value"];
    [objects addObject:model.mCaptureValue];
    [keys addObject:@"capture_datetime"];
    [objects addObject:[model getMysqlCaptureDatetime]];
    [keys addObject:@"capture_note"];
    [objects addObject:model.mCaptureNote];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CAPTURE_OIL];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mImage != nil) {
        UIImage* image = model.mImage;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpeg"];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"logo[]" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }

}

- (void)serviceGetMenuInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_MENU_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                MenuInfoModel* infoModel = [[MenuInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceCreateMenu:(DeliveryMenuModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"items"];
    [objects addObject:[model getItemsJson]];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    [keys addObject:@"log_time"];
    [objects addObject:[model getLogTimeJson]];
    [keys addObject:@"location"];
    [objects addObject:model.mLocation];
    [keys addObject:@"labels"];
    [objects addObject:[model getLabelsJson]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CREATE_MENU];
    NSURL *URL = [NSURL URLWithString:url];

        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    
}

- (void)serviceGetMenuDetail:(DeliveryMenuModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"key_code"];
    [objects addObject:model.mKeyCode];
   
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:MENU_DETAIL];
    NSURL *URL = [NSURL URLWithString:url];
    
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if(completionBlock) {
                completionBlock( nil,@"Capture faild.");
            }
            
        } else {
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data objectForKey:@"items"]) {
                    NSDictionary* items = [data objectForKey:@"items"];
                    [model.mItemModels removeAllObjects];
                    for(NSDictionary* item in items) {
                        ItemModel* itemModel = [[ItemModel alloc] init];
                        [itemModel parse:item];
                        [model.mItemModels addObject:itemModel];
                    }
                }
                
                if([data objectForKey:@"labels"]) {
                    NSDictionary* labels = [data objectForKey:@"labels"];
                    [model.mLabels removeAllObjects];
                    for(NSDictionary* label in labels) {
                        LabelModel* labelModel = [[LabelModel alloc] init];
                        [labelModel parse:label];
                        [model.mLabels addObject:labelModel];
                    }
                }
            }
            if(completionBlock) {
                completionBlock(@"success", nil);
            }
        }
        
    }];
}
- (void)serviceDeleteMenu:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_MENU];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}
- (void)serviceSearchLabels:(NSDictionary*) conditions withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"conditions"];
    [objects addObject:[Global dictToJson:conditions]];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:SEARCH_LABELS];
    
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
               
                NSMutableArray* labels = [[NSMutableArray alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSArray class]]) {
                    for(NSDictionary* label in data) {
                        LabelModel* model = [[LabelModel alloc] init];
                        [model parse:label];
                        [labels addObject:model];
                    }
                    completionBlock(labels, nil);
                }else {
                    completionBlock(labels, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];

}

- (void)serviceGetNotification:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_NOTIFICATION_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                NotificationInfoModel* infoModel = [[NotificationInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceDeleteNotification:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    [keys addObject:@"key_code"];
    [objects addObject:keyCode];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELETE_NOTIFICATION];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            
            completionBlock(@"success", nil);
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceGetSafetyInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_SAFETY_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                LaboratoryInfoModel* infoModel = [[LaboratoryInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceCreateSafety:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"operator"];
    [objects addObject:model.mOperatorId];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CREATE_SAFETY];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mFileName != nil) {
        NSString* fileName = model.mFileName;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
     
            
           /* NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            [formData appendPartWithFileData:imageData name:@"attached_file	" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];*/
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}
- (void)serviceUpdateSafety:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"operator"];
    [objects addObject:model.mOperatorId];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:UPDATE_SAFETY];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mFileName != nil) {
        NSString* fileName = model.mFileName;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            
            
            /* NSData *imageData = UIImageJPEGRepresentation(image,0.7);
             [formData appendPartWithFileData:imageData name:@"attached_file	" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];*/
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}
- (void)serviceGetLaboratoryInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_LABORATORY_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                LaboratoryInfoModel* infoModel = [[LaboratoryInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceCreateLaboratory:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"operator"];
    [objects addObject:model.mOperatorId];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CREATE_LABORATORY];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mFileName != nil) {
        NSString* fileName = model.mFileName;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            
            
            /* NSData *imageData = UIImageJPEGRepresentation(image,0.7);
             [formData appendPartWithFileData:imageData name:@"attached_file	" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];*/
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}
- (void)serviceUpdateLaboratory:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"operator"];
    [objects addObject:model.mOperatorId];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:UPDATE_LABORATORY];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mFileName != nil) {
        NSString* fileName = model.mFileName;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            
            
            /* NSData *imageData = UIImageJPEGRepresentation(image,0.7);
             [formData appendPartWithFileData:imageData name:@"attached_file	" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];*/
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}
- (void)serviceGetPestInfo:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_PEST_INFO];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                LaboratoryInfoModel* infoModel = [[LaboratoryInfoModel alloc] init];
                NSDictionary* data = [dict objectForKey:@"data"];
                if([data isKindOfClass:[NSDictionary class]]) {
                    [infoModel parse:data];
                    completionBlock(infoModel, nil);
                }else {
                    completionBlock(infoModel, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceCreatePest:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"operator"];
    [objects addObject:model.mOperatorId];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:CREATE_PEST];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mFileName != nil) {
        NSString* fileName = model.mFileName;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            
            
            /* NSData *imageData = UIImageJPEGRepresentation(image,0.7);
             [formData appendPartWithFileData:imageData name:@"attached_file	" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];*/
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}
- (void)serviceUpdatePest:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"token"];
    [objects addObject:[UserInfo shared].mAccount.mToken];
    [keys addObject:@"operator"];
    [objects addObject:model.mOperatorId];
    [keys addObject:@"comment"];
    [objects addObject:model.mComment];
    [keys addObject:@"title"];
    [objects addObject:model.mTitle];
    [keys addObject:@"log_date"];
    [objects addObject:[model getMysqlLogDate]];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:UPDATE_PEST];
    NSURL *URL = [NSURL URLWithString:url];
    
    if(model.mFileName != nil) {
        NSString* fileName = model.mFileName;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString* filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            
            
            /* NSData *imageData = UIImageJPEGRepresentation(image,0.7);
             [formData appendPartWithFileData:imageData name:@"attached_file	" fileName:filename mimeType:@"multipart/form-data;boundary=*****"];*/
            
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              //[progressView setProgress:uploadProgress.fractionCompleted];
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              if(completionBlock) {
                                  completionBlock(nil, @"error");
                              }
                              
                          } else {
                              
                              if(completionBlock) {
                                  completionBlock(@"success", nil);
                              }
                          }
                          
                      }];
        
        [uploadTask resume];
    }else {
        [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                if(completionBlock) {
                    completionBlock( nil,@"Capture faild.");
                }
                
            } else {
                
                if(completionBlock) {
                    completionBlock(@"success", nil);
                }
            }
            
        }];
    }
    
}

- (void)serviceGetOilItems:(NSString*) key withAreaId:(NSString*) areaId withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"query"];
    if(key != nil && ![key isEqualToString:@""]) {
        [objects addObject:key];
    }else {
        [objects addObject:@"codeigniter"];
    }
    [keys addObject:@"area_id"];
    if(areaId != nil && ![areaId isEqualToString:@""]) {
        [objects addObject:areaId];
    }
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_OIL_ITEMS];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                NSMutableArray* itemModels = [[NSMutableArray alloc] init];
                NSArray* items = [dict objectForKey:@"data"];
                if([items isKindOfClass:[NSArray class]]) {
                    for(NSDictionary* item in items) {
                        ItemModel* itemModel = [[ItemModel alloc] init];
                        [itemModel parse:item];
                        [itemModels addObject:itemModel];
                    }
                    completionBlock(itemModels, nil);
                }else {
                    completionBlock(itemModels, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceGetCleaningItems:(NSString*) key withAreaId:(NSString*) areaId withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [keys addObject:@"query"];
    if(key != nil && ![key isEqualToString:@""]) {
        [objects addObject:key];
    }else {
        [objects addObject:@"codeigniter"];
    }
    [keys addObject:@"area_id"];
    if(areaId != nil && ![areaId isEqualToString:@""]) {
        [objects addObject:areaId];
    }
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_CLEANING_ITEMS];
    [[HttpUtils shared] makePurePostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                NSMutableArray* itemModels = [[NSMutableArray alloc] init];
                NSArray* items = [dict objectForKey:@"data"];
                if([items isKindOfClass:[NSArray class]]) {
                    for(NSDictionary* item in items) {
                        ItemModel* itemModel = [[ItemModel alloc] init];
                        [itemModel parse:item];
                        [itemModels addObject:itemModel];
                    }
                    completionBlock(itemModels, nil);
                }else {
                    completionBlock(itemModels, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}


- (void)serviceGetItems:(NSString*) key withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:GET_ITEMS];
    if(key != nil && ![key isEqualToString:@""]) {
        url = [[url stringByAppendingString:@"/"] stringByAppendingString:key];
    }
    [[HttpUtils shared] makePureGetRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"items"] != nil) {
                NSMutableArray* itemModels = [[NSMutableArray alloc] init];
                NSArray* items = [dict objectForKey:@"items"];
                if([items isKindOfClass:[NSArray class]]) {
                    for(NSDictionary* item in items) {
                        ItemModel* itemModel = [[ItemModel alloc] init];
                        [itemModel parse:item];
                        [itemModels addObject:itemModel];
                    }
                    completionBlock(itemModels, nil);
                }else {
                    completionBlock(itemModels, nil);
                    
                }
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)serviceGetDeliveryDetail:(DeliveryModel*) model withCompletionBlock:(NetworkCompletionBlock)completionBlock {
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    [objects addObject:model.mKeyCode];
    [keys addObject:@"key_code"];
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString *url = sAppDomain;
    url = [url stringByAppendingString:DELIVERY_DETAIL];
    [[HttpUtils shared] makeSignedPostRequest:url withParams:params withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            
            NSDictionary* dict = (NSDictionary*) responseObject;
            if([dict objectForKey:@"data"] != nil) {
                NSDictionary* data = [dict objectForKey:@"data"];
                 NSMutableArray* labelModels = [[NSMutableArray alloc] init];
                if([data objectForKey:@"labels"]) {
             

                    NSDictionary* labels= [data objectForKey:@"labels"];
                    for(NSDictionary* label in labels) {
                        LabelModel* labelModel = [[LabelModel alloc] init];
                        [labelModel parse:label];
                        [labelModels addObject:labelModel];
                    }
                }
                completionBlock(labelModels, nil);
                
            }else {
                completionBlock(nil, @"fail");
            }
            
            
        }else {
            if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
    
}
@end
