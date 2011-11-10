//
//  TransactionInfoService.m
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransactionInfoService.h"
#import "TransactionInfo.h"
#import "APCDateUtil.h"
#import "FBQueryTransactions.h"
#import "FBConfig.h"
#import "TransactionInfoExt.h"

@implementation TransactionInfoService

static TransactionInfoService *_sharedInstance = nil;

+ (TransactionInfoService *) sharedInstance
{
    if( !_sharedInstance )
    {
        _sharedInstance = [[TransactionInfoService alloc] init];
    }
    return _sharedInstance;
}

- (id) init
{
    self = [super initWithTableName:@"TransactionInfo"];
    if (self != nil)
    {
        
    }
    return self;
}


- (void)buildDataModel:(APCDataModel*)model from:(NSDictionary*)obj
{
    TransactionInfo* trans = (TransactionInfo*)model;
    
    trans.key = (NSNumber*)[obj valueForKey:@"key"];
    trans.shopKey = (NSNumber*)[obj valueForKey:@"shopKey"];
    trans.userKey = (NSNumber*)[obj valueForKey:@"userKey"];
    trans.time = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"time"]];
    NSLog(@"The time string: %@ converted to: %@", [obj valueForKey:@"time"], trans.time);
    trans.addOrRedeem = (NSString*)[obj valueForKey:@"addOrRedeem"];
    trans.points = (NSNumber*)[obj valueForKey:@"points"];
    if ([[obj valueForKey:@"shopMessage"] class] == [NSString class])
        trans.shopMessage = (NSString*)[obj objectForKey:@"shopMessage"];        
    else
        trans.shopMessage = nil;
    trans.shopName = (NSString*)[obj valueForKey:@"shopName"];
    trans.userName = (NSString*)[obj valueForKey:@"userName"];
}

- (NSFetchedResultsController*) fetchAll
{
    return [self fetchAllSortBy:@"time"
                      ascending:NO
               withSectionTitle:@"yearMonth"];
}

// Synchronizes the local data with remote persistence.
- (void) synchronizeData:(int)page withDelegate:(id<TransactionInfoServiceDelegate>)delegate
{
    FBQueryTransactions* cmd = [[[FBQueryTransactions alloc] init] autorelease];
    cmd.delegate = self;
    cmd.shopKey = [NSNumber numberWithLong:[[FBConfig sharedInstance] shopKey]];
    cmd.userToken = [[FBConfig sharedInstance] userToken];
    cmd.count = [NSNumber numberWithInt:25];
    cmd.page = [NSNumber numberWithInt:page];
    cmd.userObj = delegate;
    [cmd execAsync];
}

// called upon successful retrieval of data from the server.
// persist the information, and notify 
- (void)execSuccess:(id)request withResponse:(id)response
{
    if ([request class] == [FBQueryTransactions class])
    {
        // persist the received information
        NSDictionary* dict = (NSDictionary*)response;

        // update the persistence
        NSArray* items = (NSArray*)[dict objectForKey:@"transactions"];
        [super updateWithList:items];
        
        // Get the flag indicating whether there are more items to be loaded.
        BOOL hasMore = [(NSNumber*)[dict valueForKey:@"hasMore"] boolValue];
        
        // Get the delegate from the request
        id<TransactionInfoServiceDelegate> delegate = 
            (id<TransactionInfoServiceDelegate>)[request userObj];
        
        // Invoke method on the delegate
        if ([delegate respondsToSelector:@selector(service:onSuccess:hasMore:)])
        {
            [delegate service:self onSuccess:YES hasMore:hasMore];
        }
    }
}
@end
