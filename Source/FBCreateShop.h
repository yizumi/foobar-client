//
//  FBCreateShop.h
//  foobar
//
//  Created by 泉 雄介 on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCommandBase.h"

@interface FBCreateShop : FBCommandBase {
    
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* tel;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSData* image;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* preferredLang;

- (id) init;
// - (void) buildRequest:(NSObject*) request;

@end
