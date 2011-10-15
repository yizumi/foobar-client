//
//  ShopViewCell.m
//  foobar
//
//  Created by 泉 雄介 on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopViewCell.h"

@implementation ShopViewCell

@synthesize nameLabel = _nameLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize hoursLabel = _hoursLabel;
@synthesize image = _image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_nameLabel release];
    [_pointsLabel release];
    [_hoursLabel release];
    [_image release];
    [super dealloc];
}

@end
