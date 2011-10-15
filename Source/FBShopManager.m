//
//  FBShopManager.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBShopManager.h"
#import "SBJson.h"
#import "APCDateUtil.h"
#import "FBShopExt.h"

@implementation FBShopManager

static FBShopManager *_sharedInstance = nil;

+ (FBShopManager *) sharedInstance
{
    if( !_sharedInstance )
    {
        _sharedInstance = [[FBShopManager alloc] init];
    }
    return _sharedInstance;
}


- (NSManagedObjectContext *) context
{
    if( _context != nil )
    {
        return _context;
    }
    
    NSManagedObjectModel* model;
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *coordinator;
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBShop.sqlite"];
    NSDictionary* options = [[NSDictionary alloc]initWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    NSPersistentStore *store;
    NSError *error;
    
    store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                      configuration:nil 
                                                URL:url 
                                            options:options 
                                              error:&error];
    
    if( !store && error )
    {
        NSLog(@"Failed to create add persistent store, %@", [error localizedDescription]);
    }
    
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:coordinator];
    
    // coordinator -- to be released
    [coordinator release];
    
    return _context;
}

- (FBShop *) insertNew
{
    FBShop *shop = [NSEntityDescription insertNewObjectForEntityForName:@"FBShop" inManagedObjectContext:self.context];
    return shop;
}

- (void) commit
{
    NSError *error;
    if (![self.context save:&error])
    {
        NSLog(@"Error while commiting changes: %@", error);
    }
}

- (NSArray *) shops
{
    NSFetchRequest *request;
    NSEntityDescription *description;
    NSSortDescriptor *sort;
    request = [[[NSFetchRequest alloc] init] autorelease];
    description = [NSEntityDescription entityForName:@"FBShop" inManagedObjectContext:self.context];
    [request setEntity:description];
    sort = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *result;
    NSError *error = nil;
    result = [self.context executeFetchRequest:request error:&error];
    if( !result )
    {
        NSLog(@"execute failed, %@", [error localizedDescription]);
        return nil;
    }
    
    return result;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//
// refreshes the persisted shop information with the given list of
// dictionaries.
//
- (void) updateWithList:(NSArray*)shops
{
    [shops forEach:^(id item) {
        NSDictionary* dict = (NSDictionary*)item;
        // Deserialize the object
        [self updateWithDictionary:dict];
    }];
}

// 
// refreshes the persited shop information with the given dictionary object.
//
- (void) updateWithDictionary:(NSDictionary *)obj
{
    // See if the data exists already
    NSNumber* shopKey = (NSNumber *)[obj objectForKey:@"key"];
    FBShop* shop = [self getByIdentifier:shopKey];
    
    // If not, insert a new record
    if( shop == nil )
    {
        shop = [self insertNew];
        shop.key = (NSNumber*)[obj valueForKey:@"key"];
    }
    
    // Update the record
    shop.name = (NSString*)[obj valueForKey:@"name"];
    shop.address = (NSString*)[obj valueForKey:@"address"];
    shop.url = (NSString*)[obj valueForKey:@"url"];
    shop.firstVisit = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"firstVisit"]];
    shop.lastVisit = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"lastVisit"]];
    shop.points = (NSNumber*)[obj valueForKey:@"points"];
    shop.tel = (NSString*)[obj valueForKey:@"tel"];
    shop.imageUrl = (NSString*)[obj valueForKey:@"imageUrl"];
    shop.sectionTitle = [shop.name substringToIndex:1];

    // Commit
    [self commit];
    NSLog(@"Saved ShopInfo for %@ with sectionTitle %@", shop.name, shop.sectionTitle);
}

- (void) updateShopRedeemToken:(NSString*)token 
                 andExpiration:(NSDate*)expDate 
                       forShop:(NSNumber*)shopKey
{
    FBShop* shop = [self getByIdentifier:shopKey];
    if (shop == nil )
    {
        NSLog(@"Error: Could not find shop by identifier: %@", shopKey);
        return;
    }
    
    shop.redeemToken = token;
    shop.redeemTokenExpiration = expDate;
    
    [self commit];
    NSLog(@"Saved redemption code for %@", shopKey);
}

// Returns ShopInfo for the given identifier.
// Returns nil if not found.
- (FBShop *) getByIdentifier:(NSNumber *)shopKey
{
    NSFetchRequest *request;
    NSEntityDescription *description;
    NSSortDescriptor *sort;
    NSPredicate *predicate;
    
    request = [[[NSFetchRequest alloc] init] autorelease];
    description = [NSEntityDescription entityForName:@"FBShop" inManagedObjectContext:self.context];
    sort = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    predicate = [NSPredicate predicateWithFormat:@"key == %@", shopKey];
    
    [request setEntity:description];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setPredicate:predicate];
    
    NSArray *result;
    NSError *error = nil;
    result = [self.context executeFetchRequest:request error:&error];
    if( !result )
    {
        NSLog(@"execute failed, %@", [error localizedDescription]);
        return nil;
    }
    
    if( [result count] > 0 )
    {
        FBShop* shop = (FBShop*)[result objectAtIndex:0];
        return shop;
    }
    else
    {
        return nil;
    }
}

/// Use this to fetch shop info for TableListView
- (NSFetchedResultsController*) fetchShopInfos
{
    NSFetchRequest* req = [[[NSFetchRequest alloc]init] autorelease];
    
    // Entity Descriptor
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"FBShop" inManagedObjectContext:self.context];
    [req setEntity:entity];
    
    // Sort Descriptor
    NSSortDescriptor* sort = [[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES] autorelease];
    [req setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    // Fetch Controller
    NSFetchedResultsController* frc = [[[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                          managedObjectContext:self.context
                                                                            sectionNameKeyPath:@"sectionTitle"
                                                                                      cacheName:@"Root"] autorelease];
    // Now perform fetch on the controller
    NSError* error;
    if( [frc performFetch:&error] == YES)
    {
        return frc;
    }
    else
    {
        NSLog( @"Oh no.. there is an error! %@", [error localizedDescription]);
        return nil;
    }
}

@end
