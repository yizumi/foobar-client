//
//  StoreListViewController.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface StoreListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController* _fetchedResults;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResults;

@end
