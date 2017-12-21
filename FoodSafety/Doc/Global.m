//
//  Global.h
//  spotted
//
//  Created by BoHuang on 4/11/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "Global.h"
#import "UserInfo.h"
#import "Language.h"


int UPLOAD_IMAGE_WIDTH = 800;
int UPLOAD_IMAGE_HEIGHT = 600;
NSString * APP_BUNDLE_NAME = @"com.kgom.foodsafety";
NSString * OFFLINE_DB_NAME = @"foodsafety_db";
NSString * APP_MODE = @"product";

//NSString * SERVER_URL = @"http://secretsdecuisine.the-haccp-app.com";
//NSString * CONTROL_DOMAIN_URL = @"http://secretsdecuisine.the-haccp-app.com/foodsafe_controls/";
NSString * SERVER_URL = @"http://192.168.1.102:88/foodapp/";
NSString * CONTROL_DOMAIN_URL = @"https://management.the-haccp-app.com/service/check_domain";
NSString * SHARE_URL = @"";
NSString * CHECK_APP_DOMAIN = @"service/valid_domain";
NSString * LOGIN = @"authenticate/login";
NSString * FORGOT_PASSWORD = @"authenticate/forgot_password";
NSString * TODAY_TASK= @"assigns/get_info";
NSString * GET_PROFILE = @"profile/get_info";
NSString * SAVE_PROFILE = @"profile/save_info";
NSString * UPDATE_APNSTOKEN = @"profile/update_notification_token";


NSString * GET_FRIDGE_INFO = @"fridge/get_fridge_info";
NSString * CAPTURE_FRIDGE = @"fridge/capture";
NSString * DELETE_FRIDGE =  @"fridge/delete";


NSString * GET_FREEZE_INFO = @"freezer/get_freezer_info";
NSString * CAPTURE_FREEZE = @"freezer/capture";
NSString * DELETE_FREEZE = @"freezer/delete";


NSString * GET_REHEATING_INFO = @"reheating/get_reheating_info";
NSString * CAPTURE_REHEATING = @"reheating/capture";
NSString * DELETE_REHEATING = @"reheating/delete";

NSString * GET_COOLING_INFO = @"cooling/get_cooling_info";
NSString * CAPTURE_COOLING = @"cooling/capture";
NSString * DELETE_COOLING = @"cooling/delete";

NSString * GET_SERVICE_INFO = @"service/get_service_info";
NSString * CAPTURE_SERVICE = @"service/capture";
NSString * DELETE_SERVICE = @"service/delete";

NSString * GET_DELIVERY_INFO = @"delivery/get_delivery_info";
NSString * CAPTURE_DELIVERY = @"delivery/capture";
NSString * DELETE_DELIVERY = @"delivery/delete";
NSString * DELIVERY_UPLOAD_LABEL = @"delivery/uploadLabel";
NSString * DELIVERY_DETAIL = @"delivery/get_delivery_detail";

NSString * GET_TRANSPORT_INFO = @"transport/get_transport_info";
NSString * DEPARTURE_TRANSPORT = @"transport/create";
NSString * ARRIVAL_TRANSPORT = @"transport/arrival";
NSString * DELETE_TRANSPORT = @"transport/delete";

NSString * GET_CLEANING_INFO = @"cleaning/get_cleaning_info";
NSString * GET_CLEANING_ITEM = @"cleaning/get_item";
NSString * GET_CLEANING_ITEMS = @"cleaning/get_items";
NSString * CAPTURE_CLEANING = @"cleaning/capture";
NSString * DELETE_CLEANING = @"cleaning/delete";

NSString * GET_OIL_INFO = @"oil/get_oil_info";
NSString * GET_OIL_ITEMS = @"oil/get_items";
NSString * GET_OIL_ITEM = @"oil/get_item";
NSString * CAPTURE_OIL = @"oil/capture";
NSString * DELETE_OIL = @"oil/delete";

NSString * GET_ITEM_INFO = @"item/get_item_info";
NSString * GET_ITEMS = @"item/get_items";
NSString * GET_ITEM = @"item/get_item";
NSString * UPDATE_ITEM = @"item/update";
NSString * CREATE_ITEM = @"item/capture";
NSString * DELETE_ITEM = @"item/delete";

NSString * GET_MENU_INFO = @"menu/get_menu_info";
NSString * CREATE_MENU = @"menu/create";
NSString * MENU_DETAIL = @"menu/get_menu_detail";
NSString * DELETE_MENU = @"menu/delete";
NSString * SEARCH_LABELS = @"menu/search_labels";

NSString * GET_SAFETY_INFO = @"safety/get_safety_info";
NSString * CREATE_SAFETY = @"safety/create";
NSString * UPDATE_SAFETY = @"safety/update";

NSString * GET_PEST_INFO = @"pest/get_pest_info";
NSString * CREATE_PEST = @"pest/create";
NSString * UPDATE_PEST = @"pest/update";

NSString * GET_LABORATORY_INFO = @"laboratory/get_laboratory_info";
NSString * CREATE_LABORATORY = @"laboratory/create";
NSString * UPDATE_LABORATORY = @"laboratory/update";

NSString * GET_NOTIFICATION_INFO = @"notification/get_notification_info";
NSString * DELETE_NOTIFICATION = @"notification/delete";

NSString * GET_SETTINGS = @"setting/get_dateformat";

NSString * INTERCOM_IOS_API_KEY =@"ios_sdk-a8c8bda3bd0352ea4d26f27b1bbd13c6495c0a47";
NSString * INTERCOM_APP_ID= @"y0vbs0e9";

NSString * sAppDomain;

@implementation Global

+ (Global *)shared
{
    static dispatch_once_t onceToken;
    static Global *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];
    });
    return instance;
}

+(void) initializeApp {
    [Intercom setApiKey:INTERCOM_IOS_API_KEY forAppId:INTERCOM_APP_ID];
    [Intercom setLauncherVisible:YES];

    NSString* domain = [[UserInfo shared] getDomain];
    if(domain == nil || [domain isEqualToString:@""])
        sAppDomain =@"";
    else{
        sAppDomain = @"";
        sAppDomain = [[[[sAppDomain stringByAppendingString:@"https://"]  stringByAppendingString:domain ] stringByAppendingString:@".the-haccp-app.com" ] stringByAppendingString:@"/index.php/api/"];
    }
    
    if([APP_MODE isEqualToString: @"local_development"]) {
        sAppDomain = @"http://192.168.1.102:88/foodapp/index.php/api/";
    }
    

}

+(void)showIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    
    if(view == nil){
        CGFloat width = 60.0;
        CGFloat height = 60.0;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [indicatorView setColor:[UIColor blackColor]];
        indicatorView.center = viewcon.view.center;
        indicatorView.tag = 1000;
        [viewcon.view addSubview:indicatorView];
        [viewcon.view bringSubviewToFront:indicatorView];
        view = indicatorView;
    }
    
    view.hidden = false;
    [view startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}
+(void)stopIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    if(view != nil){
        view.hidden = YES;
        [view stopAnimating];
        
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+(void)switchStoryboard:(UIViewController*)viewcon withStoryboardName: (NSString*)storyboardName{
    NSString*  sbName = storyboardName;
    if([Global isIPad] && [storyboardName isEqualToString:@"Main"]) {
         sbName = @"MainiPad";
    }
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName: sbName bundle:nil];
    UIViewController* vc = [mainStoryboard instantiateInitialViewController];
    [viewcon.navigationController pushViewController:vc animated:YES];
}

+(void)switchScreen:(UIViewController*)viewcon withStoryboardName: (NSString*) storyboardName
 withControllerName: (NSString*)controllerName{
    NSString*  sbName = storyboardName;
    if([Global isIPad] && [storyboardName isEqualToString:@"Main"]) {
        sbName = @"MainiPad";
    }
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName: sbName bundle:nil];
    UIViewController* vc = [mainStoryboard instantiateViewControllerWithIdentifier:controllerName];
    [viewcon.navigationController pushViewController:vc animated:YES];
}

+(NSInteger)getAge:(NSDate*)birthday{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    return age;
}
+(NSString*)getDate:(NSDate*)date withFormat:(NSString*) format{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:format]; // Date formater
    NSString *dateStr = [dateformate stringFromDate:date]; // Convert date to string
    return dateStr;
}

+(NSString*) getUserFriendlyTime:(long) timeInMiliseconds withTodayString:(NSString*) today withTomorrowString:(NSString*) tomorrow{
    NSString* userFriendlyString = @"";
    NSDate* now = [NSDate date];
    NSDate* date = [[NSDate alloc]initWithTimeIntervalSince1970:timeInMiliseconds];
    
    NSCalendar *greg    = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger currentDay= [greg ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    
    NSUInteger estimateDay= [greg ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    if(currentDay == estimateDay){
        userFriendlyString =  [[[userFriendlyString stringByAppendingString:today] stringByAppendingString:@" "] stringByAppendingString:[Global getDate:date withFormat:@"hh:mm"]];
    }else if(currentDay + 1 == estimateDay){
        userFriendlyString =  [[[userFriendlyString stringByAppendingString:tomorrow] stringByAppendingString:@" "] stringByAppendingString:[Global getDate:date withFormat:@"hh:mm"]];
    }else{
        userFriendlyString = [Global getDate:date withFormat:@"EEE d MMM yyyy hh:mm"];
    }
    return userFriendlyString;
    
}

+(void)AlertMessage:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    
    [alert addAction:okButton];
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)ConfirmWithCompletionBlock:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title withCompletion:(void(^)(NSString* result))onComplete{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   onComplete(@"Ok");
                                   
                               }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                                   onComplete(@"Cancel");
                                   
                               }];
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)AppDelegateAlertMessage:(NSString*)message Title:(NSString*)title {
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        topWindow.hidden = YES;
    }]];

    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}


+ (void) shareApp:(UIViewController*)view withButtonView:(UIView*) button{
    NSString *textToShare = @"Spotted! Awesome photographing game.";
    NSURL *myWebsite = [NSURL URLWithString:SHARE_URL];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook,                                   UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = button;

    }
    [view presentViewController:activityVC animated:YES completion:nil];
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



+(NSString *)dictToJson:(NSDictionary *)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return  [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

+(NSDictionary*) jsonToDict:(NSString*) json {
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    //    Note that JSONObjectWithData will return either an NSDictionary or an NSArray, depending whether your JSON string represents an a dictionary or an array.
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
    }
    else
    {
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *jsonArray = (NSArray *)jsonObject;
            return (NSDictionary*) jsonArray;
        }
        else {
            NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
            return jsonDictionary;
        }
    }
    return nil;
}

+(NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
+(BOOL)isIPad {
    return [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"];
}

+(NSDate *) getFirstDayOfYear{
    //Get current year
    NSDate *currentYear=[[NSDate alloc]init];
    currentYear=[NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSString *currentYearString = [formatter1 stringFromDate:currentYear];
    
    //Get first date of current year
    NSString *firstDateString=[NSString stringWithFormat:@"01-01-%@",currentYearString];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"dd-MM-yyyy"];
    NSDate *firstDate = [[NSDate alloc]init];
    firstDate = [formatter2 dateFromString:firstDateString];
    return firstDate;
}
+(NSDate *) getLastDayOfYear{
    //Get current year	
    NSDate *currentYear=[[NSDate alloc]init];
    currentYear=[NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSString *currentYearString = [formatter1 stringFromDate:currentYear];
    
    //Get first date of current year
    NSString *lastDateString=[NSString stringWithFormat:@"31-12-%@",currentYearString];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"dd-MM-yyyy"];
    NSDate *lastDate = [[NSDate alloc]init];
    lastDate = [formatter2 dateFromString:lastDateString];
    return lastDate;
}
@end
