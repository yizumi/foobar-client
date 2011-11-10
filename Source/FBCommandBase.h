//
//  FBCommandBase.h
//  foobar
//
//  Created by 泉 雄介 on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@class FBCommandBase;
@protocol FBCommandBaseDelegate <NSObject>
@required
- (void)execSuccess:(id)request withResponse:(id)response;
@optional
- (BOOL)execFailed:(id)request withFailCode:(int)failCode;
@optional
- (BOOL)execError:(id)request withError:(NSError*)error;
@end

@interface FBCommandBase : NSObject
{
}

@property (nonatomic, retain) NSString* commandUrl;
@property (nonatomic, assign) id <FBCommandBaseDelegate> delegate;
@property (nonatomic, assign) id userObj;

- (id) initWithUrl:(NSString*) url;
- (void) buildRequest:(ASIFormDataRequest*) request;
- (void) execAsync;
- (NSString*) localizedDescription:(int)failCode;
- (void)execFailed:(int)failCode;
- (void)execError:(NSError*)error;
@end
