//
//  TransactionInfoService.h
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APCDataModelService.h"
#import "FBCommandBase.h"

@class TransactionInfoService;

@protocol TransactionInfoServiceDelegate <NSObject>

- (void) service:(TransactionInfoService*)service onSuccess:(BOOL)success hasMore:(BOOL)hasMore;

@end

// Good stuff
@interface TransactionInfoService : APCDataModelService
    <FBCommandBaseDelegate>
{
}

// retrieves a handler to the services
+ (TransactionInfoService*) sharedInstance;

// initializes an objects with default values
- (id) init;

// Fetches all items from the local database
- (NSFetchedResultsController*) fetchAll;

// Asynchronously synchronizes the local data with the remote persistence
- (void) synchronizeData:(int)page withDelegate:(id<TransactionInfoServiceDelegate>)delegate;

// Marks the item as canelled
- (void) markItemAsCancelled:(NSNumber*)key;

@end
