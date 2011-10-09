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

// To be used for NSUserDefaults
extern NSString* const K_DEFAULTS_TEST; // as int
extern NSString* const K_DEFAULTS_USER_TOKEN; // as NSString
extern NSString* const K_DEFAULTS_SHOP_KEY; // as long
extern NSString* const K_DEFAULTS_REFRESH_SHOP_LIST; // as boolean
+ (FBConfig*) sharedInstance;
- (FBConfig*) init;

@property (nonatomic) int test;
@property (nonatomic, assign) NSString* userToken;
@property (nonatomic) long shopKey;
@property (nonatomic, readonly) NSString* deviceToken;
@property (nonatomic) BOOL refreshShopList;

@end
