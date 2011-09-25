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
}

@property (nonatomic, setter = setChecked:) BOOL isChecked;

- (void) setChecked:(BOOL) checked;

@end
