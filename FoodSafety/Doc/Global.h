#ifndef Global_h
#define Global_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Global : NSObject
+ (Global *)shared;

extern  int UPLOAD_IMAGE_WIDTH;
extern  int UPLOAD_IMAGE_HEIGHT;
extern  NSString * APP_BUNDLE_NAME;
extern  NSString * OFFLINE_DB_NAME;
extern  NSString * APP_MODE;

extern  NSString * SERVER_URL;
extern  NSString * CONTROL_DOMAIN_URL;
extern  NSString * CHECK_APP_DOMAIN;
extern  NSString * LOGIN;
extern  NSString * LOGIN_DIGIT;
extern  NSString * FORGOT_PASSWORD;
extern  NSString * TODAY_TASK;
extern  NSString * GET_PROFILE;
extern  NSString * SAVE_PROFILE;
extern  NSString * SHARE_URL;
extern  NSString * UPDATE_APNSTOKEN;

extern  NSString * GET_FRIDGE_INFO;
extern  NSString * CAPTURE_FRIDGE;
extern  NSString * DELETE_FRIDGE;
extern  NSString * CHECKLIST_CHECK;


extern  NSString * GET_FREEZE_INFO;
extern  NSString * CAPTURE_FREEZE;
extern  NSString * DELETE_FREEZE;


extern  NSString * GET_REHEATING_INFO;
extern  NSString * CAPTURE_REHEATING;
extern  NSString * DELETE_REHEATING;



extern  NSString * GET_COOLING_INFO;
extern  NSString * CAPTURE_COOLING;
extern  NSString * DELETE_COOLING;


extern  NSString * GET_SERVICE_INFO;
extern  NSString * CAPTURE_SERVICE;
extern  NSString * DELETE_SERVICE;


extern  NSString * GET_DELIVERY_INFO;
extern  NSString * CAPTURE_DELIVERY;
extern  NSString * DELIVERY_UPLOAD_LABEL;
extern  NSString * DELETE_DELIVERY;
extern  NSString * DELIVERY_DETAIL;



extern  NSString * GET_TRANSPORT_INFO;
extern  NSString * DEPARTURE_TRANSPORT;
extern  NSString * ARRIVAL_TRANSPORT;
extern  NSString * DELETE_TRANSPORT;

extern  NSString * GET_CLEANING_INFO;
extern  NSString * GET_CLEANING_ITEMS;
extern  NSString * GET_CLEANING_ITEM;
extern  NSString * CAPTURE_CLEANING;
extern  NSString * DELETE_CLEANING;

extern  NSString * GET_OIL_INFO;
extern  NSString * GET_OIL_ITEMS;
extern  NSString * GET_OIL_ITEM;
extern  NSString * CAPTURE_OIL;
extern  NSString * DELETE_OIL;

extern  NSString * GET_ITEM_INFO;
extern  NSString * GET_ITEMS;
extern  NSString * GET_ITEM;
extern  NSString * UPDATE_ITEM;
extern  NSString * CREATE_ITEM;
extern  NSString * DELETE_ITEM;

extern  NSString * GET_MENU_INFO;
extern  NSString * CREATE_MENU;
extern  NSString * MENU_DETAIL;
extern  NSString * DELETE_MENU;
extern  NSString * SEARCH_LABELS;

extern  NSString * GET_SAFETY_INFO;
extern  NSString * CREATE_SAFETY;
extern  NSString * UPDATE_SAFETY;

extern  NSString * GET_PEST_INFO;
extern  NSString * CREATE_PEST;
extern  NSString * UPDATE_PEST;

extern  NSString * GET_LABORATORY_INFO;
extern  NSString * CREATE_LABORATORY;
extern  NSString * UPDATE_LABORATORY;

extern  NSString * GET_NOTIFICATION_INFO;
extern  NSString * DELETE_NOTIFICATION;

extern  NSString * GET_SETTINGS;

extern  NSString * INTERCOM_IOS_API_KEY;
extern  NSString * INTERCOM_APP_ID;
extern  NSString * sAppDomain;

+(void)initializeApp;
+(void)showIndicator:(UIViewController*)viewcon;
+(void)stopIndicator:(UIViewController*)viewcon;
+(void)switchStoryboard:(UIViewController*)viewcon withStoryboardName: (NSString*)storyboardName;
+(void)switchScreen:(UIViewController*)viewcon withStoryboardName: (NSString*) storyboardName withControllerName: (NSString*)controllerName;
+(void)switchScreen:(UIViewController*)viewcon
 withStoryboardName: (NSString*) storyboardName
 withControllerName: (NSString*)controllerName
        withOptions:(NSDictionary*)options;
+(NSInteger)getAge:(NSDate*)birthday;
+(NSString*) getUserFriendlyTime:(long) timeInMiliseconds withTodayString:(NSString*) today withTomorrowString:(NSString*) tomorrow;
+(void)AlertMessage:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(void)AppDelegateAlertMessage:(NSString*)message Title:(NSString*)title;
+(void)ConfirmWithCompletionBlock:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title withCompletion:(void(^)(NSString* result))onComplete;
+ (void) shareApp:(UIViewController*)view withButtonView:(UIView*) button;
+(NSString *)dictToJson:(NSDictionary *)dict;
+(NSDictionary*) jsonToDict:(NSString*) json;
+(NSString *)encodeToBase64String:(UIImage *)image;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+(BOOL) isIPad;
+(NSDate *) getFirstDayOfYear;
+(NSDate *) getLastDayOfYear;

@end

#endif /* Global_h */
