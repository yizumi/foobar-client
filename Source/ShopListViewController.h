//
//  ShopListViewController.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FBCommandBase.h"

@interface ShopListViewController : UITableViewController
    <NSFetchedResultsControllerDelegate,FBCommandBaseDelegate>
{
    NSFetchedResultsController* _fetchedResults;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResults;

- (void)refreshShopList;

@end
