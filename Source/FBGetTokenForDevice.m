//
//  FBGetTokenForDevice.m
//  foobar
//
//  Created by 泉 雄介 on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBGetTokenForDevice.h"
#import "FBConst.h"

@implementation FBGetTokenForDevice

@synthesize deviceToken;

- (id) init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"GetTokenForDevice"]];
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) buildRequest:(ASIFormDataRequest*) request
{
    [request setPostValue:deviceToken forKey:@"deviceToken"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return NSLocalizedString(@"FBGetTokenForDevice_DeviceNotFound",@"");
        default: return NSLocalizedString(@"FBCommandBase_UnexpectedError",@"");
    }
}

@end
