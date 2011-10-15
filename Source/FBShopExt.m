//
//  FBShopExt.m
//  foobar
//
//  Created by 泉 雄介 on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBShopExt.h"

@implementation FBShop (FBShopExt)

- (NSString*) sectionName
{
    return [self.name substringToIndex:1];
}

@end
