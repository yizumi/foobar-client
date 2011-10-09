//
//  FBConfig.m
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBConfig.h"

@implementation FBConfig

NSString* const K_DEFAULTS_TEST                     = @"test";
NSString* const K_DEFAULTS_SHOP_KEY                 = @"shopKey";
NSString* const K_DEFAULTS_SHOP_NAME                = @"shopName";
NSString* const K_DEFAULTS_USER_TOKEN               = @"userToken";
NSString* const K_DEFAULTS_REFRESH_SHOP_LIST        = @"refreshShopList";

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

- (BOOL) refreshShopList
{
    NSNumber* number = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:K_DEFAULTS_REFRESH_SHOP_LIST];
    return [number boolValue];
}

- (void) setRefreshShopList:(BOOL)value
{
    NSNumber* number = [NSNumber numberWithBool:value];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:K_DEFAULTS_REFRESH_SHOP_LIST];
}

@end
