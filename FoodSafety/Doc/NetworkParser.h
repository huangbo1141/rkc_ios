//
//  NetworkParser.h
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LogModel.h"
#import "ItemModel.h"
#import "UserModel.h"
#import "DeliveryModel.h"
#import "TransportModel.h"
#import "DeliveryMenuModel.h"
#import "LaboratoryModel.h"

typedef void (^NetworkCompletionBlock)(id responseObject, NSString* error);
@interface NetworkParser : NSObject
+ (instancetype)shared;

- (void)serviceCheckSubdomain:(NSString*)subdomain withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceLogin:(NSString*)username withPassword:(NSString*)password withMode:(int)mode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceForgotPassword:(NSString*)email withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceTodayTask:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetProfile:(NSString*) token withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceSaveProfile:(UserModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetSettings:(NetworkCompletionBlock)completionBlock;
- (void)serviceUpdateAPNSToken:(NSString*) apnsToken withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetFridgeInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteFridge:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureFridge:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetFreezerInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteFreezer:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureFreezer:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void) serviceGetItemForKeyCode:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void) serviceGetItemInfo:(NSDictionary*) conditions withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void) serviceCreateItem:(ItemModel*) model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void) serviceUpdateItem:(ItemModel*) model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void) serviceDeleteItem:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;


- (void)serviceGetReheatingInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteReheating:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureReheating:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetCoolingInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteCooling:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureCooling:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetServiceInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteService:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureService:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetDeliveryInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteDelivery:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureDelivery:(DeliveryModel*)model withAction: (NSString*)action withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeliveryUploadLabel:(UIImage*) image withKeyCode:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetDeliveryDetail:(DeliveryModel*) model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetTransportInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteTransport:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceTransportDeparture:(TransportModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceTransportArrival:(TransportModel*)model withAction:(NSString*) action withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetCleaningInfo:(NSString*) startDate withEndDate:(NSString*) endDate withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetCleaningItem:(NSString*) itemId withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceDeleteCleaning:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureCleaning:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetCleaningItems:(NSString*) key withAreaId:(NSString*) areaId withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetOilInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetOilItem:(NSString*) itemId withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetOilItems:(NSString*) key withAreaId:(NSString*) areaId withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceDeleteOil:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceCaptureOil:(LogModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetMenuInfo:(NetworkCompletionBlock)completionBlock;

- (void)serviceCreateMenu:(DeliveryMenuModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetMenuDetail:(DeliveryMenuModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteMenu:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceSearchLabels:(NSDictionary*) conditions withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetNotification:(NetworkCompletionBlock)completionBlock;
- (void)serviceDeleteNotification:(NSString*) keyCode withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetSafetyInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceCreateSafety:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock ;
- (void)serviceUpdateSafety:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetLaboratoryInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceCreateLaboratory:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock ;
- (void)serviceUpdateLaboratory:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;
- (void)serviceGetPestInfo:(NetworkCompletionBlock)completionBlock;
- (void)serviceCreatePest:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock ;
- (void)serviceUpdatePest:(LaboratoryModel*)model withCompletionBlock:(NetworkCompletionBlock)completionBlock;

- (void)serviceGetItems:(NSString*) key withCompletionBlock:(NetworkCompletionBlock)completionBlock;

@end
