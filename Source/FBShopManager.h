//
//  FBShopManager.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSManagedObjectContext.h>
#import "FBShop.h"
#import "FBShopExt.h"
#import "APCArray.h"

@interface FBShopManager : NSObject {
    NSManagedObjectContext *_context;
}

@property (readonly, nonatomic) NSManagedObjectContext *context;

+ (FBShopManager *) sharedInstance;

- (FBShop *) insertNew;
- (void) commit;
- (NSArray *) shops;
- (NSURL *)applicationDocumentsDirectory;

- (void) updateWithList:(NSArray*)array;
- (void) updateWithDictionary:(NSDictionary*)obj;
- (void) updateShopRedeemToken:(NSString*)token 
                  andExpiration:(NSDate*)expDate 
                       forShop:(NSNumber*)shopKey;
- (FBShop *) getByIdentifier:(NSNumber*)shopKey;
- (NSFetchedResultsController*) fetchShopInfos;

@end
