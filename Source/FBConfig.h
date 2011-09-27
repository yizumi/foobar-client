//
//  FBConfig.h
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBConfig : NSObject
{
}

extern NSString* const K_URL_REGISTER_DEVICE_TOKEN;
extern NSString* const K_URL_GIVE_OR_REDEEM_POINTS;
extern NSString* const K_URL_GET_STORE_LIST_FOR_DEVICE;
extern NSString* const K_URL_LOGIN_STORE;
extern NSString* const K_URL_REGISTER_STORE;
extern NSString* const K_URL_GET_REDEEM_TOKEN;
extern NSString* const K_URL_MAP;

// To be used for NSUserDefaults
extern NSString* const K_DEFAULTS_TEST; // as int
extern NSString* const K_DEFAULTS_USER_TOKEN; // as NSString
extern NSString* const K_DEFAULTS_SHOP_KEY; // as long

+ (FBConfig*) sharedInstance;
- (FBConfig*) init;

@property (nonatomic) int test;
@property (nonatomic, assign) NSString* userToken;
@property (nonatomic) long shopKey;
@property (nonatomic, readonly) NSString* deviceToken;

@end
