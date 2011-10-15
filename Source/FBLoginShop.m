//
//  FBLoginShop.m
//  foobar
//
//  Created by 泉 雄介 on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBLoginShop.h"
#import "FBConst.h"
#import "ASIFormDataRequest.h"

@implementation FBLoginShop

@synthesize email;
@synthesize password;

- (id) init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"LoginShop"]];
    return self;
}

- (void) dealloc
{
    [email release];
    [password release];
    [super dealloc];
}

- (void) buildRequest:(ASIFormDataRequest*) request
{
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return @"メールアドレスが間違えています";
        case 2: return @"パスワードが間違えています";
        default: return @"不明なエラーが発生しました";
    }
}
@end
