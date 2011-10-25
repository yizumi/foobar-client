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
#import "ShopInfo.h"
#import "APCArray.h"

@interface ShopInfoService : NSObject {
    NSManagedObjectContext *_context;
}

@property (readonly, nonatomic) NSManagedObjectContext *context;

+ (ShopInfoService *) sharedInstance;

- (ShopInfo *) insertNew;
- (void) commit;
- (NSArray *) shops;
- (NSURL *)applicationDocumentsDirectory;

- (void) updateWithList:(NSArray*)array;
- (void) updateWithDictionary:(NSDictionary*)obj;
- (void) updateShopRedeemToken:(NSString*)token 
                  andExpiration:(NSDate*)expDate 
                       forShop:(NSNumber*)shopKey;
- (ShopInfo *) getByIdentifier:(NSNumber*)shopKey;
- (NSFetchedResultsController*) fetchShopInfos;

@end
