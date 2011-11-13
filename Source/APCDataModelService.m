//
//  APCDataModelService.m
//  foobar
//
//  Created by 泉 雄介 on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCDataModelService.h"
#import "APCArray.h"
#import "TransactionInfoExt.h"

@implementation APCDataModelService

@synthesize context = _context;
@synthesize tableName = _tableName;

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (id) initWithTableName:(NSString*)tblName
{
    if (self != nil)
    {
        self.tableName = tblName;
    }
    return self;
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
    
    NSURL *url = [[APCDataModelService applicationDocumentsDirectory] 
                  URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",_tableName]];
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

- (APCDataModel*) insertNew
{
    APCDataModel *model = [NSEntityDescription insertNewObjectForEntityForName:_tableName
                                                        inManagedObjectContext:self.context];
    return model;
}

- (void) commit
{
    NSError *error;
    if (![self.context save:&error])
    {
        NSLog(@"Error while commiting changes: %@", error);
    }
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
- (void) updateWithDictionary:(NSDictionary *)dict
{
    // See if the data exists already
    NSNumber* key = (NSNumber *)[dict objectForKey:@"key"];
    APCDataModel* model = [self getByKey:key];
    
    // If not, insert a new record
    if (model == nil)
    {
        model = [self insertNew];
        model.key = (NSNumber*)[dict valueForKey:@"key"];
    }
    
    // Update the record
    [self buildDataModel:model from:dict];
    
    // Commit
    [self commit];
    NSLog(@"Saved %@ with key %@", _tableName, model.key);
}

- (void)buildDataModel:(APCDataModel *)model from:(NSDictionary *)dict
{
    // to be implemented by the subclass.
}

// Returns ShopInfo for the given identifier.
// Returns nil if not found.
- (APCDataModel*) getByKey:(NSNumber*)key
{
    NSFetchRequest *request;
    NSEntityDescription *description;
    NSSortDescriptor *sort;
    NSPredicate *predicate;
    
    request = [[[NSFetchRequest alloc] init] autorelease];
    description = [NSEntityDescription entityForName:_tableName inManagedObjectContext:self.context];
    sort = [[[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES] autorelease];
    predicate = [NSPredicate predicateWithFormat:@"key == %@", key];
    
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
        APCDataModel* model = (APCDataModel*)[result objectAtIndex:0];
        return model;
    }
    else
    {
        return nil;
    }
}

- (void) dealloc
{
    [_context release];
    [_tableName release];
    [super dealloc];
}

- (NSFetchRequest*) createBaseRequest:(NSString*)sortFld ascending:(BOOL)ascending
{
    // The request
    NSFetchRequest* req = [[[NSFetchRequest alloc]init] autorelease];

    // Entity Descriptor
    NSEntityDescription* entity = [NSEntityDescription entityForName:_tableName inManagedObjectContext:self.context];
    [req setEntity:entity];
    
    // Set the Sort Descriptor, if specified
    if (sortFld != nil)
    {
        NSSortDescriptor* sort = [[[NSSortDescriptor alloc]initWithKey:sortFld
                                                             ascending:ascending] autorelease];
        [req setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    return req;
}

/// Use this to fetch shop info for TableListView
- (NSFetchedResultsController*) fetchAllSortBy:(NSString*)sortFld
                                     ascending:(BOOL)ascending 
                              withSectionTitle:(NSString*)sectionFld
{
    NSFetchRequest* req = [self createBaseRequest:sortFld ascending:ascending];
    
    // Fetch Controller
    NSFetchedResultsController* frc = [[[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                           managedObjectContext:self.context
                                                                             sectionNameKeyPath:sectionFld
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

- (NSNumber*) getMaxOf:(NSString*)field
{
    return [self get:@"max" ofField:field];
}

- (NSNumber*) getMinOf:(NSString*)field
{
    return [self get:@"min" ofField:field];
}

- (NSNumber*) getSumOf:(NSString*)field
{
    return [self get:@"sum" ofField:field];
}

- (NSNumber*) getAvgOf:(NSString*)field
{
    return [self get:@"avg" ofField:field];
}

- (NSNumber*) get:(NSString*)fnc ofField:(NSString*)field
{
    NSFetchRequest* req = [self createBaseRequest:nil ascending:YES];
    [req setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:field];
    NSExpression *exp = [NSExpression expressionForFunction:[NSString stringWithFormat:@"%@:", fnc]
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expDesc = [[[NSExpressionDescription alloc] init] autorelease];
    [expDesc setName:@"result"];
    [expDesc setExpression:exp];
    // [expDesc setExpressionResultType:(NSAttributeType)];
    
    [req setPropertiesToFetch:[NSArray arrayWithObject:expDesc]];
    
    NSError* error = nil;
    NSArray* objects = [self.context executeFetchRequest:req error:&error];
    if (error)
    {
        NSLog(@"Error while fetching aggregate result: %@", error);
    }
    else
    {
       if ([objects count] > 0)
       {
           NSNumber* result = (NSNumber*)[[objects objectAtIndex:0] objectForKey:@"result"];
           return result;
       }
    }
    return nil;
}

@end
