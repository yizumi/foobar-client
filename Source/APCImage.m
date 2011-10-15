//
//  APCImage.m
//  foobar
//
//  Created by 泉 雄介 on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCImage.h"


@implementation UIImage (APCImage)

- (UIImage*)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
