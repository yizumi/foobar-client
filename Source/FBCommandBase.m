//
//  FBCommandBase.m
//  foobar
//
//  Created by 泉 雄介 on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBCommandBase.h"
#import "NSObject+SBJson.h"
#import "APCWindow.h"

@implementation FBCommandBase

@synthesize commandUrl;
@synthesize delegate;

- (id) initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setCommandUrl:url];
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"FBCommandBase is being deallocated");
    [commandUrl release];
    // [delegate release]; big mistake!!
    [super dealloc];
}

- (void) buildRequest:(ASIFormDataRequest*)request
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (NSString*) localizedDescription:(int)failCode
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (void) execAsync
{
    NSURL* url = [NSURL URLWithString:[self commandUrl]];
    NSString* deviceId = [[UIDevice currentDevice]uniqueIdentifier];
    
    __block ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:url];
    // deviceId is a special request parameter
    [req setPostValue:deviceId forKey:@"deviceId"];

    // call buildRequest
    [self buildRequest:req];
    
    // Set the method to invoke up on successful completion
    [req setCompletionBlock:^(void){
        NSString* resStr = [req responseString];
        NSLog(@"Response: %@", resStr);
        id response = [resStr JSONValue];
        if (response != nil)
        {
            NSNumber* successCode = (NSNumber*)[response objectForKey:@"success"];
            if (successCode == nil)
            {
                [self execFailed:0];
                return;
            }
            
            if ([successCode boolValue] == NO)
            {
                NSNumber* failCode = (NSNumber*)[response objectForKey:@"failCode"];
                [self execFailed:[failCode intValue]];
                return;
            }
            
            [delegate execSuccess:self withResponse:response];
            return;
        }
    }];
    
    // Invoked up on failure
    [req setFailedBlock:^(void) {

        NSError* error = [req error];
        [self execError:error];
    }];
    
    // Send the request
#if DEBUG
    [req setValidatesSecureCertificate:NO];
#endif
    [req startAsynchronous];
}

- (void)execFailed:(int)failCode
{
    // if the delegate can handle the failed message, let it handle.
    if ([delegate respondsToSelector:@selector(execFailed:withFailCode:)])
    {
        // If the delegate did handle the fail message, we exit here.
        if ([delegate execFailed:self withFailCode:failCode])
            return;
    }
    // Fall back to the standard handling, show the message in the alert box
    NSString* message = [self localizedDescription:failCode];
    NSLog(@"Failed while executing command: %@", message);
    [APCWindow alert:message];
}

- (void)execError:(NSError*)error
{
    // if the delegate can handle the error message, let it handle.
    if ([delegate respondsToSelector:@selector(execError:withError:)])
    {
        // If the delegate says it's handled, we'll exit.
        if ([delegate execError:self withError:error])
            return;
    }
    // Standard handling: show the error message in the alert box.
    NSString* errorStr = [error localizedDescription];
    NSLog(@"Error while executing command: %@", errorStr);
    [APCWindow alert:errorStr];
}

@end
