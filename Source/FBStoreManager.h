//
//  FBStoreManager.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSManagedObjectContext.h>
#import "FBStore.h"
#import "FBStoreExt.h"
#import "APCArray.h"

@interface FBStoreManager : NSObject {
    NSManagedObjectContext *_context;
}

@property (readonly, nonatomic) NSManagedObjectContext *context;

+ (FBStoreManager *) sharedInstance;

- (FBStore *) insertNew;
- (void) commit;
- (NSArray *) stores;
- (NSURL *)applicationDocumentsDirectory;

- (void) updateWithList:(NSArray*)array;
- (void) updateWithDictionary:(NSDictionary*)obj;
- (void) updateStoreRedeemToken:(NSString*)token 
                  andExpiration:(NSDate*)expDate 
                       forStore:(NSString*)identifier;
- (FBStore *) getByIdentifier:(NSString *)identifier;
- (NSFetchedResultsController*) fetchStoreInfos;

@end
