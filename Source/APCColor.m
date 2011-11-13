//
//  APCColor.m
//  foobar
//
//  Created by 泉 雄介 on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCColor.h"


@implementation APCColor

+ (UIColor *)colorWithHex:(NSString *)hex
{
    NSString* colorStr = [NSString stringWithFormat:@"0x%@ 0x%@ 0x%@",
                          [hex substringWithRange:NSMakeRange(0,2)],
                          [hex substringWithRange:NSMakeRange(2,2)],
                          [hex substringWithRange:NSMakeRange(4,2)]];
    unsigned red, green, blue;
    NSScanner *scanner = [NSScanner scannerWithString:colorStr];
    if ([scanner scanHexInt:&red] &&
        [scanner scanHexInt:&green] &&
        [scanner scanHexInt:&blue])
    {
        return [[[UIColor alloc] initWithRed:(float)red/0xff 
                                       green:(float)green/0xff 
                                        blue:(float)blue/0xff 
                                       alpha:1] autorelease];
    }
    return nil;
}

@end
