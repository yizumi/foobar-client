//
//  TextFormCell.m
//  foobar
//
//  Created by 泉 雄介 on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFormCell.h"


@implementation TextFormCell

@synthesize titleLabel;
@synthesize textField;

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
    NSLog(@"Deallocating TextFormCell");
    [titleLabel release];
    [textField release];
    [super dealloc];
}

@end
