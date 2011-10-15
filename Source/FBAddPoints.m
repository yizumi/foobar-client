//
//  FBAddPoints.m
//  foobar
//
//  Created by 泉 雄介 on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBAddPoints.h"
#import "FBConst.h"

@implementation FBAddPoints

@synthesize userToken;
@synthesize shopKey;
@synthesize points;

- (id)init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"AddPoints"]];
    return self;
}

- (void) dealloc
{
    [userToken release];
    [shopKey release];
    [points release];
    [super dealloc];
}

- (void)buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:userToken forKey:@"userToken"];
    [request setPostValue:shopKey forKey:@"shopKey"];
    [request setPostValue:points forKey:@"points"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 10: return @"ユーザが見つかりません";
        case 20: return @"ショップが見つかりません";
        case 30: return @"ユーザのポイントが上限に達しています";
        case 40: return @"ショップの付与可能ポイントが上限に達しています";
        default: return @"不明なエラーが発生しました";
    }
}


@end
