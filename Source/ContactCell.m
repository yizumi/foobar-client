//
//  ContactCell.m
//  foobar
//
//  Created by 泉 雄介 on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactCell.h"


@implementation ContactCell

@synthesize labelType;
@synthesize labelInfo;
@synthesize labelAction;


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
    [super dealloc];
}

@end
