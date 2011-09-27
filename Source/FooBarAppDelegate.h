//
//  FooBarAppDelegate.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"

@interface FooBarAppDelegate : NSObject <UIApplicationDelegate,
UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedController;

- (void)getTokenForDevice:(NSString*)deviceToken;

@end
