//
//  FBRedeemPoints.m
//  foobar
//
//  Created by 泉 雄介 on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBRedeemPoints.h"
#import "FBConst.h"

@implementation FBRedeemPoints

@synthesize shopKey;
@synthesize redeemToken;
@synthesize points;

- (id) init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"RedeemPoints"]];
    return self;
}

- (void) buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:shopKey forKey:@"shopKey"];
    [request setPostValue:redeemToken forKey:@"redeemToken"];
    [request setPostValue:points forKey:@"points"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return NSLocalizedString(@"FBRedeemPoints_InvalidShopId",@"");
        case 2: return NSLocalizedString(@"FBRedeemPoints_InvalidRedemptionCode",@"");
        case 3: return NSLocalizedString(@"FBRedeemPoints_NotEnoughPoints",@"");
        case 4: return NSLocalizedString(@"FBRedeemPoints_ExpiredRedemptionCode",@"");
        default: return NSLocalizedString(@"FBCommandBase_UnexpectedError",@"");
    }
}

@end
