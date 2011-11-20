//
//  HistoryViewController.h
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TransactionInfo.h"
#import "TransactionInfoService.h"

@interface HistoryViewController : UITableViewController
    <TransactionInfoServiceDelegate,FBCommandBaseDelegate>
{
    @private
    int page;
    BOOL canLoadMore;
}

+ (BOOL) isShopRecord:(TransactionInfo*)tran;

@property (nonatomic, retain) NSFetchedResultsController* fetchedResults;

@end
