//
//  APCArray.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (NSArray_APC)

-(void) forEach:(void(^)(id))handler;

@end
