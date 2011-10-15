//
//  ImageFormCell.m
//  foobar
//
//  Created by 泉 雄介 on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageFormCell.h"


@implementation ImageFormCell

@synthesize titleLabel;
@synthesize imageView;

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
    [titleLabel release];
    [imageView release];
    [super dealloc];
}


@end
