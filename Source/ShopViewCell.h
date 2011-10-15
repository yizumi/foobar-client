//
//  ShopViewCell.h
//  foobar
//
//  Created by 泉 雄介 on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopViewCell : UITableViewCell {
    UILabel* _nameLabel;
    UILabel* _pointsLabel;
    UILabel* _hoursLabel;
    UIImageView* _image;
}

@property (retain,nonatomic) IBOutlet UILabel* nameLabel;
@property (retain,nonatomic) IBOutlet UILabel* pointsLabel;
@property (retain,nonatomic) IBOutlet UILabel* hoursLabel;
@property (retain,nonatomic) IBOutlet UIImageView* image;

@end
