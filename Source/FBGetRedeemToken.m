//
//  FBGetRedeemToken.m
//  foobar
//
//  Created by 泉 雄介 on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBGetRedeemToken.h"
#import "FBConst.h"

@implementation FBGetRedeemToken

@synthesize deviceId;
@synthesize shopKey;

- (id)init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"GetRedeemToken"]];
    return self;
}

- (void) dealloc
{
    [shopKey release];
    [super dealloc];
}

- (void)buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:shopKey forKey:@"shopKey"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return NSLocalizedString(@"FBGetRedeemToken_DeviceNotFound",@"");
        case 2: return NSLocalizedString(@"FBGetRedeemToken_ShopNotFound",@"");
        case 3: return NSLocalizedString(@"FBGetRedeemToken_NotEnoughPoints",@"");
        case 4: return NSLocalizedString(@"FBGetRedeemToken_UnableToIssueToken",@"");
        default: return NSLocalizedString(@"FBCommandBase_UnexpectedError",@"");
    }
}

@end
