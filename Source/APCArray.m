//
//  APCArray.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCArray.h"


@implementation NSArray (NSArray_APC)

// Runs the given function against all items in the collection 
-(void) forEach:(void(^)(id))handler
{
    for( int i = 0; i < [self count]; i++ )
    {
        handler([self objectAtIndex:i]);
    }
}

@end
