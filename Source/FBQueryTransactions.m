//
//  FBQueryTransactions.m
//  foobar
//
//  Created by 泉 雄介 on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBQueryTransactions.h"
#import "FBConst.h"

@implementation FBQueryTransactions

@synthesize count;
@synthesize page;
@synthesize shopKey;
@synthesize userToken;

- (id) init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL,
                               @"QueryTransactions"]];
    if (self != nil)
    {
        
    }
    return self;
}

- (void) dealloc
{
    [count release];
    [page release];
    [shopKey release];
    [userToken release];
    
    [super dealloc];
}

- (void)buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:count forKey:@"count"];
    [request setPostValue:page forKey:@"page"];
    [request setPostValue:shopKey forKey:@"shopKey"];
    [request setPostValue:userToken forKey:@"userToken"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return @"クエリーに必要なパラメータが足りません";
        case 2: return @"ユーザIDが不明です";
        case 3: return @"ショップIDが不明です";
        default: return @"不明なエラーが発生しました";
    }
}


@end
