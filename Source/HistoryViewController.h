//
//  HistoryViewController.h
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TransactionInfoService.h"

@interface HistoryViewController : UITableViewController
    <TransactionInfoServiceDelegate>
{
    @private
    int page;
    BOOL canLoadMore;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResults;

@end
