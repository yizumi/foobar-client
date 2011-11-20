//
//  FBGetShopListForDevice.m
//  foobar
//
//  Created by 泉 雄介 on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBGetShopListForDevice.h"
#import "FBConst.h"

@implementation FBGetShopListForDevice

@synthesize deviceId;

- (id) init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"GetShopListForDevice"]];
    return self;
}

- (void) buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:deviceId forKey:@"deviceId"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return NSLocalizedString(@"FBGetShopListForDevice_DeviceNotFound",@"");
        default: return NSLocalizedString(@"FBCommandBase_UnexpectedError",@"");
    }
}

@end
