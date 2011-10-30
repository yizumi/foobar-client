//
//  APCDataModelService.h
//  foobar
//
//  Created by 泉 雄介 on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "APCDataModel.h"

@interface APCDataModelService : NSObject
{
    @private
    NSManagedObjectContext* _context;
    NSString* _tableName;
}

@property (readonly, nonatomic) NSManagedObjectContext* context;
@property (nonatomic, retain) NSString* tableName;

+ (NSURL *)applicationDocumentsDirectory;
- (id) initWithTableName:(NSString*) tableName;
- (APCDataModel*) insertNew;
- (APCDataModel*) getByKey:(NSNumber*)key;
- (void) commit;

- (void) updateWithList:(NSArray*)array;
- (void) updateWithDictionary:(NSDictionary*)obj;
- (void) buildDataModel:(APCDataModel*)model from:(NSDictionary*)dict;
- (NSFetchedResultsController*) fetchAllSortBy:(NSString*)sortFld withSectionTitle:(NSString*)sectionFld;

@end
