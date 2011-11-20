//
//  FBCancelTransaction.m
//  foobar
//
//  Created by 泉 雄介 on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBCancelTransaction.h"
#import "FBConst.h"

@implementation FBCancelTransaction

@synthesize transactionKey;

- (id)init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"CancelTransaction"]];
    return self;
}

- (void) dealloc
{
    [transactionKey release];
    [super dealloc];
}

- (void) buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:transactionKey forKey:@"transactionKey"];
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return NSLocalizedString(@"FBCancelTransaction_KeyNotFound",@"");
        case 2: return NSLocalizedString(@"FBCancelTransaction_AlreadyCancelled",@"");
        case 3: return NSLocalizedString(@"FBCancelTransaction_UserNotFound",@"");
        case 4: return NSLocalizedString(@"FBCancelTransaction_PositionNotFound",@"");
        default: return NSLocalizedString(@"FBCommandBase_UnexpectedError",@"");
    }
}

@end
