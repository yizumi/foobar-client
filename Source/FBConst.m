//
//  FBConst.m
//  foobar
//
//  Created by 泉 雄介 on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBConst.h"


@implementation FBConst

#if DEBUG
NSString* const K_BASE_FOOBAR_URL               = @"http://localhost:8888/foobar/%@";
NSString* const K_URL_MAP                       = @"http://maps.google.com/maps?q=%@&ie=UTF8";
NSString* const K_SHOP_IMAGE_URL                = @"http://localhost:8888/foobar/GetShopImage?shopKey=%d&filter=100x100";
#else
NSString* const K_BASE_FOOBAR_URL               = @"https://ripsys01.appspot.com/foobar/%@";
NSString* const K_URL_MAP                       = @"https://maps.google.com/maps?q=%@&ie=UTF8";
NSString* const K_SHOP_IMAGE_URL                = @"https://ripsys01.appspot.com/foobar/GetShopImage?shopKey=%d&filter=100x100";
#endif

@end
