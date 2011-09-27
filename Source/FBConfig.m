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

NSString* const K_DEFAULTS_USER_TOKEN           = @"userToken";
NSString* const K_DEFAULTS_SHOP_KEY             = @"shopKey";
NSString* const K_DEFAULTS_TEST                 = @"test";

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
    [super dealloc];
}

- (FBConfig *) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // Initialize
    return self;
}

- (NSString*) deviceToken
{
    return [[UIDevice currentDevice]uniqueIdentifier];
}

- (NSString*) userToken
{
    NSString* value = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:K_DEFAULTS_USER_TOKEN];
    if (value == nil)
        return @"";
    return value;
}

- (void) setUserToken:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:K_DEFAULTS_USER_TOKEN];
}

- (long) shopKey
{
    NSNumber* number = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:K_DEFAULTS_SHOP_KEY];
    return [number longValue];
}

- (void) setShopKey:(long)value
{
    NSNumber* number = [NSNumber numberWithLong:value];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:K_DEFAULTS_SHOP_KEY];
}

- (int) test
{
    NSNumber* number = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:K_DEFAULTS_TEST];
    return [number intValue];
}

- (void) setTest:(int)value
{
    NSNumber* number = [NSNumber numberWithInt:value];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:K_DEFAULTS_TEST];
}

@end
