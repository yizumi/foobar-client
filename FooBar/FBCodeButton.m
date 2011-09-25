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

//
- (void) setChecked:(BOOL) checked;
{
    _isChecked = checked;
    if( _isChecked )
    {
        [self setSelected:checked];
        [self setBackgroundImage:[UIImage imageNamed:kIMAGE_TOGGLE_ON] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [self setSelected:checked];
        [self setBackgroundImage:[UIImage imageNamed:kIMAGE_TOGGLE_OFF] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

@end
