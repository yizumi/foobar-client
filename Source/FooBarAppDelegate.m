//
//  FooBarAppDelegate.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FooBarAppDelegate.h"

@implementation FooBarAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize segmentedController=_segmentedController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    // Get the device token
    NSString* deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    NSString* deviceTokenFmt = [deviceTokenString substringWithRange:NSMakeRange(1,[deviceTokenString length]-2)];
    
    // Get the unique identifier of the device
    NSString* deviceId = [[UIDevice currentDevice]uniqueIdentifier];
    
    // Log
    NSLog(@"Sending {DeviceId:%@, DeviceToken:%@}", deviceId, deviceTokenFmt);
    
    // Create URL, Request and Send the Request
    NSURL* url = [NSURL URLWithString:K_URL_REGISTER_DEVICE_TOKEN];
    __block ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:url];
    [req setPostValue:deviceId forKey:@"deviceId"];
    [req setPostValue:deviceTokenFmt forKey:@"deviceToken"];
    [req setCompletionBlock:^(void){
        NSString* responseString = [req responseString];
        NSDictionary* obj = [responseString JSONValue];
        NSString* userToken = [obj objectForKey:@"userToken"];
        [[FBConfig sharedInstance] setValue:userToken forKey:@"userLoginToken"];
        NSLog(@"Setting user token as: %@", userToken);
    }];
    [req setFailedBlock:^(void){
        NSError* error = [req error];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:[error localizedDescription]
                                                      delegate:nil
                                             cancelButtonTitle:nil 
                                             otherButtonTitles:@"OK", nil];
        [alert show];
        [alert autorelease];
        NSLog(@"Error while getting user token from server:%@",error);
    }];

    // Send the Request
#if DEBUG
    [req setValidatesSecureCertificate:NO];
#endif
    [req startAsynchronous];
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
