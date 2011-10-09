//
//  FooBarAppDelegate.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FooBarAppDelegate.h"
#import "FBConfig.h"
#import "FBGetTokenForDevice.h"

@implementation FooBarAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize segmentedController=_segmentedController;

+ (void)initialize
{
    if ([self class] == [FooBarAppDelegate class])
    {
        // UIApplication* myApp = [UIApplication sharedApplication];
        if ([[FBConfig sharedInstance] test] == 0)
        {
            [[FBConfig sharedInstance] setTest:1];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    int num = [[FBConfig sharedInstance] test];
    NSLog( @"Current Test Value: %d", num);
    [[FBConfig sharedInstance] setTest:num+1];
    [[FBConfig sharedInstance] setRefreshShopList:YES];
    
    // Ask APNS to provide the app with device token.
    // This will invoke application:didRegisterForRemoteNotificationsWithDeviceToken
    [[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];

    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_segmentedController release];
    [super dealloc];
}

/****** DeviceToken handler ******/
- (void)application:application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Parse the received deviceToken
    NSString* deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    NSString* deviceTokenFmt = [deviceTokenString substringWithRange:NSMakeRange(1,[deviceTokenString length]-2)];
    [self getTokenForDevice:deviceTokenFmt];
}

- (void)application:application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Result"
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:nil 
                                         otherButtonTitles:@"OK", nil];
    [alert show];
    [alert autorelease];
    
    [self getTokenForDevice:nil];
}

- (void)getTokenForDevice:(NSString*)deviceToken
{    
    // Get the unique identifier of the device
    FBGetTokenForDevice* cmd = [[[FBGetTokenForDevice alloc] init] autorelease];
    [cmd setDelegate:self];
    [cmd execAsync];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    NSString *badge;
    NSString *sound;
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL)
    {
        alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]; 
    }
    else
    {
        alertMsg = @"{no alert message in dictionary}";
    }
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"badge"] != NULL)
    {
        badge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"]; 
    }
    else
    {
        badge = @"{no badge number in dictionary}";
    }
    
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"sound"] != NULL)
    {
        sound = [[userInfo objectForKey:@"aps"] objectForKey:@"sound"]; 
    }
    else
    {
        sound = @"{no sound in dictionary}";
    }
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate); 
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FooBar"
                                                    message:alertMsg 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

// ================================= FBCommandBaseDelegate ================================

- (void) execSuccess:(id)request withResponse:(id)response
{
    if ([[response objectForKey:@"success"] boolValue] == YES)
    {
        NSString* userToken = [response objectForKey:@"token"];
        [[FBConfig sharedInstance] setUserToken:userToken];
        NSLog(@"Setting user token as: %@", userToken);
    }
    else
    {
        int failCode = [[response objectForKey:@"failCode"] intValue];
        NSString* errorMessage = @"Unknown Error";
        switch (failCode)
        {
            case 1: // FAILCODE_MISSING_DEVICE_ID
                errorMessage = @"Missing DeviceID";
                break;
        }
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:errorMessage
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"OK", nil];
        [alert show];
        [alert autorelease];
        NSLog(@"GetTokenForDevice Failed (Code:%@)", failCode);
    }

}

@end
