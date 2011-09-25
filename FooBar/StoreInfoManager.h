//
//  StoreInfoManager.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSManagedObjectContext.h>
#import "StoreInfo.h"
#import "APCArray.h"

@interface StoreInfoManager : NSObject {
    NSManagedObjectContext *_context;
}

@property (readonly, nonatomic) NSManagedObjectContext *context;

+ (StoreInfoManager *) sharedInstance;

- (StoreInfo *) insertNew;
- (void) commit;
- (NSArray *) stores;
- (NSURL *)applicationDocumentsDirectory;

- (void) refreshListWith:(NSArray*)array;
- (void) updateWithDictionary:(NSDictionary*)obj;
- (StoreInfo *) getByIdentifier:(NSString *)identifier;

@end
