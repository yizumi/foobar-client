//
//  FBConfig.m
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBConfig.h"


@implementation FBConfig

@synthesize userLoginId;
@synthesize userLoginToken;
@synthesize storeLoginId;
@synthesize storeLoginToken;
@synthesize tokenExpireDate;

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
    [self setUserLoginToken:@"ACEGJ"];
    return self;
}

@end
