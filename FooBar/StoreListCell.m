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

- (void)dealloc
{
    [_titleLabel release];
    [_pointLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

@end
