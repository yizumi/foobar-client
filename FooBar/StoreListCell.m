//
//  StoreListCell.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreListCell.h"


@implementation StoreListCell

@synthesize titleLabel = _titleLabel;
@synthesize pointLabel = _pointLabel;
@synthesize storeInfo = _storeInfo;

- (void)dealloc
{
    [_titleLabel release];
    [_pointLabel release];
    [_storeInfo release];
    [super dealloc];
}

- (void)setStoreInfo:(FBStore *)storeInfo
{
    if( _storeInfo != nil )
    {
        // Stop Observing
    }
    [storeInfo retain];
    [_storeInfo release];
    _storeInfo = storeInfo;
}

#pragma mark - View lifecycle

@end
