//
//  FBCodeButton.h
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIButton.h>


@interface FBCodeButton : UIButton {
    BOOL _isChecked;
    NSString* _origTitle;
}

@property (nonatomic, setter = setChecked:) BOOL isChecked;

- (NSString*) getOrigTitle;
- (void) setChecked:(BOOL)checked withTitle:(NSString*)title;

@end
