//
//  APCString.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_APC)

// Returns the index of the first appearance of the given character.
// Returns -1 if not found.
-(int) indexOf:(char)chr;
-(NSString*) sort;
-(NSString*) urlEncode;
/* ソート関数 */
int chr_sort( const void * a , const void * b );

@end
