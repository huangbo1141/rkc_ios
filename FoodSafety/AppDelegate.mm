//
//  AppDelegate.m
//  FoodSafety
//
//  Created by BoHuang on 8/12/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkParser.h"
#import "IQKeyboardManager.h"
#import "Global.h"
#import "UserInfo.h"
#import "Language.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //push setting
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
    // Override point for customization after application launch.
    [Global initializeApp];
    [Fabric with:@[[Crashlytics class]]];
    
    [self initializeStoryBoardBasedOnScreenSize];
    return YES;
}

-(void)initializeStoryBoardBasedOnScreenSize {
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    NSLog(@"IOS Device Screen SIze : %f",iOSDeviceScreenSize.height);
    NSLog(@"IS Ipad? : %d", [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] );

    
    if (![(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"]){    // The iOS device = iPhone or iPod Touch
            UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhoneStoryboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];

        
    }
    else{   // The iOS device = iPad
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"MainiPad" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPadStoryboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
        
    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if ( application.applicationState == UIApplicationStateActive ){

        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        [Global AppDelegateAlertMessage:message Title:@"Notification"];
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);

    
    UserInfo *env = [UserInfo shared];
    
    env.mApnsToken = newToken;
    if(env.mAccount.mToken != nil && ![env.mAccount.mToken isEqualToString:@""]){
        [[NetworkParser shared] serviceUpdateAPNSToken:newToken withCompletionBlock:nil];
    }
    
    
    [Intercom setDeviceToken:deviceToken];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application registerUserNotificationSettings:
     [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                       categories:nil]];
    [application registerForRemoteNotifications];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
