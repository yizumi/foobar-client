//
//  StoreListCellController.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListCell.h"

@interface StoreListCellController : UIViewController {
    StoreListCell* _cell;
}

@property (nonatomic, retain) IBOutlet StoreListCell* cell;

@end
