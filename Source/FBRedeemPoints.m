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
        case 1: return @"ショップIDが無効です";
        case 2: return @"償還用トークンが無効です";
        case 3: return @"ポイントが足りません";
        case 4: return @"償還用トークンが期限切れです";
        default: return @"不明なエラーが発生しました";
    }
}

@end
