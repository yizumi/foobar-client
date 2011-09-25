//
//  FBStoreExt.m
//  foobar
//
//  Created by 泉 雄介 on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBStoreExt.h"


@implementation FBStore (FBStoreExt)

- (NSString*) sectionName
{
    return [self.name substringToIndex:1];
}

@end
