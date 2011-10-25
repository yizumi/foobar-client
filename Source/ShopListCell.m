//
//  ShopListCell.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopListCell.h"


@implementation ShopListCell

@synthesize titleLabel = _titleLabel;
@synthesize pointLabel = _pointLabel;
@synthesize shopInfo = _shopInfo;

- (void)dealloc
{
    [_titleLabel release];
    [_pointLabel release];
    [_shopInfo release];
    [super dealloc];
}

- (void)setShopInfo:(ShopInfo *)shopInfo
{
    if( _shopInfo != nil )
    {
        // Stop Observing
    }
    [shopInfo retain];
    [_shopInfo release];
    _shopInfo = shopInfo;
}

#pragma mark - View lifecycle

@end
