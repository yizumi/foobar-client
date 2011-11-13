//
//  HistoryCell.h
//  foobar
//
//  Created by 泉 雄介 on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionInfo.h"

@interface HistoryCell : UITableViewCell
{    
    UILabel* dateLabel;
    UILabel* addOrRedeemLabel;
    UILabel* shopNameLabel;
    UILabel* pointsLabel;
}

- (void) bind:(TransactionInfo*) trans;

@property (nonatomic, retain) IBOutlet UILabel* dateLabel;
@property (nonatomic, retain) IBOutlet UILabel* addOrRedeemLabel;
@property (nonatomic, retain) IBOutlet UILabel* shopNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* pointsLabel;


@end
