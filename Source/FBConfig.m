//
//  FBConfig.m
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBConfig.h"


@implementation FBConfig

#if DEBUG
NSString* const K_URL_REGISTER_DEVICE_TOKEN     = @"http://localhost:8888/foobar/GetTokenForDevice";
NSString* const K_URL_GIVE_OR_REDEEM_POINTS     = @"http://localhost:8888/foobar/AddPoints";
NSString* const K_URL_GET_STORE_LIST_FOR_DEVICE = @"http://localhost:8888/foobar/GetShopListForDevice";
NSString* const K_URL_LOGIN_STORE               = @"http://localhost:8888/foobar/LoginShop";
NSString* const K_URL_REGISTER_STORE            = @"http://localhost:8888/foobar/CreateShop";
NSString* const K_URL_GET_REDEEM_TOKEN          = @"http://localhost:8888/foobar/GetRedeemToken";
NSString* const K_URL_MAP                       = @"http://maps.google.com/maps?q=%@&ie=UTF8";
#else
NSString* const K_URL_REGISTER_DEVICE_TOKEN     = @"https://ripsys01.appspot.com/foobar/GetTokenForDevice";
NSString* const K_URL_GIVE_OR_REDEEM_POINTS     = @"https://ripsys01.appspot.com/foobar/AddPoints";
NSString* const K_URL_GET_STORE_LIST_FOR_DEVICE = @"https://ripsys01.appspot.com/foobar/GetShopListForDevice";
NSString* const K_URL_LOGIN_STORE               = @"https://ripsys01.appspot.com/foobar/LoginShop";
NSString* const K_URL_REGISTER_STORE            = @"https://ripsys01.appspot.com/foobar/CreateShop";
NSString* const K_URL_GET_REDEEM_TOKEN          = @"https://ripsys01.appspot.com/foobar/GetRedeemToken";
NSString* const K_URL_MAP                       = @"http://maps.google.com/maps?q=%@&ie=UTF8";
#endif

@synthesize userLoginId;
@synthesize userLoginToken;
@synthesize storeLoginId;
@synthesize storeLoginToken;
@synthesize tokenExpireDate;
@synthesize deviceId;

static FBConfig* _sharedInstance;

+ (FBConfig *)sharedInstance
{
    if( _sharedInstance == nil )
    {
        _sharedInstance = [[FBConfig alloc] init];
    }
    return _sharedInstance;
}

- (void) dealloc
{
    [userLoginId release];
    [userLoginToken release];
    [storeLoginId release];
    [storeLoginToken release];
    [tokenExpireDate release];
    [super dealloc];
}

- (FBConfig *) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // Initialize
    [self setUserLoginId:@"yizumi@ripplesystem.com"];
    [self setUserLoginToken:@""];
    [self setDeviceId:[[UIDevice currentDevice]uniqueIdentifier]];
    return self;
}

@end
