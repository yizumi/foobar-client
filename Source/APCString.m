//
//  APCString.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCString.h"


@implementation NSString (NSString_APC)

// Returns the index of the first appearance of the given character.
// Returns -1 if not found.
-(int) indexOf:(char)chr
{
    for( int i = 0; i < [self length]; i++ )
    {
        if([self characterAtIndex:i] == chr)
            return i;
    }
    return -1;
}

-(NSString*) sort
{
    unichar chrs[[self length]];
    [self getCharacters:chrs];
    qsort((void*)chrs, [self length], sizeof(chrs[0]), chr_sort);
    return [NSString stringWithCharacters:chrs length:[self length]];
}

int chr_sort( const void * a , const void * b )
{
    /* 引数はvoid*型と規定されているのでint型にcastする */
    if( *( unichar * )a < *( unichar * )b ) {
        return -1;
    }
    else
        if( *( unichar * )a == *( unichar * )b ) {
            return 0;
        }
    return 1;
}

// helper function: get the url encoded string form of any object
- (NSString*)urlEncode
{
    return [self stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


@end
