//
//  ShopListCell.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShop.h"

@interface ShopListCell : UITableViewCell {
    FBShop* _shopInfo;
    UILabel* _titleLabel;
    UILabel* _pointLabel;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UILabel* pointLabel;
@property (nonatomic, retain) FBShop* shopInfo;

@end
