//
//  StoreInfoManager.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreInfoManager.h"
#import "SBJson.h"

@implementation StoreInfoManager

static StoreInfoManager *_sharedInstance = nil;

+ (StoreInfoManager *) sharedInstance
{
    if( !_sharedInstance )
    {
        _sharedInstance = [[StoreInfoManager alloc] init];
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
    
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FoobarStores.sqlite"];
    
    NSPersistentStore *store;
    NSError *error;
    
    store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                      configuration:nil 
                                                URL:url 
                                            options:nil 
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

- (StoreInfo *) insertNew
{
    StoreInfo *store = [NSEntityDescription insertNewObjectForEntityForName:@"StoreInfo" inManagedObjectContext:self.context];
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
    description = [NSEntityDescription entityForName:@"StoreInfo" inManagedObjectContext:self.context];
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

- (void) refreshListWith:(NSArray*)stores
{
    [stores forEach:^(id item) {
        NSDictionary* dict = (NSDictionary*)item;
        // Deserialize the object
        [self updateWithDictionary:dict];
        
    }];
}

- (void) updateWithDictionary:(NSDictionary *)obj
{
    StoreInfoManager *mgr = [StoreInfoManager sharedInstance];
    
    // See if the data exists already
    NSString *identifier = (NSString *)[obj objectForKey:@"identifier"];
    StoreInfo *store = [mgr getByIdentifier:identifier];
    
    // If not, insert a new record
    if( store == nil )
    {
        store = [mgr insertNew];
    }
    
    // Update the record
    
    
    // Commit
    [mgr commit];
}

- (StoreInfo *) getByIdentifier:(NSString *)identifier
{
    NSFetchRequest *request;
    NSEntityDescription *description;
    NSSortDescriptor *sort;
    NSPredicate *predicate;
    
    request = [[[NSFetchRequest alloc] init] autorelease];
    description = [NSEntityDescription entityForName:@"StoreInfo" inManagedObjectContext:self.context];
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
    
    StoreInfo* store = (StoreInfo*)[result objectAtIndex:0];
    return store;    
}


@end
