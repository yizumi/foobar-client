//
//  FBCodeButton.m
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBCodeButton.h"

static NSString* kIMAGE_TOGGLE_ON = @"FBCodeButtonOn.png";
static NSString* kIMAGE_TOGGLE_OFF = @"FBCodeButtonOff.png";

@implementation FBCodeButton

@synthesize isChecked = _isChecked;

- (void)dealloc
{
    // [_origTitle release];
    [super dealloc];
}

// when asked for title, secretly retain the original title.
// 
- (NSString*) getOrigTitle
{
    if (_origTitle == nil)
    {
        _origTitle = [self.titleLabel text];
    }
    return _origTitle;
}

//
- (void) setChecked:(BOOL)checked withTitle:(NSString*)title
{
    _isChecked = checked;
    if( _isChecked )
    {
        [self setSelected:checked];
        [self setBackgroundImage:[UIImage imageNamed:kIMAGE_TOGGLE_ON] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setText: title];
        [self setTitle:title forState:UIControlStateSelected];
    }
    else
    {
        [self setSelected:checked];
        [self setBackgroundImage:[UIImage imageNamed:kIMAGE_TOGGLE_OFF] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

@end
