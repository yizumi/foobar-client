//
//  FBCreateShop.m
//  foobar
//
//  Created by 泉 雄介 on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBCreateShop.h"
#import "FBConst.h"

@implementation FBCreateShop

@synthesize name;
@synthesize address;
@synthesize tel;
@synthesize url;
@synthesize image;
@synthesize email;
@synthesize password;
@synthesize preferredLang;

- (id)init
{
    self = [super initWithUrl:[NSString stringWithFormat:K_BASE_FOOBAR_URL, @"CreateShop"]];
    return self;
}

- (void) dealloc
{
    [name release];
    [address release];
    [tel release];
    [url release];
    [image release];
    [email release];
    [password release];
    [preferredLang release];
    [super dealloc];
}

- (void)buildRequest:(ASIFormDataRequest *)request
{
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:tel forKey:@"tel"];
    [request setPostValue:url forKey:@"url"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:preferredLang forKey:@"preferredLang"];

    if (image != nil)
    {
        [request setData:image withFileName:@"shop.jpg" andContentType:@"image/jpg" forKey:@"image"];
    }
}

- (NSString*) localizedDescription:(int)failCode
{
    switch (failCode)
    {
        case 1: return NSLocalizedString(@"FBCreateShop_MailAddressInUser",@"");
        case 2: return NSLocalizedString(@"FBCreateShop_MissingRequiredFields",@"");
        default: return NSLocalizedString(@"FBCommandBase_UnexpectedError",@"");
    }
}

@end
