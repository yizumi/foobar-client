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
        case 1: return @"デバイスが見つかりません";
        case 2: return @"ショップが見つかりません";
        case 3: return @"ポイント残高がありません";
        case 4: return @"トークンの払い出しに失敗しました";
        default: return @"不明なエラーが発生しました";
    }
}

@end
