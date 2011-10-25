//
//  ShopListCell.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"

@interface ShopListCell : UITableViewCell {
    ShopInfo* _shopInfo;
    UILabel* _titleLabel;
    UILabel* _pointLabel;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UILabel* pointLabel;
@property (nonatomic, retain) ShopInfo* shopInfo;

@end
