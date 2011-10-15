//
//  FBLoginShop.h
//  foobar
//
//  Created by 泉 雄介 on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCommandBase.h"

@interface FBLoginShop : FBCommandBase
{
}

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;

- (id) init;
// - (void) buildRequest:(NSObject*) request;

@end
