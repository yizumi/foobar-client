//
//  FBStoreManager.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBStoreManager.h"
#import "SBJson.h"
#import "APCDateUtil.h"

@implementation FBStoreManager

static FBStoreManager *_sharedInstance = nil;

+ (FBStoreManager *) sharedInstance
{
    if( !_sharedInstance )
    {
        _sharedInstance = [[FBStoreManager alloc] init];
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
    
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBStore.sqlite"];
    NSDictionary* options = [[NSDictionary alloc]initWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES],
                                NSInferMappingModelAutomaticallyOption,
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

- (FBStore *) insertNew
{
    FBStore *store = [NSEntityDescription insertNewObjectForEntityForName:@"FBStore" inManagedObjectContext:self.context];
    return store;
}

- (void) commit
{
    NSError *error;
    if (![self.context save:&error])
    {
        NSLog(@"Error while commiting changes: %@", error);
    }
}

- (NSArray *) stores
{
    NSFetchRequest *request;
    NSEntityDescription *description;
    NSSortDescriptor *sort;
    request = [[[NSFetchRequest alloc] init] autorelease];
    description = [NSEntityDescription entityForName:@"FBStore" inManagedObjectContext:self.context];
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
// refreshes the persisted store information with the given list of
// dictionaries.
//
- (void) updateWithList:(NSArray*)stores
{
    [stores forEach:^(id item) {
        NSDictionary* dict = (NSDictionary*)item;
        // Deserialize the object
        [self updateWithDictionary:dict];
    }];
}

// 
// refreshes the persited store information with the given dictionary object.
//
- (void) updateWithDictionary:(NSDictionary *)obj
{
    // See if the data exists already
    NSString* identifier = (NSString *)[obj objectForKey:@"identifier"];
    FBStore* store = [self getByIdentifier:identifier];
    
    // If not, insert a new record
    if( store == nil )
    {
        store = [self insertNew];
        store.identifier = (NSString*)[obj valueForKey:@"identifier"];
    }
    
    // Update the record
    store.name = (NSString*)[obj valueForKey:@"name"];
    store.address = (NSString*)[obj valueForKey:@"address"];
    store.url = (NSString*)[obj valueForKey:@"url"];
    store.firstVisit = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"firstVisit"]];
    store.lastVisit = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"lastVisit"]];
    store.points = (NSNumber*)[obj valueForKey:@"points"];
    store.tel = (NSString*)[obj valueForKey:@"tel"];
    store.imageUrl = (NSString*)[obj valueForKey:@"imageUrl"];
    
    // Commit
    [self commit];
    NSLog(@"Saved StoreInfo for %@", store.name);
}

- (void) updateStoreRedeemToken:(NSString*)token 
                  andExpiration:(NSDate*)expDate 
                       forStore:(NSString*)identifier
{
    FBStore* store = [self getByIdentifier:identifier];
    if (store == nil )
    {
        NSLog(@"Error: Could not find store by identifier: %@", identifier);
        return;
    }
    
    store.redeemToken = token;
    store.redeemTokenExpiration = expDate;
    
    [self commit];
    NSLog(@"Saved redemption code for %@", identifier);
}

// Returns StoreInfo for the given identifier.
// Returns nil if not found.
- (FBStore *) getByIdentifier:(NSString *)identifier
{
    NSFetchRequest *request;
    NSEntityDescription *description;
    NSSortDescriptor *sort;
    NSPredicate *predicate;
    
    request = [[[NSFetchRequest alloc] init] autorelease];
    description = [NSEntityDescription entityForName:@"FBStore" inManagedObjectContext:self.context];
    sort = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    
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
        FBStore* store = (FBStore*)[result objectAtIndex:0];
        return store;
    }
    else
    {
        return nil;
    }
}

/// Use this to fetch store info for TableListView
- (NSFetchedResultsController*) fetchStoreInfos
{
    NSFetchRequest* req = [[[NSFetchRequest alloc]init] autorelease];
    
    // Entity Descriptor
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"FBStore" inManagedObjectContext:self.context];
    [req setEntity:entity];
    
    // Sort Descriptor
    NSSortDescriptor* sort = [[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES] autorelease];
    [req setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    // Fetch Controller
    NSFetchedResultsController* frc = [[[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                          managedObjectContext:self.context
                                                                            sectionNameKeyPath:@"sectionName"
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
