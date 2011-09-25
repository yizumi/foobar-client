//
//  APCRoundRect.h
//  FooBar
//
//  Created by 泉 雄介 on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor whiteColor]
#define kDefaultRectColor           [UIColor whiteColor]
#define kDefaultStrokeWidth         1.0
#define kDefaultCornerRadius        30.0

@interface APCRoundRect : UIView {
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;
}

@property (retain, nonatomic) UIColor *strokeColor;
@property (retain, nonatomic) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGFloat cornerRadius;

@end
